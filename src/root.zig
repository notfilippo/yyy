const std = @import("std");
pub const arrow = @import("arrow.zig");

const testing = std.testing;
var rng = std.Random.DefaultPrng.init(0);

fn rand_array(comptime T: type, size: usize, allocator: std.mem.Allocator) !arrow.PrimitiveArray(T) {
    const values = try arrow.ValueBuffer(T).init(size, allocator);
    const validity = try arrow.ValidityBuffer.init(size, allocator);

    rng.random().bytes(std.mem.sliceAsBytes(values.slice));
    rng.random().bytes(std.mem.sliceAsBytes(validity.masks.slice));

    return arrow.PrimitiveArray(T){
        .values = values,
        .validity = validity,
    };
}

test "arrow int array" {
    var a = try rand_array(f32, 1 << 20, testing.allocator);
    defer a.deinit();
    var b = try rand_array(f32, 1 << 20, testing.allocator);
    defer b.deinit();

    const vector_len = std.simd.suggestVectorLength(f32) orelse 8;

    var c = try arrow.add(f32, vector_len, a, b, testing.allocator);
    defer c.deinit();

    try testing.expect(c.len() == 1 << 20);

    // var iter = c.iter();
    // while (iter.next()) |val| {
    //     std.debug.print("val {?}\n", .{val});
    // }
}

test {
    std.testing.refAllDeclsRecursive(@This());
}
