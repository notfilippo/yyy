const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const buffer = @import("buffer.zig");
const primitive = @import("primitive.zig");

pub fn PrimitiveArray(comptime T: type) type {
    return struct {
        const Self = @This();

        validity: ?buffer.ValidityBuffer,
        values: buffer.ValueBuffer(T),

        pub fn deinit(self: *Self) void {
            self.values.deinit();
            if (self.validity) |*validity| {
                validity.deinit();
            }
        }

        // Returns the value at the specified index.
        pub fn at(self: Self, index: usize) ?T {
            if (self.validity == null or self.validity.?.isValid(index)) {
                return self.values.slice[index];
            }
            return null;
        }

        // Returns an iterator over the values in the array.
        pub fn iter(self: *Self) FixedSizeIterator(T) {
            return FixedSizeIterator(T){ .array = self, .index = 0 };
        }

        // Returns the number of values in the array.
        pub inline fn len(self: Self) usize {
            return self.values.slice.len;
        }

        pub fn random(rng: std.Random, size: usize, allocator: std.mem.Allocator) !Self {
            const values = try buffer.ValueBuffer(T).init(size, allocator);
            const validity = try buffer.ValidityBuffer.init(size, allocator);

            rng.bytes(std.mem.sliceAsBytes(values.slice));
            rng.bytes(std.mem.sliceAsBytes(validity.masks.slice));

            return Self{
                .values = values,
                .validity = validity,
            };
        }
    };
}

pub fn FixedSizeIterator(comptime T: type) type {
    return struct {
        const Self = @This();

        array: *PrimitiveArray(T),
        index: usize,

        // Returns the next value in the array, or null if there are no more values.
        pub fn next(self: *Self) ??T {
            if (self.index >= self.array.len()) {
                return null;
            }
            const value = self.array.at(self.index);
            self.index += 1;
            return value;
        }
    };
}

test "primitive array" {
    var validity = try buffer.ValidityBuffer.init(5, testing.allocator);
    const values = try buffer.ValueBuffer(i32).init(5, testing.allocator);

    validity.set(0);
    validity.set(1);
    validity.set(2);
    validity.set(4);

    @memcpy(values.slice, &[_]i32{ 1, 2, 3, 0, 5 });

    var array = primitive.PrimitiveArray(i32){
        .validity = validity,
        .values = values,
    };
    defer array.deinit();

    try testing.expectEqual(array.len(), 5);
    try testing.expectEqual(array.at(0).?, 1);
    try testing.expectEqual(array.at(1).?, 2);
    try testing.expectEqual(array.at(2).?, 3);
    try testing.expectEqual(array.at(3), null);
    try testing.expectEqual(array.at(4).?, 5);
}
