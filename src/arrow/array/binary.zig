const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;

const buffer = @import("buffer.zig");

pub fn BinaryArray(comptime O: type) type {
    return struct {
        const Self = @This();

        validity: ?buffer.ValidityBuffer,
        offsets: *buffer.ValueBuffer(O),
        values: *buffer.ValueBuffer(u8),

        pub fn deinit(self: *Self) void {
            self.offsets.deinit();
            self.values.deinit();
            if (self.validity) |*validity| {
                validity.deinit();
            }
        }

        // Returns the value at the specified index.
        pub fn at(self: Self, index: usize) ?[]u8 {
            if (self.validity == null or self.validity.?.isValid(index)) {
                const start = self.offsets.slice[index];
                const end = self.offsets.slice[index + 1];
                return self.values.slice[@intCast(start)..@intCast(end)];
            }
            return null;
        }

        // Returns the number of values in the array.
        pub inline fn len(self: Self) usize {
            return self.offsets.slice.len - 1;
        }
    };
}

test "layout" {
    var validity = try buffer.ValidityBuffer.init(5, testing.allocator);
    const offsets = try buffer.ValueBuffer(i32).init(6, testing.allocator);
    const values = try buffer.ValueBuffer(u8).init(18, testing.allocator);

    validity.set(0);
    validity.set(1);
    validity.set(2);
    validity.set(4);

    @memcpy(offsets.slice, &[_]i32{ 0, 1, 7, 11, 11, 18 });
    @memcpy(values.slice, "ireallyliketurtles");

    var array = BinaryArray(i32){
        .validity = validity,
        .offsets = offsets,
        .values = values,
    };
    defer array.deinit();

    try testing.expectEqual(array.len(), 5);
    try testing.expectEqualStrings(array.at(0).?, "i");
    try testing.expectEqualStrings(array.at(1).?, "really");
    try testing.expectEqualStrings(array.at(2).?, "like");
    try testing.expectEqual(array.at(3), null);
    try testing.expectEqualStrings(array.at(4).?, "turtles");
}
