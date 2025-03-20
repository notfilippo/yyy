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
            .array => |value| value.deinit(),
            else => {},
        }
    }

    pub fn dataType(self: Self) schema.DataType {
        return switch (self) {
            inline else => |value| std.meta.activeTag(value),
        };
    }

    const Error = std.mem.Allocator.Error || error{Invalid};
};

pub const Array = union(schema.DataType) {
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

    pub fn deinit(self: Self) void {
        switch (self) {
            inline else => |array| array.deinit(),
        }
    }
};

pub const Scalar = union(schema.DataType) {
    const Self = @This();

    boolean: bool,
    i8: i8,
    i16: i16,
    i32: i32,
    i64: i64,
    u8: u8,
    u16: u16,
    u32: u32,
    u64: u64,
    f16: f16,
    f32: f32,
    f64: f64,
    binary: []const u8,
};

pub fn cmp_do(comptime dt: schema.DataType, comptime op: anytype, left: Datum, right: Datum, allocator: std.mem.Allocator) Datum.Error!Datum {
    if (left == .scalar and right == .scalar) {
        return Datum{ .scalar = Scalar{ .boolean = @call(.always_inline, op, .{
            bool,
            @field(left.scalar, @tagName(dt)),
            @field(right.scalar, @tagName(dt)),
        }) } };
    }

    const array = switch (left) {
        .array => |lvalue| switch (right) {
            inline else => |rvalue| try compare.kernel(dt.toType(), 8, op, @field(lvalue, @tagName(dt)), @field(rvalue, @tagName(dt)), allocator),
        },
        .scalar => |lvalue| switch (right) {
            .array => |rvalue| try compare.kernel(dt.toType(), 8, op, @field(lvalue, @tagName(dt)), @field(rvalue, @tagName(dt)), allocator),
            .scalar => unreachable, // handled above
        },
    };

    return Datum{ .array = Array{ .boolean = array } };
}

pub fn cmp(comptime op: anytype, left: Datum, right: Datum, allocator: std.mem.Allocator) Datum.Error!Datum {
    const ltag = switch (left) {
        .array => |value| std.meta.activeTag(value),
        .scalar => |value| std.meta.activeTag(value),
    };

    const rtag = switch (left) {
        .array => |value| std.meta.activeTag(value),
        .scalar => |value| std.meta.activeTag(value),
    };

    if (ltag != rtag) {
        return Datum.Error.Invalid;
    }

    return switch (ltag) {
        .boolean => Datum.Error.Invalid,
        .binary => Datum.Error.Invalid,
        inline else => |tag| cmp_do(tag, op, left, right, allocator),
    };
}
