const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const math = std.math;

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

fn mul_(comptime T: type, lhs: T, rhs: T) T {
    return switch (@typeInfo(T)) {
        .int => lhs *% rhs,
        .vector => |info| switch (@typeInfo(info.child)) {
            .int => lhs *% rhs,
            else => lhs * rhs,
        },
        else => lhs * rhs,
    };
}

pub fn mul(
    comptime T: type,
    comptime vector_len: comptime_int,
    lhs: PrimitiveArray(T),
    rhs: PrimitiveArray(T),
    allocator: std.mem.Allocator,
) !PrimitiveArray(T) {
    return binary_kenel(T, vector_len, mul_, mul_, lhs, rhs, allocator);
}

fn div_(comptime T: type, lhs: T, rhs: T) T {
    return switch (@typeInfo(T)) {
        .int => @divTrunc(lhs, rhs),
        .vector => |info| switch (@typeInfo(info.child)) {
            .int => @divTrunc(lhs, rhs),
            else => lhs / rhs,
        },
        else => lhs / rhs,
    };
}

pub fn div(
    comptime T: type,
    comptime vector_len: comptime_int,
    lhs: PrimitiveArray(T),
    rhs: PrimitiveArray(T),
    allocator: std.mem.Allocator,
) !PrimitiveArray(T) {
    return binary_kenel(T, vector_len, div_, div_, lhs, rhs, allocator);
}

fn mod_(comptime T: type, lhs: T, rhs: T) T {
    return @mod(lhs, rhs);
}

pub fn mod(
    comptime T: type,
    comptime vector_len: comptime_int,
    lhs: PrimitiveArray(T),
    rhs: PrimitiveArray(T),
    allocator: std.mem.Allocator,
) !PrimitiveArray(T) {
    return binary_kenel(T, vector_len, mod_, mod_, lhs, rhs, allocator);
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

fn binary_scalar_right_kernel(
    comptime T: type,
    comptime vector_len: comptime_int,
    comptime scalar_op: fn (comptime type, T, T) T,
    comptime vector_op: fn (comptime type, @Vector(vector_len, T), @Vector(vector_len, T)) @Vector(vector_len, T),
    lhs: PrimitiveArray(T),
    rhs: T,
    allocator: std.mem.Allocator,
) !PrimitiveArray(T) {
    const len = lhs.len();
    const parallel = len / vector_len;

    const values = try buffer.ValueBuffer(T).init(len, allocator);

    var i: usize = 0;
    while (i < parallel) : (i += 1) {
        const start = i * vector_len;
        const end = start + vector_len;
        const lv: @Vector(vector_len, T) = lhs.values.slice[start..end][0..vector_len].*;
        const rv: @Vector(vector_len, T) = @splat(rhs);
        const out = vector_op(@Vector(vector_len, T), lv, rv);
        values.slice[start..end][0..vector_len].* = out;
    }

    const offset = i * vector_len;
    const left = len % vector_len;
    i = 0;
    while (i < left) : (i += 1) {
        const index = offset +% i;
        values.slice[index] = scalar_op(T, lhs.values.slice[index], rhs);
    }

    const validity = if (lhs.validity) |validity| validity.clone() else null;

    return PrimitiveArray(T){
        .values = values,
        .validity = validity,
    };
}

fn binary_scalar_left_kernel(
    comptime T: type,
    comptime vector_len: comptime_int,
    comptime scalar_op: fn (comptime type, T, T) T,
    comptime vector_op: fn (comptime type, @Vector(vector_len, T), @Vector(vector_len, T)) @Vector(vector_len, T),
    lhs: T,
    rhs: PrimitiveArray(T),
    allocator: std.mem.Allocator,
) !PrimitiveArray(T) {
    const len = rhs.len();
    const parallel = len / vector_len;

    const values = try buffer.ValueBuffer(T).init(len, allocator);

    var i: usize = 0;
    while (i < parallel) : (i += 1) {
        const start = i * vector_len;
        const end = start + vector_len;
        const lv: @Vector(vector_len, T) = @splat(lhs);
        const rv: @Vector(vector_len, T) = rhs.values.slice[start..end][0..vector_len].*;
        const out = vector_op(@Vector(vector_len, T), lv, rv);
        values.slice[start..end][0..vector_len].* = out;
    }

    const offset = i * vector_len;
    const left = len % vector_len;
    i = 0;
    while (i < left) : (i += 1) {
        const index = offset +% i;
        values.slice[index] = scalar_op(T, lhs, rhs.values.slice[index]);
    }

    const validity = if (rhs.validity) |validity| validity.clone() else null;

    return PrimitiveArray(T){
        .values = values,
        .validity = validity,
    };
}

test "binary operations between arrays" {
    var prng = std.Random.DefaultPrng.init(0);
    const rng = prng.random();

    const size = 1 << 20;

    inline for ([_]type{ i8, i16, i32, i64, u8, u16, u32, u64, f16, f32, f64 }) |T| {
        var lhs = try PrimitiveArray(T).random(rng, size, testing.allocator);
        defer lhs.deinit();
        var rhs = try PrimitiveArray(T).random(rng, size, testing.allocator);
        defer rhs.deinit();

        // Ensure no integer overflows or divisions by zero. Modify the denominator.
        for (lhs.values.slice, rhs.values.slice) |l, *r| {
            _ = math.divTrunc(T, l, r.*) catch {
                r.* = 1;
            };
        }

        const vector_len = std.simd.suggestVectorLength(T) orelse 8;

        var added = try add(T, vector_len, lhs, rhs, testing.allocator);
        defer added.deinit();
        try testing.expectEqual(added.len(), size);

        var subtracted = try sub(T, vector_len, lhs, rhs, testing.allocator);
        defer subtracted.deinit();
        try testing.expectEqual(subtracted.len(), size);

        var multiplied = try mul(T, vector_len, lhs, rhs, testing.allocator);
        defer multiplied.deinit();
        try testing.expectEqual(multiplied.len(), size);

        var divided = try div(T, vector_len, lhs, rhs, testing.allocator);
        defer divided.deinit();
        try testing.expectEqual(divided.len(), size);

        var modded = try mod(T, vector_len, lhs, rhs, testing.allocator);
        defer modded.deinit();
        try testing.expectEqual(modded.len(), size);

        for (lhs.values.slice, rhs.values.slice, added.values.slice, subtracted.values.slice, multiplied.values.slice, divided.values.slice, modded.values.slice) |l, r, a, s, m, d, md| {
            try testing.expect(add_(T, l, r) == a or ((math.isNan(l) or math.isNan(r)) and math.isNan(a)));
            try testing.expect(sub_(T, l, r) == s or ((math.isNan(l) or math.isNan(r)) and math.isNan(s)));
            try testing.expect(mul_(T, l, r) == m or ((math.isNan(l) or math.isNan(r)) and math.isNan(m)));
            try testing.expect(div_(T, l, r) == d or ((math.isNan(l) or math.isNan(r)) and math.isNan(d)));
            try testing.expect(mod_(T, l, r) == md or ((math.isNan(l) or math.isNan(r)) and math.isNan(md)) or (math.isNan(mod_(T, l, r)) and math.isNan(md)));
        }
    }
}

test "binary scalar right kernel" {
    var prng = std.Random.DefaultPrng.init(0);
    const rng = prng.random();

    const size = 1 << 20;

    inline for ([_]type{ i8, i16, i32, i64, u8, u16, u32, u64, f16, f32, f64 }) |T| {
        var lhs = try PrimitiveArray(T).random(rng, size, testing.allocator);
        defer lhs.deinit();

        const rhs: T = 2;

        const vector_len = std.simd.suggestVectorLength(T) orelse 8;

        var added = try binary_scalar_right_kernel(T, vector_len, add_, add_, lhs, rhs, testing.allocator);
        defer added.deinit();
        try testing.expectEqual(added.len(), size);

        var subtracted = try binary_scalar_right_kernel(T, vector_len, sub_, sub_, lhs, rhs, testing.allocator);
        defer subtracted.deinit();
        try testing.expectEqual(subtracted.len(), size);

        var multiplied = try binary_scalar_right_kernel(T, vector_len, mul_, mul_, lhs, rhs, testing.allocator);
        defer multiplied.deinit();
        try testing.expectEqual(multiplied.len(), size);

        var divided = try binary_scalar_right_kernel(T, vector_len, div_, div_, lhs, rhs, testing.allocator);
        defer divided.deinit();
        try testing.expectEqual(divided.len(), size);

        var modded = try binary_scalar_right_kernel(T, vector_len, mod_, mod_, lhs, rhs, testing.allocator);
        defer modded.deinit();
        try testing.expectEqual(modded.len(), size);

        for (lhs.values.slice, added.values.slice, subtracted.values.slice, multiplied.values.slice, divided.values.slice, modded.values.slice) |l, a, s, m, d, md| {
            try testing.expect(add_(T, l, rhs) == a or ((math.isNan(l) or math.isNan(rhs)) and math.isNan(a)));
            try testing.expect(sub_(T, l, rhs) == s or ((math.isNan(l) or math.isNan(rhs)) and math.isNan(s)));
            try testing.expect(mul_(T, l, rhs) == m or ((math.isNan(l) or math.isNan(rhs)) and math.isNan(m)));
            try testing.expect(div_(T, l, rhs) == d or ((math.isNan(l) or math.isNan(rhs)) and math.isNan(d)));
            try testing.expect(mod_(T, l, rhs) == md or ((math.isNan(l) or math.isNan(rhs)) and math.isNan(md)) or (math.isNan(mod_(T, l, rhs)) and math.isNan(md)));
        }
    }
}

test "binary scalar left kernel" {
    var prng = std.Random.DefaultPrng.init(0);
    const rng = prng.random();

    const size = 1 << 20;

    inline for ([_]type{ i8, i16, i32, i64, u8, u16, u32, u64, f16, f32, f64 }) |T| {
        const lhs: T = 2;
        var rhs = try PrimitiveArray(T).random(rng, size, testing.allocator);
        defer rhs.deinit();

        // Ensure no integer overflows or divisions by zero. Modify the denominator.
        for (rhs.values.slice) |*r| {
            _ = math.divTrunc(T, lhs, r.*) catch {
                r.* = 1;
            };
        }

        const vector_len = std.simd.suggestVectorLength(T) orelse 8;

        var added = try binary_scalar_left_kernel(T, vector_len, add_, add_, lhs, rhs, testing.allocator);
        defer added.deinit();
        try testing.expectEqual(added.len(), size);

        var subtracted = try binary_scalar_left_kernel(T, vector_len, sub_, sub_, lhs, rhs, testing.allocator);
        defer subtracted.deinit();
        try testing.expectEqual(subtracted.len(), size);

        var multiplied = try binary_scalar_left_kernel(T, vector_len, mul_, mul_, lhs, rhs, testing.allocator);
        defer multiplied.deinit();
        try testing.expectEqual(multiplied.len(), size);

        var divided = try binary_scalar_left_kernel(T, vector_len, div_, div_, lhs, rhs, testing.allocator);
        defer divided.deinit();
        try testing.expectEqual(divided.len(), size);

        var modded = try binary_scalar_left_kernel(T, vector_len, mod_, mod_, lhs, rhs, testing.allocator);
        defer modded.deinit();
        try testing.expectEqual(modded.len(), size);

        for (rhs.values.slice, added.values.slice, subtracted.values.slice, multiplied.values.slice, divided.values.slice, modded.values.slice) |r, a, s, m, d, md| {
            try testing.expect(add_(T, lhs, r) == a or ((math.isNan(lhs) or math.isNan(r)) and math.isNan(a)));
            try testing.expect(sub_(T, lhs, r) == s or ((math.isNan(lhs) or math.isNan(r)) and math.isNan(s)));
            try testing.expect(mul_(T, lhs, r) == m or ((math.isNan(lhs) or math.isNan(r)) and math.isNan(m)));
            try testing.expect(div_(T, lhs, r) == d or ((math.isNan(lhs) or math.isNan(r)) and math.isNan(d)));
            try testing.expect(mod_(T, lhs, r) == md or ((math.isNan(lhs) or math.isNan(r)) and math.isNan(md)) or (math.isNan(mod_(T, lhs, r)) and math.isNan(md)));
        }
    }
}
