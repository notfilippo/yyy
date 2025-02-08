const std = @import("std");
const assert = std.debug.assert;

pub const Alignment = 64;

// https://arrow.apache.org/docs/format/Columnar.html#buffer-alignment-and-padding
// Buffer is required to have 64 byte alignment.
pub fn Buffer(comptime T: type) type {
    return []align(Alignment) T;
}

pub fn ValueBuffer(comptime T: type) type {
    return struct {
        const Self = @This();

        slice: Buffer(T),
        rc: std.atomic.Value(usize),
        allocator: std.mem.Allocator,

        pub fn init(size: usize, allocator: std.mem.Allocator) !Self {
            const slice = try allocator.alignedAlloc(T, Alignment, size);
            @memset(slice, 0);
            return .{
                .slice = slice,
                .rc = std.atomic.Value(usize).init(1),
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            if (self.rc.fetchSub(1, .seq_cst) == 1) {
                self.allocator.free(self.slice);
            }
        }
    };
}

pub const ValidityBuffer = struct {
    const Self = @This();

    const MaskInt = u8;
    const ShiftInt = std.math.Log2Int(MaskInt);

    masks: ValueBuffer(MaskInt),
    bit_len: usize,

    pub fn init(bit_len: usize, allocator: std.mem.Allocator) !Self {
        return .{
            .masks = try ValueBuffer(MaskInt).init(numMasks(bit_len), allocator),
            .bit_len = bit_len,
        };
    }

    pub fn deinit(self: *Self) void {
        self.masks.deinit();
    }

    /// Returns true if the bit at the specified index is present in the set,
    /// false otherwise.
    pub fn isValid(self: Self, index: usize) bool {
        assert(index < self.bit_len);
        return (self.masks.slice[maskIndex(index)] & maskBit(index)) != 0;
    }

    /// Performs a union of two bit sets, and stores the
    /// result in the first one. Bits in the result are
    /// set if the corresponding bits were set in either input.
    /// The two sets must both be the same len.
    pub fn setUnion(self: *Self, other: Self) void {
        assert(other.bit_len == self.bit_len);
        const num_masks = numMasks(self.bit_len);
        for (self.masks.slice[0..num_masks], 0..) |*mask, i| {
            mask.* |= other.masks.slice[i];
        }
    }

    /// Performs an intersection of two bit sets, and stores
    /// the result in the first one. Bits in the result are
    /// set if the corresponding bits were set in both inputs.
    /// The two sets must both be the same len.
    pub fn setIntersection(self: *Self, other: Self) void {
        assert(other.bit_len == self.bit_len);
        const num_masks = numMasks(self.bit_len);
        for (self.masks.slice[0..num_masks], 0..) |*mask, i| {
            mask.* &= other.masks.slice[i];
        }
    }

    pub fn set(self: *Self, index: usize) void {
        assert(index < self.bit_len);
        self.masks.slice[maskIndex(index)] |= maskBit(index);
    }

    pub fn clear(self: *Self, index: usize) void {
        assert(index < self.bit_len);
        self.masks.slice[maskIndex(index)] &= ~maskBit(index);
    }

    inline fn maskBit(index: usize) MaskInt {
        return @as(MaskInt, 1) << @as(ShiftInt, @truncate(index));
    }

    inline fn maskIndex(index: usize) usize {
        return index >> @bitSizeOf(ShiftInt);
    }

    inline fn numMasks(bit_len: usize) usize {
        return (bit_len + (@bitSizeOf(MaskInt) - 1)) / @bitSizeOf(MaskInt);
    }
};
