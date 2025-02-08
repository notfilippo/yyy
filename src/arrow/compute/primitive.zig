const std = @import("std");
const assert = std.debug.assert;

const buffer = @import("../array/buffer.zig");
const PrimitiveArray = @import("../array/primitive.zig").PrimitiveArray;

fn add_(comptime T: type, lhs: T, rhs: T) T {
    return switch (@typeInfo(T)) {
        .int => lhs +% rhs,
        .vector => |info| switch (@typeInfo(info.child)) {
            .int => lhs +% rhs,
            else => lhs + rhs,
        },
        else => lhs + rhs,
    };
}

pub fn add(
    comptime T: type,
    comptime vector_len: comptime_int,
    lhs: PrimitiveArray(T),
    rhs: PrimitiveArray(T),
    allocator: std.mem.Allocator,
) !PrimitiveArray(T) {
    return binary_kenel(T, vector_len, add_, add_, lhs, rhs, allocator);
}

fn sub_(comptime T: type, lhs: T, rhs: T) T {
    return switch (@typeInfo(T)) {
        .int => lhs -% rhs,
        .vector => |info| switch (@typeInfo(info.child)) {
            .int => lhs -% rhs,
            else => lhs - rhs,
        },
        else => lhs - rhs,
    };
}

pub fn sub(
    comptime T: type,
    comptime vector_len: comptime_int,
    lhs: PrimitiveArray(T),
    rhs: PrimitiveArray(T),
    allocator: std.mem.Allocator,
) !PrimitiveArray(T) {
    return binary_kenel(T, vector_len, sub_, sub_, lhs, rhs, allocator);
}

// This is a generic kernel for binary operations on primitive arrays. It uses
// SIMD vector operations when possible, and falls back to scalar operations
// when the array length is not a multiple of the vector length.
fn binary_kenel(
    comptime T: type,
    comptime vector_len: comptime_int,
    comptime scalar_op: fn (comptime type, T, T) T,
    comptime vector_op: fn (comptime type, @Vector(vector_len, T), @Vector(vector_len, T)) @Vector(vector_len, T),
    lhs: PrimitiveArray(T),
    rhs: PrimitiveArray(T),
    allocator: std.mem.Allocator,
) !PrimitiveArray(T) {
    assert(lhs.len() == lhs.len());

    const len = lhs.len();
    const parallel = len / vector_len;

    const values = try buffer.ValueBuffer(T).init(len, allocator);

    // Execute as many SIMD vector operations as possible...

    var i: usize = 0;
    while (i < parallel) : (i += 1) {
        const start = i * vector_len;
        const end = start + vector_len;
        const lv: @Vector(vector_len, T) = lhs.values.slice[start..end][0..vector_len].*;
        const rv: @Vector(vector_len, T) = rhs.values.slice[start..end][0..vector_len].*;
        const out = vector_op(@Vector(vector_len, T), lv, rv);
        values.slice[start..end][0..vector_len].* = out;
    }

    // ... and if left > 0, complete the calculation with scalar operations.

    const offset = i * vector_len;
    const left = len % vector_len;
    i = 0;
    while (i < left) : (i += 1) {
        const index = offset +% i;
        values.slice[index] = scalar_op(T, lhs.values.slice[index], rhs.values.slice[index]);
    }

    // Intersect the validity buffer of lhs with the validity buffer of rhs.

    var validity: ?buffer.ValidityBuffer = null;

    if (lhs.validity != null and rhs.validity != null) {
        // Both validity bitmaps are set.
        validity = try buffer.ValidityBuffer.init(len, allocator);
        @memcpy(validity.?.masks.slice, lhs.validity.?.masks.slice);
        validity.?.setIntersection(rhs.validity.?);
    } else if (lhs.validity != null and rhs.validity == null) {
        // Only lhs validity is set.
        validity = try buffer.ValidityBuffer.init(len, allocator);
        @memcpy(validity.?.masks.slice, lhs.validity.?.masks.slice);
    } else if (lhs.validity == null and rhs.validity != null) {
        // Only rhs validity is set.
        validity = try buffer.ValidityBuffer.init(len, allocator);
        @memcpy(validity.?.masks.slice, rhs.validity.?.masks.slice);
    }

    return PrimitiveArray(T){
        .values = values,
        .validity = validity,
    };
}
