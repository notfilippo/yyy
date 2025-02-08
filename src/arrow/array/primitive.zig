const std = @import("std");
const assert = std.debug.assert;

const buffer = @import("buffer.zig");

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
