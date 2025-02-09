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

        pub fn init(size: usize, allocator: std.mem.Allocator) !*Self {
            const self = try allocator.create(Self);
            self.slice = try allocator.alignedAlloc(T, Alignment, size);
            @memset(self.slice, 0);
            self.rc = std.atomic.Value(usize).init(1);
            self.allocator = allocator;
            return self;
        }

        pub fn deinit(self: *Self) void {
            if (self.rc.fetchSub(1, .release) == 1) {
                _ = self.rc.load(.acquire);
                self.allocator.free(self.slice);
                self.allocator.destroy(self);
            }
        }

        pub fn fromSlice(values: []const T, allocator: std.mem.Allocator) !*Self {
            const self = try Self.init(values.len, allocator);
            @memcpy(self.slice, values);
            return self;
        }

        pub fn clone(self: *Self) *Self {
            _ = self.rc.fetchAdd(1, .monotonic);
            return self;
        }
    };
}

pub const BooleanBuffer = struct {
    const Self = @This();

    const MaskInt = u8;
    const ShiftInt = std.math.Log2Int(MaskInt);

    masks: *ValueBuffer(MaskInt),
    bit_len: usize,

    pub fn init(bit_len: usize, allocator: std.mem.Allocator) !Self {
        return .{
            .masks = try ValueBuffer(MaskInt).init(numMasks(bit_len), allocator),
            .bit_len = bit_len,
        };
    }

    pub fn deinit(self: Self) void {
        self.masks.deinit();
    }

    pub fn clone(self: Self) Self {
        return .{
            .masks = self.masks.clone(),
            .bit_len = self.bit_len,
        };
    }

    /// Returns true if the bit at the specified index is present in the set,
    /// false otherwise.
    pub inline fn isValid(self: Self, index: usize) bool {
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

    pub inline fn setOrClear(self: Self, index: usize, value: bool) void {
        assert(index < self.bit_len);
        const clearOld = self.masks.slice[maskIndex(index)] & ~maskBit(index);
        const setNew = @as(MaskInt, @intFromBool(value)) << @as(ShiftInt, @truncate(index));
        self.masks.slice[maskIndex(index)] = clearOld | setNew;
    }

    pub inline fn set(self: Self, index: usize) void {
        assert(index < self.bit_len);
        self.masks.slice[maskIndex(index)] |= maskBit(index);
    }

    pub inline fn clear(self: Self, index: usize) void {
        assert(index < self.bit_len);
        self.masks.slice[maskIndex(index)] &= ~maskBit(index);
    }

    pub inline fn maskBit(index: usize) MaskInt {
        return @as(MaskInt, 1) << @as(ShiftInt, @truncate(index));
    }

    pub inline fn maskIndex(index: usize) usize {
        return index >> @bitSizeOf(ShiftInt);
    }

    pub inline fn numMasks(bit_len: usize) usize {
        return (bit_len + (@bitSizeOf(MaskInt) - 1)) / @bitSizeOf(MaskInt);
    }
};
