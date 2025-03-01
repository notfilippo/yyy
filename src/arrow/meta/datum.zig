const std = @import("std");
const assert = std.debug.assert;

const binary = @import("../array/binary.zig");
const boolean = @import("../array/boolean.zig");
const primitive = @import("../array/primitive.zig");
const compare = @import("../compute/compare.zig");
const schema = @import("schema.zig");

pub const Datum = union(enum) {
    const Self = @This();

    array: Array,
    scalar: Scalar,

    pub fn deinit(self: Self) void {
        switch (self) {
            inline .array => |array| array.deinit(),
            inline .scalar => {},
        }
    }

    pub fn dataType(self: Self) schema.DataType {
        return switch (self) {
            inline else => |value| value.dataType(),
        };
    }
};

pub const Array = union(enum) {
    const Self = @This();

    boolean: boolean.BooleanArray,
    i8: primitive.PrimitiveArray(i8),
    i16: primitive.PrimitiveArray(i16),
    i32: primitive.PrimitiveArray(i32),
    i64: primitive.PrimitiveArray(i64),
    u8: primitive.PrimitiveArray(u8),
    u16: primitive.PrimitiveArray(u16),
    u32: primitive.PrimitiveArray(u32),
    u64: primitive.PrimitiveArray(u64),
    f16: primitive.PrimitiveArray(f16),
    f32: primitive.PrimitiveArray(f32),
    f64: primitive.PrimitiveArray(f64),
    binary: binary.BinaryArray(i32),

    pub fn datum(self: Self) Datum {
        return Datum{ .array = self };
    }

    pub fn deinit(self: Self) void {
        switch (self) {
            inline else => |array| array.deinit(),
        }
    }

    pub fn as(self: Self, comptime T: type) T {
        return switch (T) {
            boolean.BooleanArray => self.boolean,
            primitive.PrimitiveArray(i8) => self.i8,
            primitive.PrimitiveArray(i16) => self.i16,
            primitive.PrimitiveArray(i32) => self.i32,
            primitive.PrimitiveArray(i64) => self.i64,
            primitive.PrimitiveArray(u8) => self.u8,
            primitive.PrimitiveArray(u16) => self.u16,
            primitive.PrimitiveArray(u32) => self.u32,
            primitive.PrimitiveArray(u64) => self.u64,
            primitive.PrimitiveArray(f16) => self.f16,
            primitive.PrimitiveArray(f32) => self.f32,
            primitive.PrimitiveArray(f64) => self.f64,
            binary.BinaryArray(i32) => self.binary,
            else => @compileError("invalid type for array"),
        };
    }

    pub fn dataType(self: Self) schema.DataType {
        return switch (self) {
            .boolean => .boolean,
            .i8 => .i8,
            .i16 => .i16,
            .i32 => .i32,
            .i64 => .i64,
            .u8 => .u8,
            .u16 => .u16,
            .u32 => .u32,
            .u64 => .u64,
            .f16 => .f16,
            .f32 => .f32,
            .f64 => .f64,
            .binary => .binary,
        };
    }
};

pub const Scalar = union(enum) {
    const Self = @This();

    boolean: ?bool,
    i8: ?i8,
    i16: ?i16,
    i32: ?i32,
    i64: ?i64,
    u8: ?u8,
    u16: ?u16,
    u32: ?u32,
    u64: ?u64,
    f16: ?f16,
    f32: ?f32,
    f64: ?f64,
    binary: ?[]const u8,

    pub fn datum(self: Self) Datum {
        return Datum{ .scalar = self };
    }

    pub fn as(self: Self, comptime T: type) ?T {
        return switch (T) {
            bool => self.boolean,
            i8 => self.i8,
            i16 => self.i16,
            i32 => self.i32,
            i64 => self.i64,
            u8 => self.u8,
            u16 => self.u16,
            u32 => self.u32,
            u64 => self.u64,
            f16 => self.f16,
            f32 => self.f32,
            f64 => self.f64,
            []const u8 => self.binary,
            else => @compileError("invalid type for scalar"),
        };
    }

    pub fn from(comptime T: type, val: T) Self {
        return switch (T) {
            bool => Self{ .boolean = val },
            i8 => Self{ .i8 = val },
            i16 => Self{ .i16 = val },
            i32 => Self{ .i32 = val },
            i64 => Self{ .i64 = val },
            u8 => Self{ .u8 = val },
            u16 => Self{ .u16 = val },
            u32 => Self{ .u32 = val },
            u64 => Self{ .u64 = val },
            f16 => Self{ .f16 = val },
            f32 => Self{ .f32 = val },
            f64 => Self{ .f64 = val },
            []const u8 => Self{ .binary = val },
            else => @compileError("invalid type for scalar"),
        };
    }

    pub fn dataType(self: Self) schema.DataType {
        return switch (self) {
            .boolean => .boolean,
            .i8 => .i8,
            .i16 => .i16,
            .i32 => .i32,
            .i64 => .i64,
            .u8 => .u8,
            .u16 => .u16,
            .u32 => .u32,
            .u64 => .u64,
            .f16 => .f16,
            .f32 => .f32,
            .f64 => .f64,
            .binary => .binary,
        };
    }
};

fn cmp_do(
    comptime T: type,
    comptime vector_len: comptime_int,
    comptime op: anytype,
    left: Datum,
    right: Datum,
    allocator: std.mem.Allocator,
) !Datum {
    return away: switch (left) {
        .array => |larray| {
            const lhs = larray.as(primitive.PrimitiveArray(T));
            switch (right) {
                .array => |rarray| {
                    const rhs = rarray.as(primitive.PrimitiveArray(T));
                    const array = try compare.kernel(T, vector_len, op, lhs, rhs, allocator);
                    break :away Datum{ .array = Array{ .boolean = array } };
                },
                .scalar => |rscalar| {
                    const rhs = rscalar.as(T).?;
                    const array = try compare.kernel(T, vector_len, op, lhs, rhs, allocator);
                    break :away Datum{ .array = Array{ .boolean = array } };
                },
            }
        },
        .scalar => |lscalar| {
            const lhs = lscalar.as(T).?;
            switch (right) {
                .array => |rarray| {
                    const rhs = rarray.as(primitive.PrimitiveArray(T));
                    const array = try compare.kernel(T, vector_len, op, lhs, rhs, allocator);
                    break :away Datum{ .array = Array{ .boolean = array } };
                },
                .scalar => |rscalar| {
                    const rhs = rscalar.as(T).?;
                    return Datum{ .scalar = Scalar{ .boolean = op(bool, lhs, rhs) } };
                },
            }
        },
    };
}

pub fn cmp(left: Datum, right: Datum, allocator: std.mem.Allocator) !Datum {
    return switch (left.dataType()) {
        .i32 => try cmp_do(i32, 8, compare.eq, left, right, allocator),
        else => unreachable,
    };
}
