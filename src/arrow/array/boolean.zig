const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const buffer = @import("buffer.zig");
const primitive = @import("primitive.zig");

pub const BooleanArray = struct {
    const Self = @This();

    validity: ?buffer.BooleanBuffer,
    values: buffer.BooleanBuffer,

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
    pub fn at(self: Self, index: usize) ?bool {
        if (self.validity == null or self.validity.?.isValid(index)) {
            return self.values.isValid(index);
        }
        return null;
    }

    // Returns the number of values in the array.
    pub inline fn len(self: Self) usize {
        return self.values.bit_len;
    }

    pub fn random(rng: std.Random, size: usize, allocator: std.mem.Allocator) !Self {
        const values = try buffer.BooleanBuffer.init(size, allocator);
        const validity = try buffer.BooleanBuffer.init(size, allocator);

        rng.bytes(std.mem.sliceAsBytes(values.masks.slice));
        rng.bytes(std.mem.sliceAsBytes(validity.masks.slice));

        return Self{
            .values = values,
            .validity = validity,
        };
    }
};

test "boolean array" {
    var validity = try buffer.BooleanBuffer.init(5, testing.allocator);
    var values = try buffer.BooleanBuffer.init(5, testing.allocator);

    validity.set(0);
    validity.set(1);
    validity.set(2);
    validity.set(4);

    values.set(0);
    values.set(2);
    values.set(3);
    values.set(4);

    var array = BooleanArray{
        .validity = validity,
        .values = values,
    };
    defer array.deinit();

    try testing.expectEqual(5, array.len());
    try testing.expectEqual(true, array.at(0));
    try testing.expectEqual(false, array.at(1));
    try testing.expectEqual(true, array.at(2));
    try testing.expectEqual(null, array.at(3));
    try testing.expectEqual(true, array.at(4));
}
