const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;
const math = std.math;

const buffer = @import("../array/buffer.zig");
const PrimitiveArray = @import("../array/primitive.zig").PrimitiveArray;

pub fn add(lhs: anytype, rhs: anytype) @TypeOf(lhs) {
    return switch (@typeInfo(@TypeOf(lhs))) {
        .int => lhs +% rhs,
        .vector => |info| switch (@typeInfo(info.child)) {
            .int => lhs +% rhs,
            else => lhs + rhs,
        },
        else => lhs + rhs,
    };
}

pub fn sub(lhs: anytype, rhs: anytype) @TypeOf(lhs) {
    return switch (@typeInfo(@TypeOf(lhs))) {
        .int => lhs -% rhs,
        .vector => |info| switch (@typeInfo(info.child)) {
            .int => lhs -% rhs,
            else => lhs - rhs,
        },
        else => lhs - rhs,
    };
}

pub fn mul(lhs: anytype, rhs: anytype) @TypeOf(lhs) {
    return switch (@typeInfo(@TypeOf(lhs))) {
        .int => lhs *% rhs,
        .vector => |info| switch (@typeInfo(info.child)) {
            .int => lhs *% rhs,
            else => lhs * rhs,
        },
        else => lhs * rhs,
    };
}

pub fn div(lhs: anytype, rhs: anytype) @TypeOf(lhs) {
    return switch (@typeInfo(@TypeOf(lhs))) {
        .int => @divTrunc(lhs, rhs),
        .vector => |info| switch (@typeInfo(info.child)) {
            .int => @divTrunc(lhs, rhs),
            else => lhs / rhs,
        },
        else => lhs / rhs,
    };
}

pub fn mod(lhs: anytype, rhs: anytype) @TypeOf(lhs) {
    return @mod(lhs, rhs);
}

pub fn kernel(
    comptime T: type,
    comptime vector_len: comptime_int,
    comptime op: anytype,
    lhs: anytype,
    rhs: anytype,
    allocator: std.mem.Allocator,
) !PrimitiveArray(T) {
    comptime assert(@TypeOf(lhs) == PrimitiveArray(T) or @TypeOf(rhs) == PrimitiveArray(T));

    const len = if (@TypeOf(lhs) == PrimitiveArray(T)) lhs.len() else rhs.len();

    const parallel = if (vector_len > 0) len / vector_len else 0;

    const values = try buffer.ValueBuffer(T).init(len, allocator);

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

        const out = @call(.always_inline, op, .{ lv, rv });
        values.slice[start..end][0..vector_len].* = out;
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
        values.slice[index] = @call(.always_inline, op, .{ lv, rv });
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
        const lhs = try PrimitiveArray(T).random(rng, size, testing.allocator);
        defer lhs.deinit();
        const rhs = try PrimitiveArray(T).random(rng, size, testing.allocator);
        defer rhs.deinit();

        // Ensure no integer overflows or divisions by zero. Modify the denominator.
        for (lhs.values.slice, rhs.values.slice) |l, *r| {
            _ = math.divTrunc(T, l, r.*) catch {
                r.* = 1;
            };
        }

        const vector_len = std.simd.suggestVectorLength(T) orelse 8;

        const added = try kernel(T, vector_len, add, lhs, rhs, testing.allocator);
        defer added.deinit();
        try testing.expectEqual(added.len(), size);

        const subtracted = try kernel(T, vector_len, sub, lhs, rhs, testing.allocator);
        defer subtracted.deinit();
        try testing.expectEqual(subtracted.len(), size);

        const multiplied = try kernel(T, vector_len, mul, lhs, rhs, testing.allocator);
        defer multiplied.deinit();
        try testing.expectEqual(multiplied.len(), size);

        const divided = try kernel(T, vector_len, div, lhs, rhs, testing.allocator);
        defer divided.deinit();
        try testing.expectEqual(divided.len(), size);

        const modded = try kernel(T, vector_len, mod, lhs, rhs, testing.allocator);
        defer modded.deinit();
        try testing.expectEqual(modded.len(), size);

        for (lhs.values.slice, rhs.values.slice, added.values.slice, subtracted.values.slice, multiplied.values.slice, divided.values.slice, modded.values.slice) |l, r, a, s, m, d, md| {
            try testing.expect(add(l, r) == a or ((math.isNan(l) or math.isNan(r)) and math.isNan(a)));
            try testing.expect(sub(l, r) == s or ((math.isNan(l) or math.isNan(r)) and math.isNan(s)));
            try testing.expect(mul(l, r) == m or ((math.isNan(l) or math.isNan(r)) and math.isNan(m)));
            try testing.expect(div(l, r) == d or ((math.isNan(l) or math.isNan(r)) and math.isNan(d)));
            try testing.expect(mod(l, r) == md or ((math.isNan(l) or math.isNan(r)) and math.isNan(md)) or (math.isNan(mod(l, r)) and math.isNan(md)));
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

        const added = try kernel(T, vector_len, add, lhs, rhs, testing.allocator);
        defer added.deinit();
        try testing.expectEqual(added.len(), size);

        const subtracted = try kernel(T, vector_len, sub, lhs, rhs, testing.allocator);
        defer subtracted.deinit();
        try testing.expectEqual(subtracted.len(), size);

        const multiplied = try kernel(T, vector_len, mul, lhs, rhs, testing.allocator);
        defer multiplied.deinit();
        try testing.expectEqual(multiplied.len(), size);

        const divided = try kernel(T, vector_len, div, lhs, rhs, testing.allocator);
        defer divided.deinit();
        try testing.expectEqual(divided.len(), size);

        const modded = try kernel(T, vector_len, mod, lhs, rhs, testing.allocator);
        defer modded.deinit();
        try testing.expectEqual(modded.len(), size);

        for (lhs.values.slice, added.values.slice, subtracted.values.slice, multiplied.values.slice, divided.values.slice, modded.values.slice) |l, a, s, m, d, md| {
            try testing.expect(add(l, rhs) == a or ((math.isNan(l) or math.isNan(rhs)) and math.isNan(a)));
            try testing.expect(sub(l, rhs) == s or ((math.isNan(l) or math.isNan(rhs)) and math.isNan(s)));
            try testing.expect(mul(l, rhs) == m or ((math.isNan(l) or math.isNan(rhs)) and math.isNan(m)));
            try testing.expect(div(l, rhs) == d or ((math.isNan(l) or math.isNan(rhs)) and math.isNan(d)));
            try testing.expect(mod(l, rhs) == md or ((math.isNan(l) or math.isNan(rhs)) and math.isNan(md)) or (math.isNan(mod(l, rhs)) and math.isNan(md)));
        }
    }
}

test "binary scalar left kernel" {
    var prng = std.Random.DefaultPrng.init(0);
    const rng = prng.random();

    const size = 1 << 20;

    inline for ([_]type{ i8, i16, i32, i64, u8, u16, u32, u64, f16, f32, f64 }) |T| {
        const lhs: T = 2;
        const rhs = try PrimitiveArray(T).random(rng, size, testing.allocator);
        defer rhs.deinit();

        // Ensure no integer overflows or divisions by zero. Modify the denominator.
        for (rhs.values.slice) |*r| {
            _ = math.divTrunc(T, lhs, r.*) catch {
                r.* = 1;
            };
        }

        const vector_len = std.simd.suggestVectorLength(T) orelse 8;

        const added = try kernel(T, vector_len, add, lhs, rhs, testing.allocator);
        defer added.deinit();
        try testing.expectEqual(added.len(), size);

        const subtracted = try kernel(T, vector_len, sub, lhs, rhs, testing.allocator);
        defer subtracted.deinit();
        try testing.expectEqual(subtracted.len(), size);

        const multiplied = try kernel(T, vector_len, mul, lhs, rhs, testing.allocator);
        defer multiplied.deinit();
        try testing.expectEqual(multiplied.len(), size);

        const divided = try kernel(T, vector_len, div, lhs, rhs, testing.allocator);
        defer divided.deinit();
        try testing.expectEqual(divided.len(), size);

        const modded = try kernel(T, vector_len, mod, lhs, rhs, testing.allocator);
        defer modded.deinit();
        try testing.expectEqual(modded.len(), size);

        for (rhs.values.slice, added.values.slice, subtracted.values.slice, multiplied.values.slice, divided.values.slice, modded.values.slice) |r, a, s, m, d, md| {
            try testing.expect(add(lhs, r) == a or ((math.isNan(lhs) or math.isNan(r)) and math.isNan(a)));
            try testing.expect(sub(lhs, r) == s or ((math.isNan(lhs) or math.isNan(r)) and math.isNan(s)));
            try testing.expect(mul(lhs, r) == m or ((math.isNan(lhs) or math.isNan(r)) and math.isNan(m)));
            try testing.expect(div(lhs, r) == d or ((math.isNan(lhs) or math.isNan(r)) and math.isNan(d)));
            try testing.expect(mod(lhs, r) == md or ((math.isNan(lhs) or math.isNan(r)) and math.isNan(md)) or (math.isNan(mod(lhs, r)) and math.isNan(md)));
        }
    }
}
