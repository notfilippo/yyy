const std = @import("std");
const gremlin = @import("gremlin");
const type = @import("type.proto.zig");

// structs
const ParameterizedTypeWire = struct {
    const BOOL_WIRE: gremlin.ProtoWireNumber = 1;
    const I8_WIRE: gremlin.ProtoWireNumber = 2;
    const I16_WIRE: gremlin.ProtoWireNumber = 3;
    const I32_WIRE: gremlin.ProtoWireNumber = 5;
    const I64_WIRE: gremlin.ProtoWireNumber = 7;
    const FP32_WIRE: gremlin.ProtoWireNumber = 10;
    const FP64_WIRE: gremlin.ProtoWireNumber = 11;
    const STRING_WIRE: gremlin.ProtoWireNumber = 12;
    const BINARY_WIRE: gremlin.ProtoWireNumber = 13;
    const TIMESTAMP_WIRE: gremlin.ProtoWireNumber = 14;
    const DATE_WIRE: gremlin.ProtoWireNumber = 16;
    const TIME_WIRE: gremlin.ProtoWireNumber = 17;
    const INTERVAL_YEAR_WIRE: gremlin.ProtoWireNumber = 19;
    const INTERVAL_DAY_WIRE: gremlin.ProtoWireNumber = 20;
    const INTERVAL_COMPOUND_WIRE: gremlin.ProtoWireNumber = 36;
    const TIMESTAMP_TZ_WIRE: gremlin.ProtoWireNumber = 29;
    const UUID_WIRE: gremlin.ProtoWireNumber = 32;
    const FIXED_CHAR_WIRE: gremlin.ProtoWireNumber = 21;
    const VARCHAR_WIRE: gremlin.ProtoWireNumber = 22;
    const FIXED_BINARY_WIRE: gremlin.ProtoWireNumber = 23;
    const DECIMAL_WIRE: gremlin.ProtoWireNumber = 24;
    const PRECISION_TIMESTAMP_WIRE: gremlin.ProtoWireNumber = 34;
    const PRECISION_TIMESTAMP_TZ_WIRE: gremlin.ProtoWireNumber = 35;
    const STRUCT_WIRE: gremlin.ProtoWireNumber = 25;
    const LIST_WIRE: gremlin.ProtoWireNumber = 27;
    const MAP_WIRE: gremlin.ProtoWireNumber = 28;
    const USER_DEFINED_WIRE: gremlin.ProtoWireNumber = 30;
    const USER_DEFINED_POINTER_WIRE: gremlin.ProtoWireNumber = 31;
    const TYPE_PARAMETER_WIRE: gremlin.ProtoWireNumber = 33;
};

pub const ParameterizedType = struct {
    // nested structs
    const TypeParameterWire = struct {
        const NAME_WIRE: gremlin.ProtoWireNumber = 1;
        const BOUNDS_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const TypeParameter = struct {
        // fields
        name: ?[]const u8 = null,
        bounds: ?[]const ?ParameterizedType = null,

        pub fn calcProtobufSize(self: *const TypeParameter) usize {
            var res: usize = 0;
            if (self.name) |v| { res += gremlin.sizes.sizeWireNumber(ParameterizedType.TypeParameterWire.NAME_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.bounds) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(ParameterizedType.TypeParameterWire.BOUNDS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            return res;
        }

        pub fn encode(self: *const TypeParameter, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const TypeParameter, target: *gremlin.Writer) void {
            if (self.name) |v| { target.appendBytes(ParameterizedType.TypeParameterWire.NAME_WIRE, v); }
            if (self.bounds) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(ParameterizedType.TypeParameterWire.BOUNDS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(ParameterizedType.TypeParameterWire.BOUNDS_WIRE, 0);
                    }
                }
            }
        }
    };
    
    pub const TypeParameterReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _name: ?[]const u8 = null,
        _bounds_bufs: ?std.ArrayList([]const u8) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!TypeParameterReader {
            var buf = gremlin.Reader.init(src);
            var res = TypeParameterReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.TypeParameterWire.NAME_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._name = result.value;
                    },
                    ParameterizedType.TypeParameterWire.BOUNDS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._bounds_bufs == null) {
                            res._bounds_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._bounds_bufs.?.append(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const TypeParameterReader) void {
            if (self._bounds_bufs) |arr| {
                arr.deinit();
            }
        }
        pub inline fn getName(self: *const TypeParameterReader) []const u8 { return self._name orelse &[_]u8{}; }
        pub fn getBounds(self: *const TypeParameterReader, allocator: std.mem.Allocator) gremlin.Error![]ParameterizedTypeReader {
            if (self._bounds_bufs) |bufs| {
                var result = try std.ArrayList(ParameterizedTypeReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try ParameterizedTypeReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]ParameterizedTypeReader{};
        }
    };
    
    const IntegerParameterWire = struct {
        const NAME_WIRE: gremlin.ProtoWireNumber = 1;
        const RANGE_START_INCLUSIVE_WIRE: gremlin.ProtoWireNumber = 2;
        const RANGE_END_EXCLUSIVE_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const IntegerParameter = struct {
        // fields
        name: ?[]const u8 = null,
        range_start_inclusive: ?ParameterizedType.NullableInteger = null,
        range_end_exclusive: ?ParameterizedType.NullableInteger = null,

        pub fn calcProtobufSize(self: *const IntegerParameter) usize {
            var res: usize = 0;
            if (self.name) |v| { res += gremlin.sizes.sizeWireNumber(ParameterizedType.IntegerParameterWire.NAME_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.range_start_inclusive) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.IntegerParameterWire.RANGE_START_INCLUSIVE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.range_end_exclusive) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.IntegerParameterWire.RANGE_END_EXCLUSIVE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const IntegerParameter, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const IntegerParameter, target: *gremlin.Writer) void {
            if (self.name) |v| { target.appendBytes(ParameterizedType.IntegerParameterWire.NAME_WIRE, v); }
            if (self.range_start_inclusive) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.IntegerParameterWire.RANGE_START_INCLUSIVE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.range_end_exclusive) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.IntegerParameterWire.RANGE_END_EXCLUSIVE_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const IntegerParameterReader = struct {
        _name: ?[]const u8 = null,
        _range_start_inclusive_buf: ?[]const u8 = null,
        _range_end_exclusive_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!IntegerParameterReader {
            var buf = gremlin.Reader.init(src);
            var res = IntegerParameterReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.IntegerParameterWire.NAME_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._name = result.value;
                    },
                    ParameterizedType.IntegerParameterWire.RANGE_START_INCLUSIVE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._range_start_inclusive_buf = result.value;
                    },
                    ParameterizedType.IntegerParameterWire.RANGE_END_EXCLUSIVE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._range_end_exclusive_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const IntegerParameterReader) void { }
        
        pub inline fn getName(self: *const IntegerParameterReader) []const u8 { return self._name orelse &[_]u8{}; }
        pub fn getRangeStartInclusive(self: *const IntegerParameterReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.NullableIntegerReader {
            if (self._range_start_inclusive_buf) |buf| {
                return try ParameterizedType.NullableIntegerReader.init(allocator, buf);
            }
            return try ParameterizedType.NullableIntegerReader.init(allocator, &[_]u8{});
        }
        pub fn getRangeEndExclusive(self: *const IntegerParameterReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.NullableIntegerReader {
            if (self._range_end_exclusive_buf) |buf| {
                return try ParameterizedType.NullableIntegerReader.init(allocator, buf);
            }
            return try ParameterizedType.NullableIntegerReader.init(allocator, &[_]u8{});
        }
    };
    
    const NullableIntegerWire = struct {
        const VALUE_WIRE: gremlin.ProtoWireNumber = 1;
    };
    
    pub const NullableInteger = struct {
        // fields
        value: i64 = 0,

        pub fn calcProtobufSize(self: *const NullableInteger) usize {
            var res: usize = 0;
            if (self.value != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.NullableIntegerWire.VALUE_WIRE) + gremlin.sizes.sizeI64(self.value); }
            return res;
        }

        pub fn encode(self: *const NullableInteger, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const NullableInteger, target: *gremlin.Writer) void {
            if (self.value != 0) { target.appendInt64(ParameterizedType.NullableIntegerWire.VALUE_WIRE, self.value); }
        }
    };
    
    pub const NullableIntegerReader = struct {
        _value: i64 = 0,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!NullableIntegerReader {
            var buf = gremlin.Reader.init(src);
            var res = NullableIntegerReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.NullableIntegerWire.VALUE_WIRE => {
                      const result = try buf.readInt64(offset);
                      offset += result.size;
                      res._value = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const NullableIntegerReader) void { }
        
        pub inline fn getValue(self: *const NullableIntegerReader) i64 { return self._value; }
    };
    
    const ParameterizedFixedCharWire = struct {
        const LENGTH_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ParameterizedFixedChar = struct {
        // fields
        length: ?ParameterizedType.IntegerOption = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedFixedChar) usize {
            var res: usize = 0;
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedFixedCharWire.LENGTH_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedFixedCharWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedFixedCharWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedFixedChar, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedFixedChar, target: *gremlin.Writer) void {
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedFixedCharWire.LENGTH_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedFixedCharWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedFixedCharWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedFixedCharReader = struct {
        _length_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedFixedCharReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedFixedCharReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedFixedCharWire.LENGTH_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._length_buf = result.value;
                    },
                    ParameterizedType.ParameterizedFixedCharWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedFixedCharWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterizedFixedCharReader) void { }
        
        pub fn getLength(self: *const ParameterizedFixedCharReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.IntegerOptionReader {
            if (self._length_buf) |buf| {
                return try ParameterizedType.IntegerOptionReader.init(allocator, buf);
            }
            return try ParameterizedType.IntegerOptionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ParameterizedFixedCharReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedFixedCharReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ParameterizedVarCharWire = struct {
        const LENGTH_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ParameterizedVarChar = struct {
        // fields
        length: ?ParameterizedType.IntegerOption = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedVarChar) usize {
            var res: usize = 0;
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedVarCharWire.LENGTH_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedVarCharWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedVarCharWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedVarChar, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedVarChar, target: *gremlin.Writer) void {
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedVarCharWire.LENGTH_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedVarCharWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedVarCharWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedVarCharReader = struct {
        _length_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedVarCharReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedVarCharReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedVarCharWire.LENGTH_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._length_buf = result.value;
                    },
                    ParameterizedType.ParameterizedVarCharWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedVarCharWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterizedVarCharReader) void { }
        
        pub fn getLength(self: *const ParameterizedVarCharReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.IntegerOptionReader {
            if (self._length_buf) |buf| {
                return try ParameterizedType.IntegerOptionReader.init(allocator, buf);
            }
            return try ParameterizedType.IntegerOptionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ParameterizedVarCharReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedVarCharReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ParameterizedFixedBinaryWire = struct {
        const LENGTH_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ParameterizedFixedBinary = struct {
        // fields
        length: ?ParameterizedType.IntegerOption = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedFixedBinary) usize {
            var res: usize = 0;
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedFixedBinaryWire.LENGTH_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedFixedBinaryWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedFixedBinaryWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedFixedBinary, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedFixedBinary, target: *gremlin.Writer) void {
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedFixedBinaryWire.LENGTH_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedFixedBinaryWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedFixedBinaryWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedFixedBinaryReader = struct {
        _length_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedFixedBinaryReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedFixedBinaryReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedFixedBinaryWire.LENGTH_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._length_buf = result.value;
                    },
                    ParameterizedType.ParameterizedFixedBinaryWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedFixedBinaryWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterizedFixedBinaryReader) void { }
        
        pub fn getLength(self: *const ParameterizedFixedBinaryReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.IntegerOptionReader {
            if (self._length_buf) |buf| {
                return try ParameterizedType.IntegerOptionReader.init(allocator, buf);
            }
            return try ParameterizedType.IntegerOptionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ParameterizedFixedBinaryReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedFixedBinaryReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ParameterizedDecimalWire = struct {
        const SCALE_WIRE: gremlin.ProtoWireNumber = 1;
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 2;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 3;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 4;
    };
    
    pub const ParameterizedDecimal = struct {
        // fields
        scale: ?ParameterizedType.IntegerOption = null,
        precision: ?ParameterizedType.IntegerOption = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedDecimal) usize {
            var res: usize = 0;
            if (self.scale) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedDecimalWire.SCALE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedDecimalWire.PRECISION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedDecimalWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedDecimalWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedDecimal, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedDecimal, target: *gremlin.Writer) void {
            if (self.scale) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedDecimalWire.SCALE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedDecimalWire.PRECISION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedDecimalWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedDecimalWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedDecimalReader = struct {
        _scale_buf: ?[]const u8 = null,
        _precision_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedDecimalReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedDecimalReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedDecimalWire.SCALE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._scale_buf = result.value;
                    },
                    ParameterizedType.ParameterizedDecimalWire.PRECISION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_buf = result.value;
                    },
                    ParameterizedType.ParameterizedDecimalWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedDecimalWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterizedDecimalReader) void { }
        
        pub fn getScale(self: *const ParameterizedDecimalReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.IntegerOptionReader {
            if (self._scale_buf) |buf| {
                return try ParameterizedType.IntegerOptionReader.init(allocator, buf);
            }
            return try ParameterizedType.IntegerOptionReader.init(allocator, &[_]u8{});
        }
        pub fn getPrecision(self: *const ParameterizedDecimalReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.IntegerOptionReader {
            if (self._precision_buf) |buf| {
                return try ParameterizedType.IntegerOptionReader.init(allocator, buf);
            }
            return try ParameterizedType.IntegerOptionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ParameterizedDecimalReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedDecimalReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ParameterizedIntervalDayWire = struct {
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ParameterizedIntervalDay = struct {
        // fields
        precision: ?ParameterizedType.IntegerOption = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedIntervalDay) usize {
            var res: usize = 0;
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedIntervalDayWire.PRECISION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedIntervalDayWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedIntervalDayWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedIntervalDay, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedIntervalDay, target: *gremlin.Writer) void {
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedIntervalDayWire.PRECISION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedIntervalDayWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedIntervalDayWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedIntervalDayReader = struct {
        _precision_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedIntervalDayReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedIntervalDayReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedIntervalDayWire.PRECISION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_buf = result.value;
                    },
                    ParameterizedType.ParameterizedIntervalDayWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedIntervalDayWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterizedIntervalDayReader) void { }
        
        pub fn getPrecision(self: *const ParameterizedIntervalDayReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.IntegerOptionReader {
            if (self._precision_buf) |buf| {
                return try ParameterizedType.IntegerOptionReader.init(allocator, buf);
            }
            return try ParameterizedType.IntegerOptionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ParameterizedIntervalDayReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedIntervalDayReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ParameterizedIntervalCompoundWire = struct {
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ParameterizedIntervalCompound = struct {
        // fields
        precision: ?ParameterizedType.IntegerOption = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedIntervalCompound) usize {
            var res: usize = 0;
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedIntervalCompoundWire.PRECISION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedIntervalCompoundWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedIntervalCompoundWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedIntervalCompound, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedIntervalCompound, target: *gremlin.Writer) void {
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedIntervalCompoundWire.PRECISION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedIntervalCompoundWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedIntervalCompoundWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedIntervalCompoundReader = struct {
        _precision_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedIntervalCompoundReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedIntervalCompoundReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedIntervalCompoundWire.PRECISION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_buf = result.value;
                    },
                    ParameterizedType.ParameterizedIntervalCompoundWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedIntervalCompoundWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterizedIntervalCompoundReader) void { }
        
        pub fn getPrecision(self: *const ParameterizedIntervalCompoundReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.IntegerOptionReader {
            if (self._precision_buf) |buf| {
                return try ParameterizedType.IntegerOptionReader.init(allocator, buf);
            }
            return try ParameterizedType.IntegerOptionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ParameterizedIntervalCompoundReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedIntervalCompoundReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ParameterizedPrecisionTimestampWire = struct {
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ParameterizedPrecisionTimestamp = struct {
        // fields
        precision: ?ParameterizedType.IntegerOption = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedPrecisionTimestamp) usize {
            var res: usize = 0;
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedPrecisionTimestampWire.PRECISION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedPrecisionTimestampWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedPrecisionTimestampWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedPrecisionTimestamp, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedPrecisionTimestamp, target: *gremlin.Writer) void {
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedPrecisionTimestampWire.PRECISION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedPrecisionTimestampWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedPrecisionTimestampWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedPrecisionTimestampReader = struct {
        _precision_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedPrecisionTimestampReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedPrecisionTimestampReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedPrecisionTimestampWire.PRECISION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_buf = result.value;
                    },
                    ParameterizedType.ParameterizedPrecisionTimestampWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedPrecisionTimestampWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterizedPrecisionTimestampReader) void { }
        
        pub fn getPrecision(self: *const ParameterizedPrecisionTimestampReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.IntegerOptionReader {
            if (self._precision_buf) |buf| {
                return try ParameterizedType.IntegerOptionReader.init(allocator, buf);
            }
            return try ParameterizedType.IntegerOptionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ParameterizedPrecisionTimestampReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedPrecisionTimestampReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ParameterizedPrecisionTimestampTZWire = struct {
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ParameterizedPrecisionTimestampTZ = struct {
        // fields
        precision: ?ParameterizedType.IntegerOption = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedPrecisionTimestampTZ) usize {
            var res: usize = 0;
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedPrecisionTimestampTZWire.PRECISION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedPrecisionTimestampTZWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedPrecisionTimestampTZWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedPrecisionTimestampTZ, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedPrecisionTimestampTZ, target: *gremlin.Writer) void {
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedPrecisionTimestampTZWire.PRECISION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedPrecisionTimestampTZWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedPrecisionTimestampTZWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedPrecisionTimestampTZReader = struct {
        _precision_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedPrecisionTimestampTZReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedPrecisionTimestampTZReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedPrecisionTimestampTZWire.PRECISION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_buf = result.value;
                    },
                    ParameterizedType.ParameterizedPrecisionTimestampTZWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedPrecisionTimestampTZWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterizedPrecisionTimestampTZReader) void { }
        
        pub fn getPrecision(self: *const ParameterizedPrecisionTimestampTZReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.IntegerOptionReader {
            if (self._precision_buf) |buf| {
                return try ParameterizedType.IntegerOptionReader.init(allocator, buf);
            }
            return try ParameterizedType.IntegerOptionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ParameterizedPrecisionTimestampTZReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedPrecisionTimestampTZReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ParameterizedStructWire = struct {
        const TYPES_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ParameterizedStruct = struct {
        // fields
        types: ?[]const ?ParameterizedType = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedStruct) usize {
            var res: usize = 0;
            if (self.types) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedStructWire.TYPES_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedStructWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedStructWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedStruct, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedStruct, target: *gremlin.Writer) void {
            if (self.types) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(ParameterizedType.ParameterizedStructWire.TYPES_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(ParameterizedType.ParameterizedStructWire.TYPES_WIRE, 0);
                    }
                }
            }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedStructWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedStructWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedStructReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _types_bufs: ?std.ArrayList([]const u8) = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedStructReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedStructReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedStructWire.TYPES_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._types_bufs == null) {
                            res._types_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._types_bufs.?.append(result.value);
                    },
                    ParameterizedType.ParameterizedStructWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedStructWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const ParameterizedStructReader) void {
            if (self._types_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getTypes(self: *const ParameterizedStructReader, allocator: std.mem.Allocator) gremlin.Error![]ParameterizedTypeReader {
            if (self._types_bufs) |bufs| {
                var result = try std.ArrayList(ParameterizedTypeReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try ParameterizedTypeReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]ParameterizedTypeReader{};
        }
        pub inline fn getVariationPointer(self: *const ParameterizedStructReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedStructReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ParameterizedNamedStructWire = struct {
        const NAMES_WIRE: gremlin.ProtoWireNumber = 1;
        const STRUCT_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const ParameterizedNamedStruct = struct {
        // fields
        names: ?[]const ?[]const u8 = null,
        struct_: ?ParameterizedType.ParameterizedStruct = null,

        pub fn calcProtobufSize(self: *const ParameterizedNamedStruct) usize {
            var res: usize = 0;
            if (self.names) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedNamedStructWire.NAMES_WIRE);
                    if (maybe_v) |v| {
                        res += gremlin.sizes.sizeUsize(v.len) + v.len;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.struct_) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedNamedStructWire.STRUCT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const ParameterizedNamedStruct, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedNamedStruct, target: *gremlin.Writer) void {
            if (self.names) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        target.appendBytes(ParameterizedType.ParameterizedNamedStructWire.NAMES_WIRE, v);
                    } else {
                        target.appendBytesTag(ParameterizedType.ParameterizedNamedStructWire.NAMES_WIRE, 0);
                    }
                }
            }
            if (self.struct_) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedNamedStructWire.STRUCT_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const ParameterizedNamedStructReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _names: ?std.ArrayList([]const u8) = null,
        _struct__buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedNamedStructReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedNamedStructReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedNamedStructWire.NAMES_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._names == null) {
                            res._names = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._names.?.append(result.value);
                    },
                    ParameterizedType.ParameterizedNamedStructWire.STRUCT_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._struct__buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const ParameterizedNamedStructReader) void {
            if (self._names) |arr| {
                arr.deinit();
            }
        }
        pub fn getNames(self: *const ParameterizedNamedStructReader) []const []const u8 {
            if (self._names) |arr| {
                return arr.items;
            }
            return &[_][]u8{};
        }
        pub fn getStruct(self: *const ParameterizedNamedStructReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedStructReader {
            if (self._struct__buf) |buf| {
                return try ParameterizedType.ParameterizedStructReader.init(allocator, buf);
            }
            return try ParameterizedType.ParameterizedStructReader.init(allocator, &[_]u8{});
        }
    };
    
    const ParameterizedListWire = struct {
        const TYPE_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ParameterizedList = struct {
        // fields
        type: ?ParameterizedType = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedList) usize {
            var res: usize = 0;
            if (self.type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedListWire.TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedListWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedListWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedList, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedList, target: *gremlin.Writer) void {
            if (self.type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedListWire.TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedListWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedListWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedListReader = struct {
        _type_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedListReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedListReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedListWire.TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._type_buf = result.value;
                    },
                    ParameterizedType.ParameterizedListWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedListWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterizedListReader) void { }
        
        pub fn getType(self: *const ParameterizedListReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedTypeReader {
            if (self._type_buf) |buf| {
                return try ParameterizedTypeReader.init(allocator, buf);
            }
            return try ParameterizedTypeReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ParameterizedListReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedListReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ParameterizedMapWire = struct {
        const KEY_WIRE: gremlin.ProtoWireNumber = 1;
        const VALUE_WIRE: gremlin.ProtoWireNumber = 2;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 3;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 4;
    };
    
    pub const ParameterizedMap = struct {
        // fields
        key: ?ParameterizedType = null,
        value: ?ParameterizedType = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedMap) usize {
            var res: usize = 0;
            if (self.key) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedMapWire.KEY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.value) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedMapWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedMapWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedMapWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedMap, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedMap, target: *gremlin.Writer) void {
            if (self.key) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedMapWire.KEY_WIRE, size);
                v.encodeTo(target);
            }
            if (self.value) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.ParameterizedMapWire.VALUE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedMapWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedMapWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedMapReader = struct {
        _key_buf: ?[]const u8 = null,
        _value_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedMapReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedMapReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedMapWire.KEY_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._key_buf = result.value;
                    },
                    ParameterizedType.ParameterizedMapWire.VALUE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._value_buf = result.value;
                    },
                    ParameterizedType.ParameterizedMapWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedMapWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterizedMapReader) void { }
        
        pub fn getKey(self: *const ParameterizedMapReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedTypeReader {
            if (self._key_buf) |buf| {
                return try ParameterizedTypeReader.init(allocator, buf);
            }
            return try ParameterizedTypeReader.init(allocator, &[_]u8{});
        }
        pub fn getValue(self: *const ParameterizedMapReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedTypeReader {
            if (self._value_buf) |buf| {
                return try ParameterizedTypeReader.init(allocator, buf);
            }
            return try ParameterizedTypeReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ParameterizedMapReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedMapReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ParameterizedUserDefinedWire = struct {
        const TYPE_POINTER_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ParameterizedUserDefined = struct {
        // fields
        type_pointer: u32 = 0,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ParameterizedUserDefined) usize {
            var res: usize = 0;
            if (self.type_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedUserDefinedWire.TYPE_POINTER_WIRE) + gremlin.sizes.sizeU32(self.type_pointer); }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedUserDefinedWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.ParameterizedUserDefinedWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ParameterizedUserDefined, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ParameterizedUserDefined, target: *gremlin.Writer) void {
            if (self.type_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedUserDefinedWire.TYPE_POINTER_WIRE, self.type_pointer); }
            if (self.variation_pointer != 0) { target.appendUint32(ParameterizedType.ParameterizedUserDefinedWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(ParameterizedType.ParameterizedUserDefinedWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ParameterizedUserDefinedReader = struct {
        _type_pointer: u32 = 0,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedUserDefinedReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterizedUserDefinedReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.ParameterizedUserDefinedWire.TYPE_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedUserDefinedWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    ParameterizedType.ParameterizedUserDefinedWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterizedUserDefinedReader) void { }
        
        pub inline fn getTypePointer(self: *const ParameterizedUserDefinedReader) u32 { return self._type_pointer; }
        pub inline fn getVariationPointer(self: *const ParameterizedUserDefinedReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ParameterizedUserDefinedReader) type.Type.Nullability { return self._nullability; }
    };
    
    const IntegerOptionWire = struct {
        const LITERAL_WIRE: gremlin.ProtoWireNumber = 1;
        const PARAMETER_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const IntegerOption = struct {
        // fields
        literal: i32 = 0,
        parameter: ?ParameterizedType.IntegerParameter = null,

        pub fn calcProtobufSize(self: *const IntegerOption) usize {
            var res: usize = 0;
            if (self.literal != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedType.IntegerOptionWire.LITERAL_WIRE) + gremlin.sizes.sizeI32(self.literal); }
            if (self.parameter) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ParameterizedType.IntegerOptionWire.PARAMETER_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const IntegerOption, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const IntegerOption, target: *gremlin.Writer) void {
            if (self.literal != 0) { target.appendInt32(ParameterizedType.IntegerOptionWire.LITERAL_WIRE, self.literal); }
            if (self.parameter) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ParameterizedType.IntegerOptionWire.PARAMETER_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const IntegerOptionReader = struct {
        _literal: i32 = 0,
        _parameter_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!IntegerOptionReader {
            var buf = gremlin.Reader.init(src);
            var res = IntegerOptionReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ParameterizedType.IntegerOptionWire.LITERAL_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._literal = result.value;
                    },
                    ParameterizedType.IntegerOptionWire.PARAMETER_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._parameter_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const IntegerOptionReader) void { }
        
        pub inline fn getLiteral(self: *const IntegerOptionReader) i32 { return self._literal; }
        pub fn getParameter(self: *const IntegerOptionReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.IntegerParameterReader {
            if (self._parameter_buf) |buf| {
                return try ParameterizedType.IntegerParameterReader.init(allocator, buf);
            }
            return try ParameterizedType.IntegerParameterReader.init(allocator, &[_]u8{});
        }
    };
    
    // fields
    bool: ?type.Type.Boolean = null,
    i8: ?type.Type.I8 = null,
    i16: ?type.Type.I16 = null,
    i32: ?type.Type.I32 = null,
    i64: ?type.Type.I64 = null,
    fp32: ?type.Type.FP32 = null,
    fp64: ?type.Type.FP64 = null,
    string: ?type.Type.String = null,
    binary: ?type.Type.Binary = null,
    timestamp: ?type.Type.Timestamp = null,
    date: ?type.Type.Date = null,
    time: ?type.Type.Time = null,
    interval_year: ?type.Type.IntervalYear = null,
    interval_day: ?ParameterizedType.ParameterizedIntervalDay = null,
    interval_compound: ?ParameterizedType.ParameterizedIntervalCompound = null,
    timestamp_tz: ?type.Type.TimestampTZ = null,
    uuid: ?type.Type.UUID = null,
    fixed_char: ?ParameterizedType.ParameterizedFixedChar = null,
    varchar: ?ParameterizedType.ParameterizedVarChar = null,
    fixed_binary: ?ParameterizedType.ParameterizedFixedBinary = null,
    decimal: ?ParameterizedType.ParameterizedDecimal = null,
    precision_timestamp: ?ParameterizedType.ParameterizedPrecisionTimestamp = null,
    precision_timestamp_tz: ?ParameterizedType.ParameterizedPrecisionTimestampTZ = null,
    struct_: ?ParameterizedType.ParameterizedStruct = null,
    list: ?ParameterizedType.ParameterizedList = null,
    map: ?ParameterizedType.ParameterizedMap = null,
    user_defined: ?ParameterizedType.ParameterizedUserDefined = null,
    user_defined_pointer: u32 = 0,
    type_parameter: ?ParameterizedType.TypeParameter = null,

    pub fn calcProtobufSize(self: *const ParameterizedType) usize {
        var res: usize = 0;
        if (self.bool) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.BOOL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i8) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.I8_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i16) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.I16_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i32) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.I32_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i64) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.I64_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fp32) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.FP32_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fp64) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.FP64_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.string) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.STRING_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.binary) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.BINARY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.timestamp) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.TIMESTAMP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.date) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.DATE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.time) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.TIME_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.interval_year) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.INTERVAL_YEAR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.interval_day) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.INTERVAL_DAY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.interval_compound) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.INTERVAL_COMPOUND_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.TIMESTAMP_TZ_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.uuid) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.UUID_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fixed_char) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.FIXED_CHAR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.varchar) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.VARCHAR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fixed_binary) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.FIXED_BINARY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.decimal) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.DECIMAL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.precision_timestamp) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.PRECISION_TIMESTAMP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.precision_timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.PRECISION_TIMESTAMP_TZ_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.struct_) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.STRUCT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.list) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.LIST_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.map) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.MAP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.user_defined) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.USER_DEFINED_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.user_defined_pointer != 0) { res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.USER_DEFINED_POINTER_WIRE) + gremlin.sizes.sizeU32(self.user_defined_pointer); }
        if (self.type_parameter) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ParameterizedTypeWire.TYPE_PARAMETER_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const ParameterizedType, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ParameterizedType, target: *gremlin.Writer) void {
        if (self.bool) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.BOOL_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i8) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.I8_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i16) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.I16_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i32) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.I32_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i64) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.I64_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fp32) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.FP32_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fp64) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.FP64_WIRE, size);
            v.encodeTo(target);
        }
        if (self.string) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.STRING_WIRE, size);
            v.encodeTo(target);
        }
        if (self.binary) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.BINARY_WIRE, size);
            v.encodeTo(target);
        }
        if (self.timestamp) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.TIMESTAMP_WIRE, size);
            v.encodeTo(target);
        }
        if (self.date) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.DATE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.time) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.TIME_WIRE, size);
            v.encodeTo(target);
        }
        if (self.interval_year) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.INTERVAL_YEAR_WIRE, size);
            v.encodeTo(target);
        }
        if (self.interval_day) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.INTERVAL_DAY_WIRE, size);
            v.encodeTo(target);
        }
        if (self.interval_compound) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.INTERVAL_COMPOUND_WIRE, size);
            v.encodeTo(target);
        }
        if (self.timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.TIMESTAMP_TZ_WIRE, size);
            v.encodeTo(target);
        }
        if (self.uuid) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.UUID_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fixed_char) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.FIXED_CHAR_WIRE, size);
            v.encodeTo(target);
        }
        if (self.varchar) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.VARCHAR_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fixed_binary) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.FIXED_BINARY_WIRE, size);
            v.encodeTo(target);
        }
        if (self.decimal) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.DECIMAL_WIRE, size);
            v.encodeTo(target);
        }
        if (self.precision_timestamp) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.PRECISION_TIMESTAMP_WIRE, size);
            v.encodeTo(target);
        }
        if (self.precision_timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.PRECISION_TIMESTAMP_TZ_WIRE, size);
            v.encodeTo(target);
        }
        if (self.struct_) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.STRUCT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.list) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.LIST_WIRE, size);
            v.encodeTo(target);
        }
        if (self.map) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.MAP_WIRE, size);
            v.encodeTo(target);
        }
        if (self.user_defined) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.USER_DEFINED_WIRE, size);
            v.encodeTo(target);
        }
        if (self.user_defined_pointer != 0) { target.appendUint32(ParameterizedTypeWire.USER_DEFINED_POINTER_WIRE, self.user_defined_pointer); }
        if (self.type_parameter) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ParameterizedTypeWire.TYPE_PARAMETER_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ParameterizedTypeReader = struct {
    _bool_buf: ?[]const u8 = null,
    _i8_buf: ?[]const u8 = null,
    _i16_buf: ?[]const u8 = null,
    _i32_buf: ?[]const u8 = null,
    _i64_buf: ?[]const u8 = null,
    _fp32_buf: ?[]const u8 = null,
    _fp64_buf: ?[]const u8 = null,
    _string_buf: ?[]const u8 = null,
    _binary_buf: ?[]const u8 = null,
    _timestamp_buf: ?[]const u8 = null,
    _date_buf: ?[]const u8 = null,
    _time_buf: ?[]const u8 = null,
    _interval_year_buf: ?[]const u8 = null,
    _interval_day_buf: ?[]const u8 = null,
    _interval_compound_buf: ?[]const u8 = null,
    _timestamp_tz_buf: ?[]const u8 = null,
    _uuid_buf: ?[]const u8 = null,
    _fixed_char_buf: ?[]const u8 = null,
    _varchar_buf: ?[]const u8 = null,
    _fixed_binary_buf: ?[]const u8 = null,
    _decimal_buf: ?[]const u8 = null,
    _precision_timestamp_buf: ?[]const u8 = null,
    _precision_timestamp_tz_buf: ?[]const u8 = null,
    _struct__buf: ?[]const u8 = null,
    _list_buf: ?[]const u8 = null,
    _map_buf: ?[]const u8 = null,
    _user_defined_buf: ?[]const u8 = null,
    _user_defined_pointer: u32 = 0,
    _type_parameter_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterizedTypeReader {
        var buf = gremlin.Reader.init(src);
        var res = ParameterizedTypeReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ParameterizedTypeWire.BOOL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._bool_buf = result.value;
                },
                ParameterizedTypeWire.I8_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i8_buf = result.value;
                },
                ParameterizedTypeWire.I16_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i16_buf = result.value;
                },
                ParameterizedTypeWire.I32_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i32_buf = result.value;
                },
                ParameterizedTypeWire.I64_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i64_buf = result.value;
                },
                ParameterizedTypeWire.FP32_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fp32_buf = result.value;
                },
                ParameterizedTypeWire.FP64_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fp64_buf = result.value;
                },
                ParameterizedTypeWire.STRING_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._string_buf = result.value;
                },
                ParameterizedTypeWire.BINARY_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._binary_buf = result.value;
                },
                ParameterizedTypeWire.TIMESTAMP_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._timestamp_buf = result.value;
                },
                ParameterizedTypeWire.DATE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._date_buf = result.value;
                },
                ParameterizedTypeWire.TIME_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._time_buf = result.value;
                },
                ParameterizedTypeWire.INTERVAL_YEAR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._interval_year_buf = result.value;
                },
                ParameterizedTypeWire.INTERVAL_DAY_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._interval_day_buf = result.value;
                },
                ParameterizedTypeWire.INTERVAL_COMPOUND_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._interval_compound_buf = result.value;
                },
                ParameterizedTypeWire.TIMESTAMP_TZ_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._timestamp_tz_buf = result.value;
                },
                ParameterizedTypeWire.UUID_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._uuid_buf = result.value;
                },
                ParameterizedTypeWire.FIXED_CHAR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fixed_char_buf = result.value;
                },
                ParameterizedTypeWire.VARCHAR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._varchar_buf = result.value;
                },
                ParameterizedTypeWire.FIXED_BINARY_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fixed_binary_buf = result.value;
                },
                ParameterizedTypeWire.DECIMAL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._decimal_buf = result.value;
                },
                ParameterizedTypeWire.PRECISION_TIMESTAMP_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._precision_timestamp_buf = result.value;
                },
                ParameterizedTypeWire.PRECISION_TIMESTAMP_TZ_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._precision_timestamp_tz_buf = result.value;
                },
                ParameterizedTypeWire.STRUCT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._struct__buf = result.value;
                },
                ParameterizedTypeWire.LIST_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._list_buf = result.value;
                },
                ParameterizedTypeWire.MAP_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._map_buf = result.value;
                },
                ParameterizedTypeWire.USER_DEFINED_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._user_defined_buf = result.value;
                },
                ParameterizedTypeWire.USER_DEFINED_POINTER_WIRE => {
                  const result = try buf.readUInt32(offset);
                  offset += result.size;
                  res._user_defined_pointer = result.value;
                },
                ParameterizedTypeWire.TYPE_PARAMETER_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._type_parameter_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const ParameterizedTypeReader) void { }
    
    pub fn getBool(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.BooleanReader {
        if (self._bool_buf) |buf| {
            return try type.Type.BooleanReader.init(allocator, buf);
        }
        return try type.Type.BooleanReader.init(allocator, &[_]u8{});
    }
    pub fn getI8(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.I8Reader {
        if (self._i8_buf) |buf| {
            return try type.Type.I8Reader.init(allocator, buf);
        }
        return try type.Type.I8Reader.init(allocator, &[_]u8{});
    }
    pub fn getI16(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.I16Reader {
        if (self._i16_buf) |buf| {
            return try type.Type.I16Reader.init(allocator, buf);
        }
        return try type.Type.I16Reader.init(allocator, &[_]u8{});
    }
    pub fn getI32(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.I32Reader {
        if (self._i32_buf) |buf| {
            return try type.Type.I32Reader.init(allocator, buf);
        }
        return try type.Type.I32Reader.init(allocator, &[_]u8{});
    }
    pub fn getI64(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.I64Reader {
        if (self._i64_buf) |buf| {
            return try type.Type.I64Reader.init(allocator, buf);
        }
        return try type.Type.I64Reader.init(allocator, &[_]u8{});
    }
    pub fn getFp32(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.FP32Reader {
        if (self._fp32_buf) |buf| {
            return try type.Type.FP32Reader.init(allocator, buf);
        }
        return try type.Type.FP32Reader.init(allocator, &[_]u8{});
    }
    pub fn getFp64(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.FP64Reader {
        if (self._fp64_buf) |buf| {
            return try type.Type.FP64Reader.init(allocator, buf);
        }
        return try type.Type.FP64Reader.init(allocator, &[_]u8{});
    }
    pub fn getString(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.StringReader {
        if (self._string_buf) |buf| {
            return try type.Type.StringReader.init(allocator, buf);
        }
        return try type.Type.StringReader.init(allocator, &[_]u8{});
    }
    pub fn getBinary(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.BinaryReader {
        if (self._binary_buf) |buf| {
            return try type.Type.BinaryReader.init(allocator, buf);
        }
        return try type.Type.BinaryReader.init(allocator, &[_]u8{});
    }
    pub fn getTimestamp(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.TimestampReader {
        if (self._timestamp_buf) |buf| {
            return try type.Type.TimestampReader.init(allocator, buf);
        }
        return try type.Type.TimestampReader.init(allocator, &[_]u8{});
    }
    pub fn getDate(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.DateReader {
        if (self._date_buf) |buf| {
            return try type.Type.DateReader.init(allocator, buf);
        }
        return try type.Type.DateReader.init(allocator, &[_]u8{});
    }
    pub fn getTime(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.TimeReader {
        if (self._time_buf) |buf| {
            return try type.Type.TimeReader.init(allocator, buf);
        }
        return try type.Type.TimeReader.init(allocator, &[_]u8{});
    }
    pub fn getIntervalYear(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.IntervalYearReader {
        if (self._interval_year_buf) |buf| {
            return try type.Type.IntervalYearReader.init(allocator, buf);
        }
        return try type.Type.IntervalYearReader.init(allocator, &[_]u8{});
    }
    pub fn getIntervalDay(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedIntervalDayReader {
        if (self._interval_day_buf) |buf| {
            return try ParameterizedType.ParameterizedIntervalDayReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedIntervalDayReader.init(allocator, &[_]u8{});
    }
    pub fn getIntervalCompound(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedIntervalCompoundReader {
        if (self._interval_compound_buf) |buf| {
            return try ParameterizedType.ParameterizedIntervalCompoundReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedIntervalCompoundReader.init(allocator, &[_]u8{});
    }
    pub fn getTimestampTz(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.TimestampTZReader {
        if (self._timestamp_tz_buf) |buf| {
            return try type.Type.TimestampTZReader.init(allocator, buf);
        }
        return try type.Type.TimestampTZReader.init(allocator, &[_]u8{});
    }
    pub fn getUuid(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.UUIDReader {
        if (self._uuid_buf) |buf| {
            return try type.Type.UUIDReader.init(allocator, buf);
        }
        return try type.Type.UUIDReader.init(allocator, &[_]u8{});
    }
    pub fn getFixedChar(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedFixedCharReader {
        if (self._fixed_char_buf) |buf| {
            return try ParameterizedType.ParameterizedFixedCharReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedFixedCharReader.init(allocator, &[_]u8{});
    }
    pub fn getVarchar(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedVarCharReader {
        if (self._varchar_buf) |buf| {
            return try ParameterizedType.ParameterizedVarCharReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedVarCharReader.init(allocator, &[_]u8{});
    }
    pub fn getFixedBinary(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedFixedBinaryReader {
        if (self._fixed_binary_buf) |buf| {
            return try ParameterizedType.ParameterizedFixedBinaryReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedFixedBinaryReader.init(allocator, &[_]u8{});
    }
    pub fn getDecimal(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedDecimalReader {
        if (self._decimal_buf) |buf| {
            return try ParameterizedType.ParameterizedDecimalReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedDecimalReader.init(allocator, &[_]u8{});
    }
    pub fn getPrecisionTimestamp(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedPrecisionTimestampReader {
        if (self._precision_timestamp_buf) |buf| {
            return try ParameterizedType.ParameterizedPrecisionTimestampReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedPrecisionTimestampReader.init(allocator, &[_]u8{});
    }
    pub fn getPrecisionTimestampTz(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedPrecisionTimestampTZReader {
        if (self._precision_timestamp_tz_buf) |buf| {
            return try ParameterizedType.ParameterizedPrecisionTimestampTZReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedPrecisionTimestampTZReader.init(allocator, &[_]u8{});
    }
    pub fn getStruct(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedStructReader {
        if (self._struct__buf) |buf| {
            return try ParameterizedType.ParameterizedStructReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedStructReader.init(allocator, &[_]u8{});
    }
    pub fn getList(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedListReader {
        if (self._list_buf) |buf| {
            return try ParameterizedType.ParameterizedListReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedListReader.init(allocator, &[_]u8{});
    }
    pub fn getMap(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedMapReader {
        if (self._map_buf) |buf| {
            return try ParameterizedType.ParameterizedMapReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedMapReader.init(allocator, &[_]u8{});
    }
    pub fn getUserDefined(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.ParameterizedUserDefinedReader {
        if (self._user_defined_buf) |buf| {
            return try ParameterizedType.ParameterizedUserDefinedReader.init(allocator, buf);
        }
        return try ParameterizedType.ParameterizedUserDefinedReader.init(allocator, &[_]u8{});
    }
    pub inline fn getUserDefinedPointer(self: *const ParameterizedTypeReader) u32 { return self._user_defined_pointer; }
    pub fn getTypeParameter(self: *const ParameterizedTypeReader, allocator: std.mem.Allocator) gremlin.Error!ParameterizedType.TypeParameterReader {
        if (self._type_parameter_buf) |buf| {
            return try ParameterizedType.TypeParameterReader.init(allocator, buf);
        }
        return try ParameterizedType.TypeParameterReader.init(allocator, &[_]u8{});
    }
};

