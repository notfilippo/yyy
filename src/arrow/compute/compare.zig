const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const math = std.math;

const buffer = @import("../array/buffer.zig");
const PrimitiveArray = @import("../array/primitive.zig").PrimitiveArray;
const BooleanArray = @import("../array/boolean.zig").BooleanArray;

pub fn eq(comptime T: type, lhs: anytype, rhs: anytype) T {
    return lhs == rhs;
}

pub fn gt(comptime T: type, lhs: anytype, rhs: anytype) T {
    return lhs > rhs;
}

pub fn lt(comptime T: type, lhs: anytype, rhs: anytype) T {
    return lhs < rhs;
}

pub fn ge(comptime T: type, lhs: anytype, rhs: anytype) T {
    return lhs >= rhs;
}

pub fn le(comptime T: type, lhs: anytype, rhs: anytype) T {
    return lhs <= rhs;
}

pub fn ne(comptime T: type, lhs: anytype, rhs: anytype) T {
    return lhs != rhs;
}

pub fn kernel(
    comptime T: type,
    comptime vector_len: comptime_int,
    comptime op: anytype,
    lhs: anytype,
    rhs: anytype,
    allocator: std.mem.Allocator,
) !BooleanArray {
    comptime assert(@TypeOf(lhs) == PrimitiveArray(T) or @TypeOf(rhs) == PrimitiveArray(T));

    // Ensure that the vector length is a multiple of 8.
    comptime assert(vector_len % 8 == 0);

    const len = if (@TypeOf(lhs) == PrimitiveArray(T)) lhs.len() else rhs.len();

    const parallel = if (vector_len > 0) len / vector_len else 0;

    const values = try buffer.BooleanBuffer.init(len, allocator);

    const PackedMask = @Type(.{ .int = .{ .bits = vector_len, .signedness = .unsigned } });

    // Execute as many SIMD vector operations as possible...

    var i: usize = 0;
    while (i < parallel) : (i += 1) {
        const start = i * vector_len;
        const end = start + vector_len;

        const lv: @Vector(vector_len, T) = switch (@TypeOf(lhs)) {
            PrimitiveArray(T) => lhs.values.slice[start..end][0..vector_len].*,
            T => @splat(lhs),
            else => @compileError("Unsupported type"),
        };

        const rv: @Vector(vector_len, T) = switch (@TypeOf(rhs)) {
            PrimitiveArray(T) => rhs.values.slice[start..end][0..vector_len].*,
            T => @splat(rhs),
            else => @compileError("Unsupported type"),
        };

        const out = @call(.always_inline, op, .{ @Vector(vector_len, bool), lv, rv });
        const mask = @as(PackedMask, @bitCast(out));

        @memcpy(values.masks.slice[buffer.BooleanBuffer.maskIndex(start)..buffer.BooleanBuffer.maskIndex(end)], std.mem.asBytes(&mask));
    }

    // ... and if left > 0, complete the calculation with scalar operations.

    const offset = i * vector_len;
    const left = len % vector_len;
    i = 0;
    while (i < left) : (i += 1) {
        const index = offset +% i;
        const lv = switch (@TypeOf(lhs)) {
            PrimitiveArray(T) => lhs.values.slice[index],
            T => lhs,
            else => @compileError("Unsupported type"),
        };
        const rv = switch (@TypeOf(rhs)) {
            PrimitiveArray(T) => rhs.values.slice[index],
            T => rhs,
            else => @compileError("Unsupported type"),
        };
        values.setOrClear(index, @call(.always_inline, op, .{ bool, lv, rv }));
    }

    // Intersect the validity buffer of lhs with the validity buffer of rhs.

    var validity: ?buffer.BooleanBuffer = null;

    const lhs_validity = switch (@TypeOf(lhs)) {
        PrimitiveArray(T) => lhs.validity,
        else => null,
    };

    const rhs_validity = switch (@TypeOf(rhs)) {
        PrimitiveArray(T) => rhs.validity,
        else => null,
    };

    if (lhs_validity != null and rhs_validity != null) {
        // Both validity bitmaps are set.
        validity = try buffer.BooleanBuffer.init(len, allocator);
        @memcpy(validity.?.masks.slice, lhs_validity.?.masks.slice);
        validity.?.setIntersection(rhs_validity.?);
    } else if (lhs_validity != null and rhs_validity == null) {
        // Only lhs validity is set.
        validity = lhs_validity.?.clone();
    } else if (lhs_validity == null and rhs_validity != null) {
        // Only rhs validity is set.
        validity = rhs_validity.?.clone();
    }

    return BooleanArray{
        .values = values,
        .validity = validity,
    };
}

test "kernel" {
    const lhs = try PrimitiveArray(i32).fromSlice(&[_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, testing.allocator);
    defer lhs.deinit();
    const rhs = try PrimitiveArray(i32).fromSlice(&[_]i32{ 1, 2, 3, 4, 0, 6, 7, 8, 8 }, testing.allocator);
    defer rhs.deinit();

    const vector_len = @max(8, std.simd.suggestVectorLength(i32) orelse 8);

    const result = try kernel(i32, vector_len, eq, lhs, rhs, testing.allocator);
    defer result.deinit();

    try testing.expectEqual(true, result.at(0));
    try testing.expectEqual(true, result.at(1));
    try testing.expectEqual(true, result.at(2));
    try testing.expectEqual(true, result.at(3));
    try testing.expectEqual(false, result.at(4));
    try testing.expectEqual(true, result.at(5));
    try testing.expectEqual(true, result.at(6));
    try testing.expectEqual(true, result.at(7));
    try testing.expectEqual(false, result.at(8));
}
