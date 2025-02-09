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

pub fn kernel(
    comptime T: type,
    comptime vector_len: comptime_int,
    comptime op: anytype,
    lhs: anytype,
    rhs: anytype,
    allocator: std.mem.Allocator,
) !BooleanArray {
    comptime assert(@TypeOf(lhs) == PrimitiveArray(T) or @TypeOf(rhs) == PrimitiveArray(T));
    comptime assert(vector_len % 8 == 0);

    const len = if (@TypeOf(lhs) == PrimitiveArray(T)) lhs.len() else rhs.len();

    const parallel = len / vector_len;

    const values = try buffer.BooleanBuffer.init(len, allocator);

    const tt = @Type(.{ .int = .{ .bits = vector_len, .signedness = .unsigned } });

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
        const val = @as(tt, @bitCast(out));

        @memcpy(values.masks.slice[buffer.BooleanBuffer.maskIndex(start)..buffer.BooleanBuffer.maskIndex(end)], std.mem.asBytes(&val));
    }

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

    return BooleanArray{
        .values = values,
        .validity = null,
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
