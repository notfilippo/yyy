const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const buffer = @import("buffer.zig");
const primitive = @import("primitive.zig");

pub fn PrimitiveArray(comptime T: type) type {
    return struct {
        const Self = @This();

        validity: ?buffer.BooleanBuffer,
        values: *buffer.ValueBuffer(T),

        pub fn deinit(self: Self) void {
            self.values.deinit();
            if (self.validity) |*validity| {
                validity.deinit();
            }
        }

        pub fn clone(self: Self) Self {
            const validity = if (self.validity) |*validity| validity.clone() else null;
            return .{
                .values = self.values.clone(),
                .validity = validity,
            };
        }

        // Returns the value at the specified index.
        pub fn at(self: Self, index: usize) ?T {
            if (self.validity == null or self.validity.?.isValid(index)) {
                return self.values.slice[index];
            }
            return null;
        }

        // Returns the number of values in the array.
        pub inline fn len(self: Self) usize {
            return self.values.slice.len;
        }

        pub fn fromSlice(values: []const T, allocator: std.mem.Allocator) !Self {
            const valuesBuffer = try buffer.ValueBuffer(T).fromSlice(values, allocator);
            return .{
                .values = valuesBuffer,
                .validity = null,
            };
        }

        pub fn random(rng: std.Random, size: usize, allocator: std.mem.Allocator) !Self {
            const values = try buffer.ValueBuffer(T).init(size, allocator);
            const validity = try buffer.BooleanBuffer.init(size, allocator);

            rng.bytes(std.mem.sliceAsBytes(values.slice));
            rng.bytes(std.mem.sliceAsBytes(validity.masks.slice));

            return Self{
                .values = values,
                .validity = validity,
            };
        }
    };
}

test "primitive array" {
    var validity = try buffer.BooleanBuffer.init(5, testing.allocator);
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

    try testing.expectEqual(5, array.len());
    try testing.expectEqual(1, array.at(0).?);
    try testing.expectEqual(2, array.at(1).?);
    try testing.expectEqual(3, array.at(2).?);
    try testing.expectEqual(null, array.at(3));
    try testing.expectEqual(5, array.at(4).?);
}
