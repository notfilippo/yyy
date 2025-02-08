const std = @import("std");
const gremlin = @import("gremlin");
const type = @import("type.proto.zig");

// structs
const DerivationExpressionWire = struct {
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
    const TIMESTAMP_TZ_WIRE: gremlin.ProtoWireNumber = 29;
    const UUID_WIRE: gremlin.ProtoWireNumber = 32;
    const INTERVAL_DAY_WIRE: gremlin.ProtoWireNumber = 20;
    const INTERVAL_COMPOUND_WIRE: gremlin.ProtoWireNumber = 42;
    const FIXED_CHAR_WIRE: gremlin.ProtoWireNumber = 21;
    const VARCHAR_WIRE: gremlin.ProtoWireNumber = 22;
    const FIXED_BINARY_WIRE: gremlin.ProtoWireNumber = 23;
    const DECIMAL_WIRE: gremlin.ProtoWireNumber = 24;
    const PRECISION_TIMESTAMP_WIRE: gremlin.ProtoWireNumber = 40;
    const PRECISION_TIMESTAMP_TZ_WIRE: gremlin.ProtoWireNumber = 41;
    const STRUCT_WIRE: gremlin.ProtoWireNumber = 25;
    const LIST_WIRE: gremlin.ProtoWireNumber = 27;
    const MAP_WIRE: gremlin.ProtoWireNumber = 28;
    const USER_DEFINED_WIRE: gremlin.ProtoWireNumber = 30;
    const USER_DEFINED_POINTER_WIRE: gremlin.ProtoWireNumber = 31;
    const TYPE_PARAMETER_NAME_WIRE: gremlin.ProtoWireNumber = 33;
    const INTEGER_PARAMETER_NAME_WIRE: gremlin.ProtoWireNumber = 34;
    const INTEGER_LITERAL_WIRE: gremlin.ProtoWireNumber = 35;
    const UNARY_OP_WIRE: gremlin.ProtoWireNumber = 36;
    const BINARY_OP_WIRE: gremlin.ProtoWireNumber = 37;
    const IF_ELSE_WIRE: gremlin.ProtoWireNumber = 38;
    const RETURN_PROGRAM_WIRE: gremlin.ProtoWireNumber = 39;
};

pub const DerivationExpression = struct {
    // nested structs
    const ExpressionFixedCharWire = struct {
        const LENGTH_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExpressionFixedChar = struct {
        // fields
        length: ?DerivationExpression = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionFixedChar) usize {
            var res: usize = 0;
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionFixedCharWire.LENGTH_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionFixedCharWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionFixedCharWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionFixedChar, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionFixedChar, target: *gremlin.Writer) void {
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionFixedCharWire.LENGTH_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionFixedCharWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionFixedCharWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionFixedCharReader = struct {
        _length_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionFixedCharReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionFixedCharReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionFixedCharWire.LENGTH_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._length_buf = result.value;
                    },
                    DerivationExpression.ExpressionFixedCharWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionFixedCharWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ExpressionFixedCharReader) void { }
        
        pub fn getLength(self: *const ExpressionFixedCharReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._length_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ExpressionFixedCharReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionFixedCharReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ExpressionVarCharWire = struct {
        const LENGTH_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExpressionVarChar = struct {
        // fields
        length: ?DerivationExpression = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionVarChar) usize {
            var res: usize = 0;
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionVarCharWire.LENGTH_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionVarCharWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionVarCharWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionVarChar, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionVarChar, target: *gremlin.Writer) void {
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionVarCharWire.LENGTH_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionVarCharWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionVarCharWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionVarCharReader = struct {
        _length_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionVarCharReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionVarCharReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionVarCharWire.LENGTH_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._length_buf = result.value;
                    },
                    DerivationExpression.ExpressionVarCharWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionVarCharWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ExpressionVarCharReader) void { }
        
        pub fn getLength(self: *const ExpressionVarCharReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._length_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ExpressionVarCharReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionVarCharReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ExpressionFixedBinaryWire = struct {
        const LENGTH_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExpressionFixedBinary = struct {
        // fields
        length: ?DerivationExpression = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionFixedBinary) usize {
            var res: usize = 0;
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionFixedBinaryWire.LENGTH_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionFixedBinaryWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionFixedBinaryWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionFixedBinary, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionFixedBinary, target: *gremlin.Writer) void {
            if (self.length) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionFixedBinaryWire.LENGTH_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionFixedBinaryWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionFixedBinaryWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionFixedBinaryReader = struct {
        _length_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionFixedBinaryReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionFixedBinaryReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionFixedBinaryWire.LENGTH_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._length_buf = result.value;
                    },
                    DerivationExpression.ExpressionFixedBinaryWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionFixedBinaryWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ExpressionFixedBinaryReader) void { }
        
        pub fn getLength(self: *const ExpressionFixedBinaryReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._length_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ExpressionFixedBinaryReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionFixedBinaryReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ExpressionDecimalWire = struct {
        const SCALE_WIRE: gremlin.ProtoWireNumber = 1;
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 2;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 3;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 4;
    };
    
    pub const ExpressionDecimal = struct {
        // fields
        scale: ?DerivationExpression = null,
        precision: ?DerivationExpression = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionDecimal) usize {
            var res: usize = 0;
            if (self.scale) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionDecimalWire.SCALE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionDecimalWire.PRECISION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionDecimalWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionDecimalWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionDecimal, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionDecimal, target: *gremlin.Writer) void {
            if (self.scale) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionDecimalWire.SCALE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionDecimalWire.PRECISION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionDecimalWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionDecimalWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionDecimalReader = struct {
        _scale_buf: ?[]const u8 = null,
        _precision_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionDecimalReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionDecimalReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionDecimalWire.SCALE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._scale_buf = result.value;
                    },
                    DerivationExpression.ExpressionDecimalWire.PRECISION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_buf = result.value;
                    },
                    DerivationExpression.ExpressionDecimalWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionDecimalWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ExpressionDecimalReader) void { }
        
        pub fn getScale(self: *const ExpressionDecimalReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._scale_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub fn getPrecision(self: *const ExpressionDecimalReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._precision_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ExpressionDecimalReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionDecimalReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ExpressionPrecisionTimestampWire = struct {
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExpressionPrecisionTimestamp = struct {
        // fields
        precision: ?DerivationExpression = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionPrecisionTimestamp) usize {
            var res: usize = 0;
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionPrecisionTimestampWire.PRECISION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionPrecisionTimestampWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionPrecisionTimestampWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionPrecisionTimestamp, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionPrecisionTimestamp, target: *gremlin.Writer) void {
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionPrecisionTimestampWire.PRECISION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionPrecisionTimestampWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionPrecisionTimestampWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionPrecisionTimestampReader = struct {
        _precision_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionPrecisionTimestampReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionPrecisionTimestampReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionPrecisionTimestampWire.PRECISION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_buf = result.value;
                    },
                    DerivationExpression.ExpressionPrecisionTimestampWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionPrecisionTimestampWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ExpressionPrecisionTimestampReader) void { }
        
        pub fn getPrecision(self: *const ExpressionPrecisionTimestampReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._precision_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ExpressionPrecisionTimestampReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionPrecisionTimestampReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ExpressionIntervalDayWire = struct {
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExpressionIntervalDay = struct {
        // fields
        precision: ?DerivationExpression = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionIntervalDay) usize {
            var res: usize = 0;
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionIntervalDayWire.PRECISION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionIntervalDayWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionIntervalDayWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionIntervalDay, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionIntervalDay, target: *gremlin.Writer) void {
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionIntervalDayWire.PRECISION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionIntervalDayWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionIntervalDayWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionIntervalDayReader = struct {
        _precision_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionIntervalDayReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionIntervalDayReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionIntervalDayWire.PRECISION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_buf = result.value;
                    },
                    DerivationExpression.ExpressionIntervalDayWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionIntervalDayWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ExpressionIntervalDayReader) void { }
        
        pub fn getPrecision(self: *const ExpressionIntervalDayReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._precision_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ExpressionIntervalDayReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionIntervalDayReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ExpressionIntervalCompoundWire = struct {
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExpressionIntervalCompound = struct {
        // fields
        precision: ?DerivationExpression = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionIntervalCompound) usize {
            var res: usize = 0;
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionIntervalCompoundWire.PRECISION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionIntervalCompoundWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionIntervalCompoundWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionIntervalCompound, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionIntervalCompound, target: *gremlin.Writer) void {
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionIntervalCompoundWire.PRECISION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionIntervalCompoundWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionIntervalCompoundWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionIntervalCompoundReader = struct {
        _precision_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionIntervalCompoundReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionIntervalCompoundReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionIntervalCompoundWire.PRECISION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_buf = result.value;
                    },
                    DerivationExpression.ExpressionIntervalCompoundWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionIntervalCompoundWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ExpressionIntervalCompoundReader) void { }
        
        pub fn getPrecision(self: *const ExpressionIntervalCompoundReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._precision_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ExpressionIntervalCompoundReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionIntervalCompoundReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ExpressionPrecisionTimestampTZWire = struct {
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExpressionPrecisionTimestampTZ = struct {
        // fields
        precision: ?DerivationExpression = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionPrecisionTimestampTZ) usize {
            var res: usize = 0;
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionPrecisionTimestampTZWire.PRECISION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionPrecisionTimestampTZWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionPrecisionTimestampTZWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionPrecisionTimestampTZ, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionPrecisionTimestampTZ, target: *gremlin.Writer) void {
            if (self.precision) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionPrecisionTimestampTZWire.PRECISION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionPrecisionTimestampTZWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionPrecisionTimestampTZWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionPrecisionTimestampTZReader = struct {
        _precision_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionPrecisionTimestampTZReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionPrecisionTimestampTZReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionPrecisionTimestampTZWire.PRECISION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_buf = result.value;
                    },
                    DerivationExpression.ExpressionPrecisionTimestampTZWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionPrecisionTimestampTZWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ExpressionPrecisionTimestampTZReader) void { }
        
        pub fn getPrecision(self: *const ExpressionPrecisionTimestampTZReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._precision_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ExpressionPrecisionTimestampTZReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionPrecisionTimestampTZReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ExpressionStructWire = struct {
        const TYPES_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExpressionStruct = struct {
        // fields
        types: ?[]const ?DerivationExpression = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionStruct) usize {
            var res: usize = 0;
            if (self.types) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionStructWire.TYPES_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionStructWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionStructWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionStruct, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionStruct, target: *gremlin.Writer) void {
            if (self.types) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(DerivationExpression.ExpressionStructWire.TYPES_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(DerivationExpression.ExpressionStructWire.TYPES_WIRE, 0);
                    }
                }
            }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionStructWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionStructWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionStructReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _types_bufs: ?std.ArrayList([]const u8) = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionStructReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionStructReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionStructWire.TYPES_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._types_bufs == null) {
                            res._types_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._types_bufs.?.append(result.value);
                    },
                    DerivationExpression.ExpressionStructWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionStructWire.NULLABILITY_WIRE => {
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
        pub fn deinit(self: *const ExpressionStructReader) void {
            if (self._types_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getTypes(self: *const ExpressionStructReader, allocator: std.mem.Allocator) gremlin.Error![]DerivationExpressionReader {
            if (self._types_bufs) |bufs| {
                var result = try std.ArrayList(DerivationExpressionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try DerivationExpressionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]DerivationExpressionReader{};
        }
        pub inline fn getVariationPointer(self: *const ExpressionStructReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionStructReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ExpressionNamedStructWire = struct {
        const NAMES_WIRE: gremlin.ProtoWireNumber = 1;
        const STRUCT_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const ExpressionNamedStruct = struct {
        // fields
        names: ?[]const ?[]const u8 = null,
        struct_: ?DerivationExpression.ExpressionStruct = null,

        pub fn calcProtobufSize(self: *const ExpressionNamedStruct) usize {
            var res: usize = 0;
            if (self.names) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionNamedStructWire.NAMES_WIRE);
                    if (maybe_v) |v| {
                        res += gremlin.sizes.sizeUsize(v.len) + v.len;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.struct_) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionNamedStructWire.STRUCT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const ExpressionNamedStruct, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionNamedStruct, target: *gremlin.Writer) void {
            if (self.names) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        target.appendBytes(DerivationExpression.ExpressionNamedStructWire.NAMES_WIRE, v);
                    } else {
                        target.appendBytesTag(DerivationExpression.ExpressionNamedStructWire.NAMES_WIRE, 0);
                    }
                }
            }
            if (self.struct_) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionNamedStructWire.STRUCT_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const ExpressionNamedStructReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _names: ?std.ArrayList([]const u8) = null,
        _struct__buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionNamedStructReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionNamedStructReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionNamedStructWire.NAMES_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._names == null) {
                            res._names = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._names.?.append(result.value);
                    },
                    DerivationExpression.ExpressionNamedStructWire.STRUCT_WIRE => {
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
        pub fn deinit(self: *const ExpressionNamedStructReader) void {
            if (self._names) |arr| {
                arr.deinit();
            }
        }
        pub fn getNames(self: *const ExpressionNamedStructReader) []const []const u8 {
            if (self._names) |arr| {
                return arr.items;
            }
            return &[_][]u8{};
        }
        pub fn getStruct(self: *const ExpressionNamedStructReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionStructReader {
            if (self._struct__buf) |buf| {
                return try DerivationExpression.ExpressionStructReader.init(allocator, buf);
            }
            return try DerivationExpression.ExpressionStructReader.init(allocator, &[_]u8{});
        }
    };
    
    const ExpressionListWire = struct {
        const TYPE_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExpressionList = struct {
        // fields
        type: ?DerivationExpression = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionList) usize {
            var res: usize = 0;
            if (self.type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionListWire.TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionListWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionListWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionList, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionList, target: *gremlin.Writer) void {
            if (self.type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionListWire.TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionListWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionListWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionListReader = struct {
        _type_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionListReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionListReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionListWire.TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._type_buf = result.value;
                    },
                    DerivationExpression.ExpressionListWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionListWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ExpressionListReader) void { }
        
        pub fn getType(self: *const ExpressionListReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._type_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ExpressionListReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionListReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ExpressionMapWire = struct {
        const KEY_WIRE: gremlin.ProtoWireNumber = 1;
        const VALUE_WIRE: gremlin.ProtoWireNumber = 2;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 3;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 4;
    };
    
    pub const ExpressionMap = struct {
        // fields
        key: ?DerivationExpression = null,
        value: ?DerivationExpression = null,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionMap) usize {
            var res: usize = 0;
            if (self.key) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionMapWire.KEY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.value) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionMapWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionMapWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionMapWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionMap, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionMap, target: *gremlin.Writer) void {
            if (self.key) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionMapWire.KEY_WIRE, size);
                v.encodeTo(target);
            }
            if (self.value) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ExpressionMapWire.VALUE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionMapWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionMapWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionMapReader = struct {
        _key_buf: ?[]const u8 = null,
        _value_buf: ?[]const u8 = null,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionMapReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionMapReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionMapWire.KEY_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._key_buf = result.value;
                    },
                    DerivationExpression.ExpressionMapWire.VALUE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._value_buf = result.value;
                    },
                    DerivationExpression.ExpressionMapWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionMapWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ExpressionMapReader) void { }
        
        pub fn getKey(self: *const ExpressionMapReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._key_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub fn getValue(self: *const ExpressionMapReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._value_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getVariationPointer(self: *const ExpressionMapReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionMapReader) type.Type.Nullability { return self._nullability; }
    };
    
    const ExpressionUserDefinedWire = struct {
        const TYPE_POINTER_WIRE: gremlin.ProtoWireNumber = 1;
        const VARIATION_POINTER_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExpressionUserDefined = struct {
        // fields
        type_pointer: u32 = 0,
        variation_pointer: u32 = 0,
        nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const ExpressionUserDefined) usize {
            var res: usize = 0;
            if (self.type_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionUserDefinedWire.TYPE_POINTER_WIRE) + gremlin.sizes.sizeU32(self.type_pointer); }
            if (self.variation_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionUserDefinedWire.VARIATION_POINTER_WIRE) + gremlin.sizes.sizeU32(self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ExpressionUserDefinedWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const ExpressionUserDefined, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpressionUserDefined, target: *gremlin.Writer) void {
            if (self.type_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionUserDefinedWire.TYPE_POINTER_WIRE, self.type_pointer); }
            if (self.variation_pointer != 0) { target.appendUint32(DerivationExpression.ExpressionUserDefinedWire.VARIATION_POINTER_WIRE, self.variation_pointer); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(DerivationExpression.ExpressionUserDefinedWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ExpressionUserDefinedReader = struct {
        _type_pointer: u32 = 0,
        _variation_pointer: u32 = 0,
        _nullability: type.Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionUserDefinedReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpressionUserDefinedReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ExpressionUserDefinedWire.TYPE_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_pointer = result.value;
                    },
                    DerivationExpression.ExpressionUserDefinedWire.VARIATION_POINTER_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._variation_pointer = result.value;
                    },
                    DerivationExpression.ExpressionUserDefinedWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ExpressionUserDefinedReader) void { }
        
        pub inline fn getTypePointer(self: *const ExpressionUserDefinedReader) u32 { return self._type_pointer; }
        pub inline fn getVariationPointer(self: *const ExpressionUserDefinedReader) u32 { return self._variation_pointer; }
        pub inline fn getNullability(self: *const ExpressionUserDefinedReader) type.Type.Nullability { return self._nullability; }
    };
    
    const IfElseWire = struct {
        const IF_CONDITION_WIRE: gremlin.ProtoWireNumber = 1;
        const IF_RETURN_WIRE: gremlin.ProtoWireNumber = 2;
        const ELSE_RETURN_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const IfElse = struct {
        // fields
        if_condition: ?DerivationExpression = null,
        if_return: ?DerivationExpression = null,
        else_return: ?DerivationExpression = null,

        pub fn calcProtobufSize(self: *const IfElse) usize {
            var res: usize = 0;
            if (self.if_condition) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.IfElseWire.IF_CONDITION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.if_return) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.IfElseWire.IF_RETURN_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.else_return) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.IfElseWire.ELSE_RETURN_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const IfElse, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const IfElse, target: *gremlin.Writer) void {
            if (self.if_condition) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.IfElseWire.IF_CONDITION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.if_return) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.IfElseWire.IF_RETURN_WIRE, size);
                v.encodeTo(target);
            }
            if (self.else_return) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.IfElseWire.ELSE_RETURN_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const IfElseReader = struct {
        _if_condition_buf: ?[]const u8 = null,
        _if_return_buf: ?[]const u8 = null,
        _else_return_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!IfElseReader {
            var buf = gremlin.Reader.init(src);
            var res = IfElseReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.IfElseWire.IF_CONDITION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._if_condition_buf = result.value;
                    },
                    DerivationExpression.IfElseWire.IF_RETURN_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._if_return_buf = result.value;
                    },
                    DerivationExpression.IfElseWire.ELSE_RETURN_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._else_return_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const IfElseReader) void { }
        
        pub fn getIfCondition(self: *const IfElseReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._if_condition_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub fn getIfReturn(self: *const IfElseReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._if_return_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub fn getElseReturn(self: *const IfElseReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._else_return_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
    };
    
    const UnaryOpWire = struct {
        const OP_TYPE_WIRE: gremlin.ProtoWireNumber = 1;
        const ARG_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const UnaryOp = struct {
        // nested enums
        pub const UnaryOpType = enum(i32) {
            UNARY_OP_TYPE_UNSPECIFIED = 0,
            UNARY_OP_TYPE_BOOLEAN_NOT = 1,
        };
        
        // fields
        op_type: DerivationExpression.UnaryOp.UnaryOpType = @enumFromInt(0),
        arg: ?DerivationExpression = null,

        pub fn calcProtobufSize(self: *const UnaryOp) usize {
            var res: usize = 0;
            if (@intFromEnum(self.op_type) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.UnaryOpWire.OP_TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.op_type)); }
            if (self.arg) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.UnaryOpWire.ARG_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const UnaryOp, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const UnaryOp, target: *gremlin.Writer) void {
            if (@intFromEnum(self.op_type) != 0) { target.appendInt32(DerivationExpression.UnaryOpWire.OP_TYPE_WIRE, @intFromEnum(self.op_type)); }
            if (self.arg) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.UnaryOpWire.ARG_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const UnaryOpReader = struct {
        _op_type: DerivationExpression.UnaryOp.UnaryOpType = @enumFromInt(0),
        _arg_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!UnaryOpReader {
            var buf = gremlin.Reader.init(src);
            var res = UnaryOpReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.UnaryOpWire.OP_TYPE_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._op_type = @enumFromInt(result.value);
                    },
                    DerivationExpression.UnaryOpWire.ARG_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._arg_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const UnaryOpReader) void { }
        
        pub inline fn getOpType(self: *const UnaryOpReader) DerivationExpression.UnaryOp.UnaryOpType { return self._op_type; }
        pub fn getArg(self: *const UnaryOpReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._arg_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
    };
    
    const BinaryOpWire = struct {
        const OP_TYPE_WIRE: gremlin.ProtoWireNumber = 1;
        const ARG1_WIRE: gremlin.ProtoWireNumber = 2;
        const ARG2_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const BinaryOp = struct {
        // nested enums
        pub const BinaryOpType = enum(i32) {
            BINARY_OP_TYPE_UNSPECIFIED = 0,
            BINARY_OP_TYPE_PLUS = 1,
            BINARY_OP_TYPE_MINUS = 2,
            BINARY_OP_TYPE_MULTIPLY = 3,
            BINARY_OP_TYPE_DIVIDE = 4,
            BINARY_OP_TYPE_MIN = 5,
            BINARY_OP_TYPE_MAX = 6,
            BINARY_OP_TYPE_GREATER_THAN = 7,
            BINARY_OP_TYPE_LESS_THAN = 8,
            BINARY_OP_TYPE_AND = 9,
            BINARY_OP_TYPE_OR = 10,
            BINARY_OP_TYPE_EQUALS = 11,
            BINARY_OP_TYPE_COVERS = 12,
        };
        
        // fields
        op_type: DerivationExpression.BinaryOp.BinaryOpType = @enumFromInt(0),
        arg1: ?DerivationExpression = null,
        arg2: ?DerivationExpression = null,

        pub fn calcProtobufSize(self: *const BinaryOp) usize {
            var res: usize = 0;
            if (@intFromEnum(self.op_type) != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpression.BinaryOpWire.OP_TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.op_type)); }
            if (self.arg1) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.BinaryOpWire.ARG1_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.arg2) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.BinaryOpWire.ARG2_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const BinaryOp, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const BinaryOp, target: *gremlin.Writer) void {
            if (@intFromEnum(self.op_type) != 0) { target.appendInt32(DerivationExpression.BinaryOpWire.OP_TYPE_WIRE, @intFromEnum(self.op_type)); }
            if (self.arg1) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.BinaryOpWire.ARG1_WIRE, size);
                v.encodeTo(target);
            }
            if (self.arg2) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.BinaryOpWire.ARG2_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const BinaryOpReader = struct {
        _op_type: DerivationExpression.BinaryOp.BinaryOpType = @enumFromInt(0),
        _arg1_buf: ?[]const u8 = null,
        _arg2_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!BinaryOpReader {
            var buf = gremlin.Reader.init(src);
            var res = BinaryOpReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.BinaryOpWire.OP_TYPE_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._op_type = @enumFromInt(result.value);
                    },
                    DerivationExpression.BinaryOpWire.ARG1_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._arg1_buf = result.value;
                    },
                    DerivationExpression.BinaryOpWire.ARG2_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._arg2_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const BinaryOpReader) void { }
        
        pub inline fn getOpType(self: *const BinaryOpReader) DerivationExpression.BinaryOp.BinaryOpType { return self._op_type; }
        pub fn getArg1(self: *const BinaryOpReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._arg1_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub fn getArg2(self: *const BinaryOpReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._arg2_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
        }
    };
    
    const ReturnProgramWire = struct {
        const ASSIGNMENTS_WIRE: gremlin.ProtoWireNumber = 1;
        const FINAL_EXPRESSION_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const ReturnProgram = struct {
        // nested structs
        const AssignmentWire = struct {
            const NAME_WIRE: gremlin.ProtoWireNumber = 1;
            const EXPRESSION_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const Assignment = struct {
            // fields
            name: ?[]const u8 = null,
            expression: ?DerivationExpression = null,

            pub fn calcProtobufSize(self: *const Assignment) usize {
                var res: usize = 0;
                if (self.name) |v| { res += gremlin.sizes.sizeWireNumber(DerivationExpression.ReturnProgram.AssignmentWire.NAME_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                if (self.expression) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(DerivationExpression.ReturnProgram.AssignmentWire.EXPRESSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const Assignment, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const Assignment, target: *gremlin.Writer) void {
                if (self.name) |v| { target.appendBytes(DerivationExpression.ReturnProgram.AssignmentWire.NAME_WIRE, v); }
                if (self.expression) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(DerivationExpression.ReturnProgram.AssignmentWire.EXPRESSION_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const AssignmentReader = struct {
            _name: ?[]const u8 = null,
            _expression_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!AssignmentReader {
                var buf = gremlin.Reader.init(src);
                var res = AssignmentReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        DerivationExpression.ReturnProgram.AssignmentWire.NAME_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._name = result.value;
                        },
                        DerivationExpression.ReturnProgram.AssignmentWire.EXPRESSION_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._expression_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const AssignmentReader) void { }
            
            pub inline fn getName(self: *const AssignmentReader) []const u8 { return self._name orelse &[_]u8{}; }
            pub fn getExpression(self: *const AssignmentReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
                if (self._expression_buf) |buf| {
                    return try DerivationExpressionReader.init(allocator, buf);
                }
                return try DerivationExpressionReader.init(allocator, &[_]u8{});
            }
        };
        
        // fields
        assignments: ?[]const ?DerivationExpression.ReturnProgram.Assignment = null,
        final_expression: ?DerivationExpression = null,

        pub fn calcProtobufSize(self: *const ReturnProgram) usize {
            var res: usize = 0;
            if (self.assignments) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(DerivationExpression.ReturnProgramWire.ASSIGNMENTS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.final_expression) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(DerivationExpression.ReturnProgramWire.FINAL_EXPRESSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const ReturnProgram, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ReturnProgram, target: *gremlin.Writer) void {
            if (self.assignments) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(DerivationExpression.ReturnProgramWire.ASSIGNMENTS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(DerivationExpression.ReturnProgramWire.ASSIGNMENTS_WIRE, 0);
                    }
                }
            }
            if (self.final_expression) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(DerivationExpression.ReturnProgramWire.FINAL_EXPRESSION_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const ReturnProgramReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _assignments_bufs: ?std.ArrayList([]const u8) = null,
        _final_expression_buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ReturnProgramReader {
            var buf = gremlin.Reader.init(src);
            var res = ReturnProgramReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    DerivationExpression.ReturnProgramWire.ASSIGNMENTS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._assignments_bufs == null) {
                            res._assignments_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._assignments_bufs.?.append(result.value);
                    },
                    DerivationExpression.ReturnProgramWire.FINAL_EXPRESSION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._final_expression_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const ReturnProgramReader) void {
            if (self._assignments_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getAssignments(self: *const ReturnProgramReader, allocator: std.mem.Allocator) gremlin.Error![]DerivationExpression.ReturnProgram.AssignmentReader {
            if (self._assignments_bufs) |bufs| {
                var result = try std.ArrayList(DerivationExpression.ReturnProgram.AssignmentReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try DerivationExpression.ReturnProgram.AssignmentReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]DerivationExpression.ReturnProgram.AssignmentReader{};
        }
        pub fn getFinalExpression(self: *const ReturnProgramReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpressionReader {
            if (self._final_expression_buf) |buf| {
                return try DerivationExpressionReader.init(allocator, buf);
            }
            return try DerivationExpressionReader.init(allocator, &[_]u8{});
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
    timestamp_tz: ?type.Type.TimestampTZ = null,
    uuid: ?type.Type.UUID = null,
    interval_day: ?DerivationExpression.ExpressionIntervalDay = null,
    interval_compound: ?DerivationExpression.ExpressionIntervalCompound = null,
    fixed_char: ?DerivationExpression.ExpressionFixedChar = null,
    varchar: ?DerivationExpression.ExpressionVarChar = null,
    fixed_binary: ?DerivationExpression.ExpressionFixedBinary = null,
    decimal: ?DerivationExpression.ExpressionDecimal = null,
    precision_timestamp: ?DerivationExpression.ExpressionPrecisionTimestamp = null,
    precision_timestamp_tz: ?DerivationExpression.ExpressionPrecisionTimestampTZ = null,
    struct_: ?DerivationExpression.ExpressionStruct = null,
    list: ?DerivationExpression.ExpressionList = null,
    map: ?DerivationExpression.ExpressionMap = null,
    user_defined: ?DerivationExpression.ExpressionUserDefined = null,
    user_defined_pointer: u32 = 0,
    type_parameter_name: ?[]const u8 = null,
    integer_parameter_name: ?[]const u8 = null,
    integer_literal: i32 = 0,
    unary_op: ?DerivationExpression.UnaryOp = null,
    binary_op: ?DerivationExpression.BinaryOp = null,
    if_else: ?DerivationExpression.IfElse = null,
    return_program: ?DerivationExpression.ReturnProgram = null,

    pub fn calcProtobufSize(self: *const DerivationExpression) usize {
        var res: usize = 0;
        if (self.bool) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.BOOL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i8) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.I8_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i16) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.I16_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i32) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.I32_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i64) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.I64_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fp32) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.FP32_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fp64) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.FP64_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.string) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.STRING_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.binary) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.BINARY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.timestamp) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.TIMESTAMP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.date) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.DATE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.time) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.TIME_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.interval_year) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.INTERVAL_YEAR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.TIMESTAMP_TZ_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.uuid) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.UUID_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.interval_day) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.INTERVAL_DAY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.interval_compound) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.INTERVAL_COMPOUND_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fixed_char) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.FIXED_CHAR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.varchar) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.VARCHAR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fixed_binary) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.FIXED_BINARY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.decimal) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.DECIMAL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.precision_timestamp) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.PRECISION_TIMESTAMP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.precision_timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.PRECISION_TIMESTAMP_TZ_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.struct_) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.STRUCT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.list) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.LIST_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.map) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.MAP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.user_defined) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.USER_DEFINED_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.user_defined_pointer != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.USER_DEFINED_POINTER_WIRE) + gremlin.sizes.sizeU32(self.user_defined_pointer); }
        if (self.type_parameter_name) |v| { res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.TYPE_PARAMETER_NAME_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
        if (self.integer_parameter_name) |v| { res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.INTEGER_PARAMETER_NAME_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
        if (self.integer_literal != 0) { res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.INTEGER_LITERAL_WIRE) + gremlin.sizes.sizeI32(self.integer_literal); }
        if (self.unary_op) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.UNARY_OP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.binary_op) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.BINARY_OP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.if_else) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.IF_ELSE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.return_program) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DerivationExpressionWire.RETURN_PROGRAM_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const DerivationExpression, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const DerivationExpression, target: *gremlin.Writer) void {
        if (self.bool) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.BOOL_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i8) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.I8_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i16) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.I16_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i32) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.I32_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i64) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.I64_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fp32) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.FP32_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fp64) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.FP64_WIRE, size);
            v.encodeTo(target);
        }
        if (self.string) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.STRING_WIRE, size);
            v.encodeTo(target);
        }
        if (self.binary) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.BINARY_WIRE, size);
            v.encodeTo(target);
        }
        if (self.timestamp) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.TIMESTAMP_WIRE, size);
            v.encodeTo(target);
        }
        if (self.date) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.DATE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.time) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.TIME_WIRE, size);
            v.encodeTo(target);
        }
        if (self.interval_year) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.INTERVAL_YEAR_WIRE, size);
            v.encodeTo(target);
        }
        if (self.timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.TIMESTAMP_TZ_WIRE, size);
            v.encodeTo(target);
        }
        if (self.uuid) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.UUID_WIRE, size);
            v.encodeTo(target);
        }
        if (self.interval_day) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.INTERVAL_DAY_WIRE, size);
            v.encodeTo(target);
        }
        if (self.interval_compound) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.INTERVAL_COMPOUND_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fixed_char) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.FIXED_CHAR_WIRE, size);
            v.encodeTo(target);
        }
        if (self.varchar) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.VARCHAR_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fixed_binary) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.FIXED_BINARY_WIRE, size);
            v.encodeTo(target);
        }
        if (self.decimal) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.DECIMAL_WIRE, size);
            v.encodeTo(target);
        }
        if (self.precision_timestamp) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.PRECISION_TIMESTAMP_WIRE, size);
            v.encodeTo(target);
        }
        if (self.precision_timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.PRECISION_TIMESTAMP_TZ_WIRE, size);
            v.encodeTo(target);
        }
        if (self.struct_) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.STRUCT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.list) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.LIST_WIRE, size);
            v.encodeTo(target);
        }
        if (self.map) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.MAP_WIRE, size);
            v.encodeTo(target);
        }
        if (self.user_defined) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.USER_DEFINED_WIRE, size);
            v.encodeTo(target);
        }
        if (self.user_defined_pointer != 0) { target.appendUint32(DerivationExpressionWire.USER_DEFINED_POINTER_WIRE, self.user_defined_pointer); }
        if (self.type_parameter_name) |v| { target.appendBytes(DerivationExpressionWire.TYPE_PARAMETER_NAME_WIRE, v); }
        if (self.integer_parameter_name) |v| { target.appendBytes(DerivationExpressionWire.INTEGER_PARAMETER_NAME_WIRE, v); }
        if (self.integer_literal != 0) { target.appendInt32(DerivationExpressionWire.INTEGER_LITERAL_WIRE, self.integer_literal); }
        if (self.unary_op) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.UNARY_OP_WIRE, size);
            v.encodeTo(target);
        }
        if (self.binary_op) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.BINARY_OP_WIRE, size);
            v.encodeTo(target);
        }
        if (self.if_else) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.IF_ELSE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.return_program) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DerivationExpressionWire.RETURN_PROGRAM_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const DerivationExpressionReader = struct {
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
    _timestamp_tz_buf: ?[]const u8 = null,
    _uuid_buf: ?[]const u8 = null,
    _interval_day_buf: ?[]const u8 = null,
    _interval_compound_buf: ?[]const u8 = null,
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
    _type_parameter_name: ?[]const u8 = null,
    _integer_parameter_name: ?[]const u8 = null,
    _integer_literal: i32 = 0,
    _unary_op_buf: ?[]const u8 = null,
    _binary_op_buf: ?[]const u8 = null,
    _if_else_buf: ?[]const u8 = null,
    _return_program_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!DerivationExpressionReader {
        var buf = gremlin.Reader.init(src);
        var res = DerivationExpressionReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                DerivationExpressionWire.BOOL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._bool_buf = result.value;
                },
                DerivationExpressionWire.I8_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i8_buf = result.value;
                },
                DerivationExpressionWire.I16_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i16_buf = result.value;
                },
                DerivationExpressionWire.I32_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i32_buf = result.value;
                },
                DerivationExpressionWire.I64_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i64_buf = result.value;
                },
                DerivationExpressionWire.FP32_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fp32_buf = result.value;
                },
                DerivationExpressionWire.FP64_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fp64_buf = result.value;
                },
                DerivationExpressionWire.STRING_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._string_buf = result.value;
                },
                DerivationExpressionWire.BINARY_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._binary_buf = result.value;
                },
                DerivationExpressionWire.TIMESTAMP_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._timestamp_buf = result.value;
                },
                DerivationExpressionWire.DATE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._date_buf = result.value;
                },
                DerivationExpressionWire.TIME_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._time_buf = result.value;
                },
                DerivationExpressionWire.INTERVAL_YEAR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._interval_year_buf = result.value;
                },
                DerivationExpressionWire.TIMESTAMP_TZ_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._timestamp_tz_buf = result.value;
                },
                DerivationExpressionWire.UUID_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._uuid_buf = result.value;
                },
                DerivationExpressionWire.INTERVAL_DAY_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._interval_day_buf = result.value;
                },
                DerivationExpressionWire.INTERVAL_COMPOUND_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._interval_compound_buf = result.value;
                },
                DerivationExpressionWire.FIXED_CHAR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fixed_char_buf = result.value;
                },
                DerivationExpressionWire.VARCHAR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._varchar_buf = result.value;
                },
                DerivationExpressionWire.FIXED_BINARY_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fixed_binary_buf = result.value;
                },
                DerivationExpressionWire.DECIMAL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._decimal_buf = result.value;
                },
                DerivationExpressionWire.PRECISION_TIMESTAMP_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._precision_timestamp_buf = result.value;
                },
                DerivationExpressionWire.PRECISION_TIMESTAMP_TZ_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._precision_timestamp_tz_buf = result.value;
                },
                DerivationExpressionWire.STRUCT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._struct__buf = result.value;
                },
                DerivationExpressionWire.LIST_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._list_buf = result.value;
                },
                DerivationExpressionWire.MAP_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._map_buf = result.value;
                },
                DerivationExpressionWire.USER_DEFINED_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._user_defined_buf = result.value;
                },
                DerivationExpressionWire.USER_DEFINED_POINTER_WIRE => {
                  const result = try buf.readUInt32(offset);
                  offset += result.size;
                  res._user_defined_pointer = result.value;
                },
                DerivationExpressionWire.TYPE_PARAMETER_NAME_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._type_parameter_name = result.value;
                },
                DerivationExpressionWire.INTEGER_PARAMETER_NAME_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._integer_parameter_name = result.value;
                },
                DerivationExpressionWire.INTEGER_LITERAL_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._integer_literal = result.value;
                },
                DerivationExpressionWire.UNARY_OP_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._unary_op_buf = result.value;
                },
                DerivationExpressionWire.BINARY_OP_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._binary_op_buf = result.value;
                },
                DerivationExpressionWire.IF_ELSE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._if_else_buf = result.value;
                },
                DerivationExpressionWire.RETURN_PROGRAM_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._return_program_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const DerivationExpressionReader) void { }
    
    pub fn getBool(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.BooleanReader {
        if (self._bool_buf) |buf| {
            return try type.Type.BooleanReader.init(allocator, buf);
        }
        return try type.Type.BooleanReader.init(allocator, &[_]u8{});
    }
    pub fn getI8(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.I8Reader {
        if (self._i8_buf) |buf| {
            return try type.Type.I8Reader.init(allocator, buf);
        }
        return try type.Type.I8Reader.init(allocator, &[_]u8{});
    }
    pub fn getI16(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.I16Reader {
        if (self._i16_buf) |buf| {
            return try type.Type.I16Reader.init(allocator, buf);
        }
        return try type.Type.I16Reader.init(allocator, &[_]u8{});
    }
    pub fn getI32(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.I32Reader {
        if (self._i32_buf) |buf| {
            return try type.Type.I32Reader.init(allocator, buf);
        }
        return try type.Type.I32Reader.init(allocator, &[_]u8{});
    }
    pub fn getI64(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.I64Reader {
        if (self._i64_buf) |buf| {
            return try type.Type.I64Reader.init(allocator, buf);
        }
        return try type.Type.I64Reader.init(allocator, &[_]u8{});
    }
    pub fn getFp32(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.FP32Reader {
        if (self._fp32_buf) |buf| {
            return try type.Type.FP32Reader.init(allocator, buf);
        }
        return try type.Type.FP32Reader.init(allocator, &[_]u8{});
    }
    pub fn getFp64(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.FP64Reader {
        if (self._fp64_buf) |buf| {
            return try type.Type.FP64Reader.init(allocator, buf);
        }
        return try type.Type.FP64Reader.init(allocator, &[_]u8{});
    }
    pub fn getString(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.StringReader {
        if (self._string_buf) |buf| {
            return try type.Type.StringReader.init(allocator, buf);
        }
        return try type.Type.StringReader.init(allocator, &[_]u8{});
    }
    pub fn getBinary(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.BinaryReader {
        if (self._binary_buf) |buf| {
            return try type.Type.BinaryReader.init(allocator, buf);
        }
        return try type.Type.BinaryReader.init(allocator, &[_]u8{});
    }
    pub fn getTimestamp(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.TimestampReader {
        if (self._timestamp_buf) |buf| {
            return try type.Type.TimestampReader.init(allocator, buf);
        }
        return try type.Type.TimestampReader.init(allocator, &[_]u8{});
    }
    pub fn getDate(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.DateReader {
        if (self._date_buf) |buf| {
            return try type.Type.DateReader.init(allocator, buf);
        }
        return try type.Type.DateReader.init(allocator, &[_]u8{});
    }
    pub fn getTime(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.TimeReader {
        if (self._time_buf) |buf| {
            return try type.Type.TimeReader.init(allocator, buf);
        }
        return try type.Type.TimeReader.init(allocator, &[_]u8{});
    }
    pub fn getIntervalYear(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.IntervalYearReader {
        if (self._interval_year_buf) |buf| {
            return try type.Type.IntervalYearReader.init(allocator, buf);
        }
        return try type.Type.IntervalYearReader.init(allocator, &[_]u8{});
    }
    pub fn getTimestampTz(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.TimestampTZReader {
        if (self._timestamp_tz_buf) |buf| {
            return try type.Type.TimestampTZReader.init(allocator, buf);
        }
        return try type.Type.TimestampTZReader.init(allocator, &[_]u8{});
    }
    pub fn getUuid(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.UUIDReader {
        if (self._uuid_buf) |buf| {
            return try type.Type.UUIDReader.init(allocator, buf);
        }
        return try type.Type.UUIDReader.init(allocator, &[_]u8{});
    }
    pub fn getIntervalDay(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionIntervalDayReader {
        if (self._interval_day_buf) |buf| {
            return try DerivationExpression.ExpressionIntervalDayReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionIntervalDayReader.init(allocator, &[_]u8{});
    }
    pub fn getIntervalCompound(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionIntervalCompoundReader {
        if (self._interval_compound_buf) |buf| {
            return try DerivationExpression.ExpressionIntervalCompoundReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionIntervalCompoundReader.init(allocator, &[_]u8{});
    }
    pub fn getFixedChar(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionFixedCharReader {
        if (self._fixed_char_buf) |buf| {
            return try DerivationExpression.ExpressionFixedCharReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionFixedCharReader.init(allocator, &[_]u8{});
    }
    pub fn getVarchar(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionVarCharReader {
        if (self._varchar_buf) |buf| {
            return try DerivationExpression.ExpressionVarCharReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionVarCharReader.init(allocator, &[_]u8{});
    }
    pub fn getFixedBinary(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionFixedBinaryReader {
        if (self._fixed_binary_buf) |buf| {
            return try DerivationExpression.ExpressionFixedBinaryReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionFixedBinaryReader.init(allocator, &[_]u8{});
    }
    pub fn getDecimal(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionDecimalReader {
        if (self._decimal_buf) |buf| {
            return try DerivationExpression.ExpressionDecimalReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionDecimalReader.init(allocator, &[_]u8{});
    }
    pub fn getPrecisionTimestamp(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionPrecisionTimestampReader {
        if (self._precision_timestamp_buf) |buf| {
            return try DerivationExpression.ExpressionPrecisionTimestampReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionPrecisionTimestampReader.init(allocator, &[_]u8{});
    }
    pub fn getPrecisionTimestampTz(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionPrecisionTimestampTZReader {
        if (self._precision_timestamp_tz_buf) |buf| {
            return try DerivationExpression.ExpressionPrecisionTimestampTZReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionPrecisionTimestampTZReader.init(allocator, &[_]u8{});
    }
    pub fn getStruct(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionStructReader {
        if (self._struct__buf) |buf| {
            return try DerivationExpression.ExpressionStructReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionStructReader.init(allocator, &[_]u8{});
    }
    pub fn getList(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionListReader {
        if (self._list_buf) |buf| {
            return try DerivationExpression.ExpressionListReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionListReader.init(allocator, &[_]u8{});
    }
    pub fn getMap(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionMapReader {
        if (self._map_buf) |buf| {
            return try DerivationExpression.ExpressionMapReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionMapReader.init(allocator, &[_]u8{});
    }
    pub fn getUserDefined(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ExpressionUserDefinedReader {
        if (self._user_defined_buf) |buf| {
            return try DerivationExpression.ExpressionUserDefinedReader.init(allocator, buf);
        }
        return try DerivationExpression.ExpressionUserDefinedReader.init(allocator, &[_]u8{});
    }
    pub inline fn getUserDefinedPointer(self: *const DerivationExpressionReader) u32 { return self._user_defined_pointer; }
    pub inline fn getTypeParameterName(self: *const DerivationExpressionReader) []const u8 { return self._type_parameter_name orelse &[_]u8{}; }
    pub inline fn getIntegerParameterName(self: *const DerivationExpressionReader) []const u8 { return self._integer_parameter_name orelse &[_]u8{}; }
    pub inline fn getIntegerLiteral(self: *const DerivationExpressionReader) i32 { return self._integer_literal; }
    pub fn getUnaryOp(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.UnaryOpReader {
        if (self._unary_op_buf) |buf| {
            return try DerivationExpression.UnaryOpReader.init(allocator, buf);
        }
        return try DerivationExpression.UnaryOpReader.init(allocator, &[_]u8{});
    }
    pub fn getBinaryOp(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.BinaryOpReader {
        if (self._binary_op_buf) |buf| {
            return try DerivationExpression.BinaryOpReader.init(allocator, buf);
        }
        return try DerivationExpression.BinaryOpReader.init(allocator, &[_]u8{});
    }
    pub fn getIfElse(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.IfElseReader {
        if (self._if_else_buf) |buf| {
            return try DerivationExpression.IfElseReader.init(allocator, buf);
        }
        return try DerivationExpression.IfElseReader.init(allocator, &[_]u8{});
    }
    pub fn getReturnProgram(self: *const DerivationExpressionReader, allocator: std.mem.Allocator) gremlin.Error!DerivationExpression.ReturnProgramReader {
        if (self._return_program_buf) |buf| {
            return try DerivationExpression.ReturnProgramReader.init(allocator, buf);
        }
        return try DerivationExpression.ReturnProgramReader.init(allocator, &[_]u8{});
    }
};

