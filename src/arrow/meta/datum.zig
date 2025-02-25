const std = @import("std");
const assert = std.debug.assert;
const primitive = @import("../array/primitive.zig");
const schema = @import("schema.zig");
const compare = @import("../compute/compare.zig");

pub const Datum = union(enum) {
    const Self = @This();

    array: Array,
    scalar: Scalar,

    pub fn dataType(self: Self) schema.DataType {
        switch (self) {
            inline .array => |array| return array.dt,
            inline .scalar => |scalar| return scalar.dataType(),
        }
    }
};

pub const Array = struct {
    const Self = @This();

    inner: *anyopaque,
    dt: schema.DataType,

    pub fn datum(self: Self) Datum {
        return Datum{ .array = self };
    }
};

pub const Scalar = union(enum) {
    const Self = @This();

    null,
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
    utf8: ?[]const u8,
    binary: ?[]const u8,

    pub fn datum(self: Self) Datum {
        return Datum{ .scalar = self };
    }

    pub fn dataType(self: Self) schema.DataType {
        switch (self) {
            inline .null => return schema.DataType.null,
            inline .boolean => return schema.DataType.boolean,
            inline .i8 => return schema.DataType.i8,
            inline .i16 => return schema.DataType.i16,
            inline .i32 => return schema.DataType.i32,
            inline .i64 => return schema.DataType.i64,
            inline .u8 => return schema.DataType.u8,
            inline .u16 => return schema.DataType.u16,
            inline .u32 => return schema.DataType.u32,
            inline .u64 => return schema.DataType.u64,
            inline .f16 => return schema.DataType.f16,
            inline .f32 => return schema.DataType.f32,
            inline .f64 => return schema.DataType.f64,
            inline .utf8 => return schema.DataType.utf8,
            inline .binary => return schema.DataType.binary,
        }
    }
};

pub fn eq(left: Datum, right: Datum, allocator: std.mem.Allocator) !Datum {
    std.debug.print("{any} {any}", .{ left, right });

    const l = switch (left) {
        .array => |array| array.inner,
        .scalar => unreachable,
    };

    const r = switch (right) {
        .array => |array| array.inner,
        .scalar => unreachable,
    };

    switch (left.dataType()) {
        .i32 => {
            const lhs = @as(*primitive.PrimitiveArray(i32), @ptrCast(@alignCast(l)));
            const rhs = @as(*primitive.PrimitiveArray(i32), @ptrCast(@alignCast(r)));
            const array = try compare.kernel(i32, 8, compare.eq, lhs.*, rhs.*, allocator);
            return Datum{ .array = Array{ .inner = @as(*anyopaque, &array), .dt = schema.DataType.boolean } };
        },
        else => unreachable,
    }
}
