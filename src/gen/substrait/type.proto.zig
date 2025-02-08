const std = @import("std");
const gremlin = @import("gremlin");
const empty = @import("src/gen/google/protobuf/empty.proto.zig");

// structs
const TypeWire = struct {
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
    const INTERVAL_COMPOUND_WIRE: gremlin.ProtoWireNumber = 35;
    const TIMESTAMP_TZ_WIRE: gremlin.ProtoWireNumber = 29;
    const UUID_WIRE: gremlin.ProtoWireNumber = 32;
    const FIXED_CHAR_WIRE: gremlin.ProtoWireNumber = 21;
    const VARCHAR_WIRE: gremlin.ProtoWireNumber = 22;
    const FIXED_BINARY_WIRE: gremlin.ProtoWireNumber = 23;
    const DECIMAL_WIRE: gremlin.ProtoWireNumber = 24;
    const PRECISION_TIMESTAMP_WIRE: gremlin.ProtoWireNumber = 33;
    const PRECISION_TIMESTAMP_TZ_WIRE: gremlin.ProtoWireNumber = 34;
    const STRUCT_WIRE: gremlin.ProtoWireNumber = 25;
    const LIST_WIRE: gremlin.ProtoWireNumber = 27;
    const MAP_WIRE: gremlin.ProtoWireNumber = 28;
    const USER_DEFINED_WIRE: gremlin.ProtoWireNumber = 30;
    const USER_DEFINED_TYPE_REFERENCE_WIRE: gremlin.ProtoWireNumber = 31;
};

pub const Type = struct {
    // nested enums
    pub const Nullability = enum(i32) {
        NULLABILITY_UNSPECIFIED = 0,
        NULLABILITY_NULLABLE = 1,
        NULLABILITY_REQUIRED = 2,
    };
    
    // nested structs
    const BooleanWire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const Boolean = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const Boolean) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.BooleanWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.BooleanWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const Boolean, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Boolean, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.BooleanWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.BooleanWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const BooleanReader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!BooleanReader {
            var buf = gremlin.Reader.init(src);
            var res = BooleanReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.BooleanWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.BooleanWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const BooleanReader) void { }
        
        pub inline fn getTypeVariationReference(self: *const BooleanReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const BooleanReader) Type.Nullability { return self._nullability; }
    };
    
    const I8Wire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const I8 = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const I8) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.I8Wire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.I8Wire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const I8, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const I8, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.I8Wire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.I8Wire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const I8Reader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!I8Reader {
            var buf = gremlin.Reader.init(src);
            var res = I8Reader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.I8Wire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.I8Wire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const I8Reader) void { }
        
        pub inline fn getTypeVariationReference(self: *const I8Reader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const I8Reader) Type.Nullability { return self._nullability; }
    };
    
    const I16Wire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const I16 = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const I16) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.I16Wire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.I16Wire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const I16, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const I16, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.I16Wire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.I16Wire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const I16Reader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!I16Reader {
            var buf = gremlin.Reader.init(src);
            var res = I16Reader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.I16Wire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.I16Wire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const I16Reader) void { }
        
        pub inline fn getTypeVariationReference(self: *const I16Reader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const I16Reader) Type.Nullability { return self._nullability; }
    };
    
    const I32Wire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const I32 = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const I32) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.I32Wire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.I32Wire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const I32, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const I32, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.I32Wire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.I32Wire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const I32Reader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!I32Reader {
            var buf = gremlin.Reader.init(src);
            var res = I32Reader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.I32Wire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.I32Wire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const I32Reader) void { }
        
        pub inline fn getTypeVariationReference(self: *const I32Reader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const I32Reader) Type.Nullability { return self._nullability; }
    };
    
    const I64Wire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const I64 = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const I64) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.I64Wire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.I64Wire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const I64, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const I64, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.I64Wire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.I64Wire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const I64Reader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!I64Reader {
            var buf = gremlin.Reader.init(src);
            var res = I64Reader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.I64Wire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.I64Wire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const I64Reader) void { }
        
        pub inline fn getTypeVariationReference(self: *const I64Reader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const I64Reader) Type.Nullability { return self._nullability; }
    };
    
    const FP32Wire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const FP32 = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const FP32) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.FP32Wire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.FP32Wire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const FP32, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const FP32, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.FP32Wire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.FP32Wire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const FP32Reader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!FP32Reader {
            var buf = gremlin.Reader.init(src);
            var res = FP32Reader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.FP32Wire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.FP32Wire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const FP32Reader) void { }
        
        pub inline fn getTypeVariationReference(self: *const FP32Reader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const FP32Reader) Type.Nullability { return self._nullability; }
    };
    
    const FP64Wire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const FP64 = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const FP64) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.FP64Wire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.FP64Wire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const FP64, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const FP64, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.FP64Wire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.FP64Wire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const FP64Reader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!FP64Reader {
            var buf = gremlin.Reader.init(src);
            var res = FP64Reader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.FP64Wire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.FP64Wire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const FP64Reader) void { }
        
        pub inline fn getTypeVariationReference(self: *const FP64Reader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const FP64Reader) Type.Nullability { return self._nullability; }
    };
    
    const StringWire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const String = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const String) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.StringWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.StringWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const String, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const String, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.StringWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.StringWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const StringReader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!StringReader {
            var buf = gremlin.Reader.init(src);
            var res = StringReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.StringWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.StringWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const StringReader) void { }
        
        pub inline fn getTypeVariationReference(self: *const StringReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const StringReader) Type.Nullability { return self._nullability; }
    };
    
    const BinaryWire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const Binary = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const Binary) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.BinaryWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.BinaryWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const Binary, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Binary, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.BinaryWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.BinaryWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const BinaryReader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!BinaryReader {
            var buf = gremlin.Reader.init(src);
            var res = BinaryReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.BinaryWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.BinaryWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const BinaryReader) void { }
        
        pub inline fn getTypeVariationReference(self: *const BinaryReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const BinaryReader) Type.Nullability { return self._nullability; }
    };
    
    const TimestampWire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const Timestamp = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const Timestamp) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.TimestampWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.TimestampWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const Timestamp, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Timestamp, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.TimestampWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.TimestampWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const TimestampReader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!TimestampReader {
            var buf = gremlin.Reader.init(src);
            var res = TimestampReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.TimestampWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.TimestampWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const TimestampReader) void { }
        
        pub inline fn getTypeVariationReference(self: *const TimestampReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const TimestampReader) Type.Nullability { return self._nullability; }
    };
    
    const DateWire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const Date = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const Date) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.DateWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.DateWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const Date, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Date, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.DateWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.DateWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const DateReader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!DateReader {
            var buf = gremlin.Reader.init(src);
            var res = DateReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.DateWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.DateWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const DateReader) void { }
        
        pub inline fn getTypeVariationReference(self: *const DateReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const DateReader) Type.Nullability { return self._nullability; }
    };
    
    const TimeWire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const Time = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const Time) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.TimeWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.TimeWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const Time, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Time, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.TimeWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.TimeWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const TimeReader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!TimeReader {
            var buf = gremlin.Reader.init(src);
            var res = TimeReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.TimeWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.TimeWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const TimeReader) void { }
        
        pub inline fn getTypeVariationReference(self: *const TimeReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const TimeReader) Type.Nullability { return self._nullability; }
    };
    
    const TimestampTZWire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const TimestampTZ = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const TimestampTZ) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.TimestampTZWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.TimestampTZWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const TimestampTZ, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const TimestampTZ, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.TimestampTZWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.TimestampTZWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const TimestampTZReader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!TimestampTZReader {
            var buf = gremlin.Reader.init(src);
            var res = TimestampTZReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.TimestampTZWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.TimestampTZWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const TimestampTZReader) void { }
        
        pub inline fn getTypeVariationReference(self: *const TimestampTZReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const TimestampTZReader) Type.Nullability { return self._nullability; }
    };
    
    const IntervalYearWire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const IntervalYear = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const IntervalYear) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.IntervalYearWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.IntervalYearWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const IntervalYear, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const IntervalYear, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.IntervalYearWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.IntervalYearWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const IntervalYearReader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!IntervalYearReader {
            var buf = gremlin.Reader.init(src);
            var res = IntervalYearReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.IntervalYearWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.IntervalYearWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const IntervalYearReader) void { }
        
        pub inline fn getTypeVariationReference(self: *const IntervalYearReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const IntervalYearReader) Type.Nullability { return self._nullability; }
    };
    
    const IntervalDayWire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const IntervalDay = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),
        precision: i32 = 0,

        pub fn calcProtobufSize(self: *const IntervalDay) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.IntervalDayWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.IntervalDayWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            if (self.precision != 0) { res += gremlin.sizes.sizeWireNumber(Type.IntervalDayWire.PRECISION_WIRE) + gremlin.sizes.sizeI32(self.precision); }
            return res;
        }

        pub fn encode(self: *const IntervalDay, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const IntervalDay, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.IntervalDayWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.IntervalDayWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
            if (self.precision != 0) { target.appendInt32(Type.IntervalDayWire.PRECISION_WIRE, self.precision); }
        }
    };
    
    pub const IntervalDayReader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),
        _precision: i32 = 0,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!IntervalDayReader {
            var buf = gremlin.Reader.init(src);
            var res = IntervalDayReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.IntervalDayWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.IntervalDayWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    Type.IntervalDayWire.PRECISION_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._precision = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const IntervalDayReader) void { }
        
        pub inline fn getTypeVariationReference(self: *const IntervalDayReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const IntervalDayReader) Type.Nullability { return self._nullability; }
        pub inline fn getPrecision(self: *const IntervalDayReader) i32 { return self._precision; }
    };
    
    const IntervalCompoundWire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const IntervalCompound = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),
        precision: i32 = 0,

        pub fn calcProtobufSize(self: *const IntervalCompound) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.IntervalCompoundWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.IntervalCompoundWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            if (self.precision != 0) { res += gremlin.sizes.sizeWireNumber(Type.IntervalCompoundWire.PRECISION_WIRE) + gremlin.sizes.sizeI32(self.precision); }
            return res;
        }

        pub fn encode(self: *const IntervalCompound, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const IntervalCompound, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.IntervalCompoundWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.IntervalCompoundWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
            if (self.precision != 0) { target.appendInt32(Type.IntervalCompoundWire.PRECISION_WIRE, self.precision); }
        }
    };
    
    pub const IntervalCompoundReader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),
        _precision: i32 = 0,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!IntervalCompoundReader {
            var buf = gremlin.Reader.init(src);
            var res = IntervalCompoundReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.IntervalCompoundWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.IntervalCompoundWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    Type.IntervalCompoundWire.PRECISION_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._precision = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const IntervalCompoundReader) void { }
        
        pub inline fn getTypeVariationReference(self: *const IntervalCompoundReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const IntervalCompoundReader) Type.Nullability { return self._nullability; }
        pub inline fn getPrecision(self: *const IntervalCompoundReader) i32 { return self._precision; }
    };
    
    const UUIDWire = struct {
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const UUID = struct {
        // fields
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const UUID) usize {
            var res: usize = 0;
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.UUIDWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.UUIDWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const UUID, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const UUID, target: *gremlin.Writer) void {
            if (self.type_variation_reference != 0) { target.appendUint32(Type.UUIDWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.UUIDWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const UUIDReader = struct {
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!UUIDReader {
            var buf = gremlin.Reader.init(src);
            var res = UUIDReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.UUIDWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.UUIDWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const UUIDReader) void { }
        
        pub inline fn getTypeVariationReference(self: *const UUIDReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const UUIDReader) Type.Nullability { return self._nullability; }
    };
    
    const FixedCharWire = struct {
        const LENGTH_WIRE: gremlin.ProtoWireNumber = 1;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const FixedChar = struct {
        // fields
        length: i32 = 0,
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const FixedChar) usize {
            var res: usize = 0;
            if (self.length != 0) { res += gremlin.sizes.sizeWireNumber(Type.FixedCharWire.LENGTH_WIRE) + gremlin.sizes.sizeI32(self.length); }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.FixedCharWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.FixedCharWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const FixedChar, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const FixedChar, target: *gremlin.Writer) void {
            if (self.length != 0) { target.appendInt32(Type.FixedCharWire.LENGTH_WIRE, self.length); }
            if (self.type_variation_reference != 0) { target.appendUint32(Type.FixedCharWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.FixedCharWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const FixedCharReader = struct {
        _length: i32 = 0,
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!FixedCharReader {
            var buf = gremlin.Reader.init(src);
            var res = FixedCharReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.FixedCharWire.LENGTH_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._length = result.value;
                    },
                    Type.FixedCharWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.FixedCharWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const FixedCharReader) void { }
        
        pub inline fn getLength(self: *const FixedCharReader) i32 { return self._length; }
        pub inline fn getTypeVariationReference(self: *const FixedCharReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const FixedCharReader) Type.Nullability { return self._nullability; }
    };
    
    const VarCharWire = struct {
        const LENGTH_WIRE: gremlin.ProtoWireNumber = 1;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const VarChar = struct {
        // fields
        length: i32 = 0,
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const VarChar) usize {
            var res: usize = 0;
            if (self.length != 0) { res += gremlin.sizes.sizeWireNumber(Type.VarCharWire.LENGTH_WIRE) + gremlin.sizes.sizeI32(self.length); }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.VarCharWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.VarCharWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const VarChar, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const VarChar, target: *gremlin.Writer) void {
            if (self.length != 0) { target.appendInt32(Type.VarCharWire.LENGTH_WIRE, self.length); }
            if (self.type_variation_reference != 0) { target.appendUint32(Type.VarCharWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.VarCharWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const VarCharReader = struct {
        _length: i32 = 0,
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!VarCharReader {
            var buf = gremlin.Reader.init(src);
            var res = VarCharReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.VarCharWire.LENGTH_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._length = result.value;
                    },
                    Type.VarCharWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.VarCharWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const VarCharReader) void { }
        
        pub inline fn getLength(self: *const VarCharReader) i32 { return self._length; }
        pub inline fn getTypeVariationReference(self: *const VarCharReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const VarCharReader) Type.Nullability { return self._nullability; }
    };
    
    const FixedBinaryWire = struct {
        const LENGTH_WIRE: gremlin.ProtoWireNumber = 1;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const FixedBinary = struct {
        // fields
        length: i32 = 0,
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const FixedBinary) usize {
            var res: usize = 0;
            if (self.length != 0) { res += gremlin.sizes.sizeWireNumber(Type.FixedBinaryWire.LENGTH_WIRE) + gremlin.sizes.sizeI32(self.length); }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.FixedBinaryWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.FixedBinaryWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const FixedBinary, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const FixedBinary, target: *gremlin.Writer) void {
            if (self.length != 0) { target.appendInt32(Type.FixedBinaryWire.LENGTH_WIRE, self.length); }
            if (self.type_variation_reference != 0) { target.appendUint32(Type.FixedBinaryWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.FixedBinaryWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const FixedBinaryReader = struct {
        _length: i32 = 0,
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!FixedBinaryReader {
            var buf = gremlin.Reader.init(src);
            var res = FixedBinaryReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.FixedBinaryWire.LENGTH_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._length = result.value;
                    },
                    Type.FixedBinaryWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.FixedBinaryWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const FixedBinaryReader) void { }
        
        pub inline fn getLength(self: *const FixedBinaryReader) i32 { return self._length; }
        pub inline fn getTypeVariationReference(self: *const FixedBinaryReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const FixedBinaryReader) Type.Nullability { return self._nullability; }
    };
    
    const DecimalWire = struct {
        const SCALE_WIRE: gremlin.ProtoWireNumber = 1;
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 2;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 3;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 4;
    };
    
    pub const Decimal = struct {
        // fields
        scale: i32 = 0,
        precision: i32 = 0,
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const Decimal) usize {
            var res: usize = 0;
            if (self.scale != 0) { res += gremlin.sizes.sizeWireNumber(Type.DecimalWire.SCALE_WIRE) + gremlin.sizes.sizeI32(self.scale); }
            if (self.precision != 0) { res += gremlin.sizes.sizeWireNumber(Type.DecimalWire.PRECISION_WIRE) + gremlin.sizes.sizeI32(self.precision); }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.DecimalWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.DecimalWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const Decimal, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Decimal, target: *gremlin.Writer) void {
            if (self.scale != 0) { target.appendInt32(Type.DecimalWire.SCALE_WIRE, self.scale); }
            if (self.precision != 0) { target.appendInt32(Type.DecimalWire.PRECISION_WIRE, self.precision); }
            if (self.type_variation_reference != 0) { target.appendUint32(Type.DecimalWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.DecimalWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const DecimalReader = struct {
        _scale: i32 = 0,
        _precision: i32 = 0,
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!DecimalReader {
            var buf = gremlin.Reader.init(src);
            var res = DecimalReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.DecimalWire.SCALE_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._scale = result.value;
                    },
                    Type.DecimalWire.PRECISION_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._precision = result.value;
                    },
                    Type.DecimalWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.DecimalWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const DecimalReader) void { }
        
        pub inline fn getScale(self: *const DecimalReader) i32 { return self._scale; }
        pub inline fn getPrecision(self: *const DecimalReader) i32 { return self._precision; }
        pub inline fn getTypeVariationReference(self: *const DecimalReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const DecimalReader) Type.Nullability { return self._nullability; }
    };
    
    const PrecisionTimestampWire = struct {
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 1;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const PrecisionTimestamp = struct {
        // fields
        precision: i32 = 0,
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const PrecisionTimestamp) usize {
            var res: usize = 0;
            if (self.precision != 0) { res += gremlin.sizes.sizeWireNumber(Type.PrecisionTimestampWire.PRECISION_WIRE) + gremlin.sizes.sizeI32(self.precision); }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.PrecisionTimestampWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.PrecisionTimestampWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const PrecisionTimestamp, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const PrecisionTimestamp, target: *gremlin.Writer) void {
            if (self.precision != 0) { target.appendInt32(Type.PrecisionTimestampWire.PRECISION_WIRE, self.precision); }
            if (self.type_variation_reference != 0) { target.appendUint32(Type.PrecisionTimestampWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.PrecisionTimestampWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const PrecisionTimestampReader = struct {
        _precision: i32 = 0,
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!PrecisionTimestampReader {
            var buf = gremlin.Reader.init(src);
            var res = PrecisionTimestampReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.PrecisionTimestampWire.PRECISION_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._precision = result.value;
                    },
                    Type.PrecisionTimestampWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.PrecisionTimestampWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const PrecisionTimestampReader) void { }
        
        pub inline fn getPrecision(self: *const PrecisionTimestampReader) i32 { return self._precision; }
        pub inline fn getTypeVariationReference(self: *const PrecisionTimestampReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const PrecisionTimestampReader) Type.Nullability { return self._nullability; }
    };
    
    const PrecisionTimestampTZWire = struct {
        const PRECISION_WIRE: gremlin.ProtoWireNumber = 1;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const PrecisionTimestampTZ = struct {
        // fields
        precision: i32 = 0,
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const PrecisionTimestampTZ) usize {
            var res: usize = 0;
            if (self.precision != 0) { res += gremlin.sizes.sizeWireNumber(Type.PrecisionTimestampTZWire.PRECISION_WIRE) + gremlin.sizes.sizeI32(self.precision); }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.PrecisionTimestampTZWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.PrecisionTimestampTZWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const PrecisionTimestampTZ, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const PrecisionTimestampTZ, target: *gremlin.Writer) void {
            if (self.precision != 0) { target.appendInt32(Type.PrecisionTimestampTZWire.PRECISION_WIRE, self.precision); }
            if (self.type_variation_reference != 0) { target.appendUint32(Type.PrecisionTimestampTZWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.PrecisionTimestampTZWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const PrecisionTimestampTZReader = struct {
        _precision: i32 = 0,
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!PrecisionTimestampTZReader {
            var buf = gremlin.Reader.init(src);
            var res = PrecisionTimestampTZReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.PrecisionTimestampTZWire.PRECISION_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._precision = result.value;
                    },
                    Type.PrecisionTimestampTZWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.PrecisionTimestampTZWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const PrecisionTimestampTZReader) void { }
        
        pub inline fn getPrecision(self: *const PrecisionTimestampTZReader) i32 { return self._precision; }
        pub inline fn getTypeVariationReference(self: *const PrecisionTimestampTZReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const PrecisionTimestampTZReader) Type.Nullability { return self._nullability; }
    };
    
    const StructWire = struct {
        const TYPES_WIRE: gremlin.ProtoWireNumber = 1;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const Struct = struct {
        // fields
        types: ?[]const ?Type = null,
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const Struct) usize {
            var res: usize = 0;
            if (self.types) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Type.StructWire.TYPES_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.StructWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.StructWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const Struct, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Struct, target: *gremlin.Writer) void {
            if (self.types) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Type.StructWire.TYPES_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Type.StructWire.TYPES_WIRE, 0);
                    }
                }
            }
            if (self.type_variation_reference != 0) { target.appendUint32(Type.StructWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.StructWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const StructReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _types_bufs: ?std.ArrayList([]const u8) = null,
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!StructReader {
            var buf = gremlin.Reader.init(src);
            var res = StructReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.StructWire.TYPES_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._types_bufs == null) {
                            res._types_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._types_bufs.?.append(result.value);
                    },
                    Type.StructWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.StructWire.NULLABILITY_WIRE => {
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
        pub fn deinit(self: *const StructReader) void {
            if (self._types_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getTypes(self: *const StructReader, allocator: std.mem.Allocator) gremlin.Error![]TypeReader {
            if (self._types_bufs) |bufs| {
                var result = try std.ArrayList(TypeReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try TypeReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]TypeReader{};
        }
        pub inline fn getTypeVariationReference(self: *const StructReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const StructReader) Type.Nullability { return self._nullability; }
    };
    
    const ListWire = struct {
        const TYPE_WIRE: gremlin.ProtoWireNumber = 1;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const List = struct {
        // fields
        type: ?Type = null,
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const List) usize {
            var res: usize = 0;
            if (self.type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Type.ListWire.TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.ListWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.ListWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const List, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const List, target: *gremlin.Writer) void {
            if (self.type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Type.ListWire.TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.type_variation_reference != 0) { target.appendUint32(Type.ListWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.ListWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const ListReader = struct {
        _type_buf: ?[]const u8 = null,
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ListReader {
            var buf = gremlin.Reader.init(src);
            var res = ListReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.ListWire.TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._type_buf = result.value;
                    },
                    Type.ListWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.ListWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const ListReader) void { }
        
        pub fn getType(self: *const ListReader, allocator: std.mem.Allocator) gremlin.Error!TypeReader {
            if (self._type_buf) |buf| {
                return try TypeReader.init(allocator, buf);
            }
            return try TypeReader.init(allocator, &[_]u8{});
        }
        pub inline fn getTypeVariationReference(self: *const ListReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const ListReader) Type.Nullability { return self._nullability; }
    };
    
    const MapWire = struct {
        const KEY_WIRE: gremlin.ProtoWireNumber = 1;
        const VALUE_WIRE: gremlin.ProtoWireNumber = 2;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 3;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 4;
    };
    
    pub const Map = struct {
        // fields
        key: ?Type = null,
        value: ?Type = null,
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const Map) usize {
            var res: usize = 0;
            if (self.key) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Type.MapWire.KEY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.value) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Type.MapWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.MapWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.MapWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            return res;
        }

        pub fn encode(self: *const Map, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Map, target: *gremlin.Writer) void {
            if (self.key) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Type.MapWire.KEY_WIRE, size);
                v.encodeTo(target);
            }
            if (self.value) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Type.MapWire.VALUE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.type_variation_reference != 0) { target.appendUint32(Type.MapWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.MapWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
        }
    };
    
    pub const MapReader = struct {
        _key_buf: ?[]const u8 = null,
        _value_buf: ?[]const u8 = null,
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!MapReader {
            var buf = gremlin.Reader.init(src);
            var res = MapReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.MapWire.KEY_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._key_buf = result.value;
                    },
                    Type.MapWire.VALUE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._value_buf = result.value;
                    },
                    Type.MapWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.MapWire.NULLABILITY_WIRE => {
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
        pub fn deinit(_: *const MapReader) void { }
        
        pub fn getKey(self: *const MapReader, allocator: std.mem.Allocator) gremlin.Error!TypeReader {
            if (self._key_buf) |buf| {
                return try TypeReader.init(allocator, buf);
            }
            return try TypeReader.init(allocator, &[_]u8{});
        }
        pub fn getValue(self: *const MapReader, allocator: std.mem.Allocator) gremlin.Error!TypeReader {
            if (self._value_buf) |buf| {
                return try TypeReader.init(allocator, buf);
            }
            return try TypeReader.init(allocator, &[_]u8{});
        }
        pub inline fn getTypeVariationReference(self: *const MapReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const MapReader) Type.Nullability { return self._nullability; }
    };
    
    const UserDefinedWire = struct {
        const TYPE_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
        const NULLABILITY_WIRE: gremlin.ProtoWireNumber = 3;
        const TYPE_PARAMETERS_WIRE: gremlin.ProtoWireNumber = 4;
    };
    
    pub const UserDefined = struct {
        // fields
        type_reference: u32 = 0,
        type_variation_reference: u32 = 0,
        nullability: Type.Nullability = @enumFromInt(0),
        type_parameters: ?[]const ?Type.Parameter = null,

        pub fn calcProtobufSize(self: *const UserDefined) usize {
            var res: usize = 0;
            if (self.type_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.UserDefinedWire.TYPE_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_reference); }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Type.UserDefinedWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { res += gremlin.sizes.sizeWireNumber(Type.UserDefinedWire.NULLABILITY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.nullability)); }
            if (self.type_parameters) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Type.UserDefinedWire.TYPE_PARAMETERS_WIRE);
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

        pub fn encode(self: *const UserDefined, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const UserDefined, target: *gremlin.Writer) void {
            if (self.type_reference != 0) { target.appendUint32(Type.UserDefinedWire.TYPE_REFERENCE_WIRE, self.type_reference); }
            if (self.type_variation_reference != 0) { target.appendUint32(Type.UserDefinedWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (@intFromEnum(self.nullability) != 0) { target.appendInt32(Type.UserDefinedWire.NULLABILITY_WIRE, @intFromEnum(self.nullability)); }
            if (self.type_parameters) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Type.UserDefinedWire.TYPE_PARAMETERS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Type.UserDefinedWire.TYPE_PARAMETERS_WIRE, 0);
                    }
                }
            }
        }
    };
    
    pub const UserDefinedReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _type_reference: u32 = 0,
        _type_variation_reference: u32 = 0,
        _nullability: Type.Nullability = @enumFromInt(0),
        _type_parameters_bufs: ?std.ArrayList([]const u8) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!UserDefinedReader {
            var buf = gremlin.Reader.init(src);
            var res = UserDefinedReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.UserDefinedWire.TYPE_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_reference = result.value;
                    },
                    Type.UserDefinedWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Type.UserDefinedWire.NULLABILITY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._nullability = @enumFromInt(result.value);
                    },
                    Type.UserDefinedWire.TYPE_PARAMETERS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._type_parameters_bufs == null) {
                            res._type_parameters_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._type_parameters_bufs.?.append(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const UserDefinedReader) void {
            if (self._type_parameters_bufs) |arr| {
                arr.deinit();
            }
        }
        pub inline fn getTypeReference(self: *const UserDefinedReader) u32 { return self._type_reference; }
        pub inline fn getTypeVariationReference(self: *const UserDefinedReader) u32 { return self._type_variation_reference; }
        pub inline fn getNullability(self: *const UserDefinedReader) Type.Nullability { return self._nullability; }
        pub fn getTypeParameters(self: *const UserDefinedReader, allocator: std.mem.Allocator) gremlin.Error![]Type.ParameterReader {
            if (self._type_parameters_bufs) |bufs| {
                var result = try std.ArrayList(Type.ParameterReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try Type.ParameterReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]Type.ParameterReader{};
        }
    };
    
    const ParameterWire = struct {
        const NULL_WIRE: gremlin.ProtoWireNumber = 1;
        const DATA_TYPE_WIRE: gremlin.ProtoWireNumber = 2;
        const BOOLEAN_WIRE: gremlin.ProtoWireNumber = 3;
        const INTEGER_WIRE: gremlin.ProtoWireNumber = 4;
        const ENUM_WIRE: gremlin.ProtoWireNumber = 5;
        const STRING_WIRE: gremlin.ProtoWireNumber = 6;
    };
    
    pub const Parameter = struct {
        // fields
        null_: ?empty.Empty = null,
        data_type: ?Type = null,
        boolean: bool = false,
        integer: i64 = 0,
        enum_: ?[]const u8 = null,
        string: ?[]const u8 = null,

        pub fn calcProtobufSize(self: *const Parameter) usize {
            var res: usize = 0;
            if (self.null_) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Type.ParameterWire.NULL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.data_type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Type.ParameterWire.DATA_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.boolean != false) { res += gremlin.sizes.sizeWireNumber(Type.ParameterWire.BOOLEAN_WIRE) + gremlin.sizes.sizeBool(self.boolean); }
            if (self.integer != 0) { res += gremlin.sizes.sizeWireNumber(Type.ParameterWire.INTEGER_WIRE) + gremlin.sizes.sizeI64(self.integer); }
            if (self.enum_) |v| { res += gremlin.sizes.sizeWireNumber(Type.ParameterWire.ENUM_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.string) |v| { res += gremlin.sizes.sizeWireNumber(Type.ParameterWire.STRING_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            return res;
        }

        pub fn encode(self: *const Parameter, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Parameter, target: *gremlin.Writer) void {
            if (self.null_) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Type.ParameterWire.NULL_WIRE, size);
                v.encodeTo(target);
            }
            if (self.data_type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Type.ParameterWire.DATA_TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.boolean != false) { target.appendBool(Type.ParameterWire.BOOLEAN_WIRE, self.boolean); }
            if (self.integer != 0) { target.appendInt64(Type.ParameterWire.INTEGER_WIRE, self.integer); }
            if (self.enum_) |v| { target.appendBytes(Type.ParameterWire.ENUM_WIRE, v); }
            if (self.string) |v| { target.appendBytes(Type.ParameterWire.STRING_WIRE, v); }
        }
    };
    
    pub const ParameterReader = struct {
        _null__buf: ?[]const u8 = null,
        _data_type_buf: ?[]const u8 = null,
        _boolean: bool = false,
        _integer: i64 = 0,
        _enum_: ?[]const u8 = null,
        _string: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ParameterReader {
            var buf = gremlin.Reader.init(src);
            var res = ParameterReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Type.ParameterWire.NULL_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._null__buf = result.value;
                    },
                    Type.ParameterWire.DATA_TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._data_type_buf = result.value;
                    },
                    Type.ParameterWire.BOOLEAN_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._boolean = result.value;
                    },
                    Type.ParameterWire.INTEGER_WIRE => {
                      const result = try buf.readInt64(offset);
                      offset += result.size;
                      res._integer = result.value;
                    },
                    Type.ParameterWire.ENUM_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._enum_ = result.value;
                    },
                    Type.ParameterWire.STRING_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._string = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ParameterReader) void { }
        
        pub fn getNull(self: *const ParameterReader, allocator: std.mem.Allocator) gremlin.Error!empty.EmptyReader {
            if (self._null__buf) |buf| {
                return try empty.EmptyReader.init(allocator, buf);
            }
            return try empty.EmptyReader.init(allocator, &[_]u8{});
        }
        pub fn getDataType(self: *const ParameterReader, allocator: std.mem.Allocator) gremlin.Error!TypeReader {
            if (self._data_type_buf) |buf| {
                return try TypeReader.init(allocator, buf);
            }
            return try TypeReader.init(allocator, &[_]u8{});
        }
        pub inline fn getBoolean(self: *const ParameterReader) bool { return self._boolean; }
        pub inline fn getInteger(self: *const ParameterReader) i64 { return self._integer; }
        pub inline fn getEnum(self: *const ParameterReader) []const u8 { return self._enum_ orelse &[_]u8{}; }
        pub inline fn getString(self: *const ParameterReader) []const u8 { return self._string orelse &[_]u8{}; }
    };
    
    // fields
    bool: ?Type.Boolean = null,
    i8: ?Type.I8 = null,
    i16: ?Type.I16 = null,
    i32: ?Type.I32 = null,
    i64: ?Type.I64 = null,
    fp32: ?Type.FP32 = null,
    fp64: ?Type.FP64 = null,
    string: ?Type.String = null,
    binary: ?Type.Binary = null,
    timestamp: ?Type.Timestamp = null,
    date: ?Type.Date = null,
    time: ?Type.Time = null,
    interval_year: ?Type.IntervalYear = null,
    interval_day: ?Type.IntervalDay = null,
    interval_compound: ?Type.IntervalCompound = null,
    timestamp_tz: ?Type.TimestampTZ = null,
    uuid: ?Type.UUID = null,
    fixed_char: ?Type.FixedChar = null,
    varchar: ?Type.VarChar = null,
    fixed_binary: ?Type.FixedBinary = null,
    decimal: ?Type.Decimal = null,
    precision_timestamp: ?Type.PrecisionTimestamp = null,
    precision_timestamp_tz: ?Type.PrecisionTimestampTZ = null,
    struct_: ?Type.Struct = null,
    list: ?Type.List = null,
    map: ?Type.Map = null,
    user_defined: ?Type.UserDefined = null,
    user_defined_type_reference: u32 = 0,

    pub fn calcProtobufSize(self: *const Type) usize {
        var res: usize = 0;
        if (self.bool) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.BOOL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i8) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.I8_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i16) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.I16_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i32) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.I32_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.i64) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.I64_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fp32) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.FP32_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fp64) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.FP64_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.string) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.STRING_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.binary) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.BINARY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.timestamp) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.TIMESTAMP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.date) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.DATE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.time) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.TIME_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.interval_year) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.INTERVAL_YEAR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.interval_day) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.INTERVAL_DAY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.interval_compound) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.INTERVAL_COMPOUND_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.TIMESTAMP_TZ_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.uuid) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.UUID_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fixed_char) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.FIXED_CHAR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.varchar) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.VARCHAR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fixed_binary) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.FIXED_BINARY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.decimal) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.DECIMAL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.precision_timestamp) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.PRECISION_TIMESTAMP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.precision_timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.PRECISION_TIMESTAMP_TZ_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.struct_) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.STRUCT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.list) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.LIST_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.map) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.MAP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.user_defined) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(TypeWire.USER_DEFINED_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.user_defined_type_reference != 0) { res += gremlin.sizes.sizeWireNumber(TypeWire.USER_DEFINED_TYPE_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.user_defined_type_reference); }
        return res;
    }

    pub fn encode(self: *const Type, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const Type, target: *gremlin.Writer) void {
        if (self.bool) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.BOOL_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i8) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.I8_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i16) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.I16_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i32) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.I32_WIRE, size);
            v.encodeTo(target);
        }
        if (self.i64) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.I64_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fp32) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.FP32_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fp64) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.FP64_WIRE, size);
            v.encodeTo(target);
        }
        if (self.string) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.STRING_WIRE, size);
            v.encodeTo(target);
        }
        if (self.binary) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.BINARY_WIRE, size);
            v.encodeTo(target);
        }
        if (self.timestamp) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.TIMESTAMP_WIRE, size);
            v.encodeTo(target);
        }
        if (self.date) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.DATE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.time) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.TIME_WIRE, size);
            v.encodeTo(target);
        }
        if (self.interval_year) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.INTERVAL_YEAR_WIRE, size);
            v.encodeTo(target);
        }
        if (self.interval_day) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.INTERVAL_DAY_WIRE, size);
            v.encodeTo(target);
        }
        if (self.interval_compound) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.INTERVAL_COMPOUND_WIRE, size);
            v.encodeTo(target);
        }
        if (self.timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.TIMESTAMP_TZ_WIRE, size);
            v.encodeTo(target);
        }
        if (self.uuid) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.UUID_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fixed_char) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.FIXED_CHAR_WIRE, size);
            v.encodeTo(target);
        }
        if (self.varchar) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.VARCHAR_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fixed_binary) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.FIXED_BINARY_WIRE, size);
            v.encodeTo(target);
        }
        if (self.decimal) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.DECIMAL_WIRE, size);
            v.encodeTo(target);
        }
        if (self.precision_timestamp) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.PRECISION_TIMESTAMP_WIRE, size);
            v.encodeTo(target);
        }
        if (self.precision_timestamp_tz) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.PRECISION_TIMESTAMP_TZ_WIRE, size);
            v.encodeTo(target);
        }
        if (self.struct_) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.STRUCT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.list) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.LIST_WIRE, size);
            v.encodeTo(target);
        }
        if (self.map) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.MAP_WIRE, size);
            v.encodeTo(target);
        }
        if (self.user_defined) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(TypeWire.USER_DEFINED_WIRE, size);
            v.encodeTo(target);
        }
        if (self.user_defined_type_reference != 0) { target.appendUint32(TypeWire.USER_DEFINED_TYPE_REFERENCE_WIRE, self.user_defined_type_reference); }
    }
};

pub const TypeReader = struct {
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
    _user_defined_type_reference: u32 = 0,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!TypeReader {
        var buf = gremlin.Reader.init(src);
        var res = TypeReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                TypeWire.BOOL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._bool_buf = result.value;
                },
                TypeWire.I8_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i8_buf = result.value;
                },
                TypeWire.I16_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i16_buf = result.value;
                },
                TypeWire.I32_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i32_buf = result.value;
                },
                TypeWire.I64_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._i64_buf = result.value;
                },
                TypeWire.FP32_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fp32_buf = result.value;
                },
                TypeWire.FP64_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fp64_buf = result.value;
                },
                TypeWire.STRING_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._string_buf = result.value;
                },
                TypeWire.BINARY_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._binary_buf = result.value;
                },
                TypeWire.TIMESTAMP_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._timestamp_buf = result.value;
                },
                TypeWire.DATE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._date_buf = result.value;
                },
                TypeWire.TIME_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._time_buf = result.value;
                },
                TypeWire.INTERVAL_YEAR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._interval_year_buf = result.value;
                },
                TypeWire.INTERVAL_DAY_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._interval_day_buf = result.value;
                },
                TypeWire.INTERVAL_COMPOUND_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._interval_compound_buf = result.value;
                },
                TypeWire.TIMESTAMP_TZ_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._timestamp_tz_buf = result.value;
                },
                TypeWire.UUID_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._uuid_buf = result.value;
                },
                TypeWire.FIXED_CHAR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fixed_char_buf = result.value;
                },
                TypeWire.VARCHAR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._varchar_buf = result.value;
                },
                TypeWire.FIXED_BINARY_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fixed_binary_buf = result.value;
                },
                TypeWire.DECIMAL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._decimal_buf = result.value;
                },
                TypeWire.PRECISION_TIMESTAMP_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._precision_timestamp_buf = result.value;
                },
                TypeWire.PRECISION_TIMESTAMP_TZ_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._precision_timestamp_tz_buf = result.value;
                },
                TypeWire.STRUCT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._struct__buf = result.value;
                },
                TypeWire.LIST_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._list_buf = result.value;
                },
                TypeWire.MAP_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._map_buf = result.value;
                },
                TypeWire.USER_DEFINED_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._user_defined_buf = result.value;
                },
                TypeWire.USER_DEFINED_TYPE_REFERENCE_WIRE => {
                  const result = try buf.readUInt32(offset);
                  offset += result.size;
                  res._user_defined_type_reference = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const TypeReader) void { }
    
    pub fn getBool(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.BooleanReader {
        if (self._bool_buf) |buf| {
            return try Type.BooleanReader.init(allocator, buf);
        }
        return try Type.BooleanReader.init(allocator, &[_]u8{});
    }
    pub fn getI8(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.I8Reader {
        if (self._i8_buf) |buf| {
            return try Type.I8Reader.init(allocator, buf);
        }
        return try Type.I8Reader.init(allocator, &[_]u8{});
    }
    pub fn getI16(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.I16Reader {
        if (self._i16_buf) |buf| {
            return try Type.I16Reader.init(allocator, buf);
        }
        return try Type.I16Reader.init(allocator, &[_]u8{});
    }
    pub fn getI32(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.I32Reader {
        if (self._i32_buf) |buf| {
            return try Type.I32Reader.init(allocator, buf);
        }
        return try Type.I32Reader.init(allocator, &[_]u8{});
    }
    pub fn getI64(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.I64Reader {
        if (self._i64_buf) |buf| {
            return try Type.I64Reader.init(allocator, buf);
        }
        return try Type.I64Reader.init(allocator, &[_]u8{});
    }
    pub fn getFp32(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.FP32Reader {
        if (self._fp32_buf) |buf| {
            return try Type.FP32Reader.init(allocator, buf);
        }
        return try Type.FP32Reader.init(allocator, &[_]u8{});
    }
    pub fn getFp64(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.FP64Reader {
        if (self._fp64_buf) |buf| {
            return try Type.FP64Reader.init(allocator, buf);
        }
        return try Type.FP64Reader.init(allocator, &[_]u8{});
    }
    pub fn getString(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.StringReader {
        if (self._string_buf) |buf| {
            return try Type.StringReader.init(allocator, buf);
        }
        return try Type.StringReader.init(allocator, &[_]u8{});
    }
    pub fn getBinary(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.BinaryReader {
        if (self._binary_buf) |buf| {
            return try Type.BinaryReader.init(allocator, buf);
        }
        return try Type.BinaryReader.init(allocator, &[_]u8{});
    }
    pub fn getTimestamp(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.TimestampReader {
        if (self._timestamp_buf) |buf| {
            return try Type.TimestampReader.init(allocator, buf);
        }
        return try Type.TimestampReader.init(allocator, &[_]u8{});
    }
    pub fn getDate(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.DateReader {
        if (self._date_buf) |buf| {
            return try Type.DateReader.init(allocator, buf);
        }
        return try Type.DateReader.init(allocator, &[_]u8{});
    }
    pub fn getTime(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.TimeReader {
        if (self._time_buf) |buf| {
            return try Type.TimeReader.init(allocator, buf);
        }
        return try Type.TimeReader.init(allocator, &[_]u8{});
    }
    pub fn getIntervalYear(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.IntervalYearReader {
        if (self._interval_year_buf) |buf| {
            return try Type.IntervalYearReader.init(allocator, buf);
        }
        return try Type.IntervalYearReader.init(allocator, &[_]u8{});
    }
    pub fn getIntervalDay(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.IntervalDayReader {
        if (self._interval_day_buf) |buf| {
            return try Type.IntervalDayReader.init(allocator, buf);
        }
        return try Type.IntervalDayReader.init(allocator, &[_]u8{});
    }
    pub fn getIntervalCompound(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.IntervalCompoundReader {
        if (self._interval_compound_buf) |buf| {
            return try Type.IntervalCompoundReader.init(allocator, buf);
        }
        return try Type.IntervalCompoundReader.init(allocator, &[_]u8{});
    }
    pub fn getTimestampTz(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.TimestampTZReader {
        if (self._timestamp_tz_buf) |buf| {
            return try Type.TimestampTZReader.init(allocator, buf);
        }
        return try Type.TimestampTZReader.init(allocator, &[_]u8{});
    }
    pub fn getUuid(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.UUIDReader {
        if (self._uuid_buf) |buf| {
            return try Type.UUIDReader.init(allocator, buf);
        }
        return try Type.UUIDReader.init(allocator, &[_]u8{});
    }
    pub fn getFixedChar(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.FixedCharReader {
        if (self._fixed_char_buf) |buf| {
            return try Type.FixedCharReader.init(allocator, buf);
        }
        return try Type.FixedCharReader.init(allocator, &[_]u8{});
    }
    pub fn getVarchar(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.VarCharReader {
        if (self._varchar_buf) |buf| {
            return try Type.VarCharReader.init(allocator, buf);
        }
        return try Type.VarCharReader.init(allocator, &[_]u8{});
    }
    pub fn getFixedBinary(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.FixedBinaryReader {
        if (self._fixed_binary_buf) |buf| {
            return try Type.FixedBinaryReader.init(allocator, buf);
        }
        return try Type.FixedBinaryReader.init(allocator, &[_]u8{});
    }
    pub fn getDecimal(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.DecimalReader {
        if (self._decimal_buf) |buf| {
            return try Type.DecimalReader.init(allocator, buf);
        }
        return try Type.DecimalReader.init(allocator, &[_]u8{});
    }
    pub fn getPrecisionTimestamp(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.PrecisionTimestampReader {
        if (self._precision_timestamp_buf) |buf| {
            return try Type.PrecisionTimestampReader.init(allocator, buf);
        }
        return try Type.PrecisionTimestampReader.init(allocator, &[_]u8{});
    }
    pub fn getPrecisionTimestampTz(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.PrecisionTimestampTZReader {
        if (self._precision_timestamp_tz_buf) |buf| {
            return try Type.PrecisionTimestampTZReader.init(allocator, buf);
        }
        return try Type.PrecisionTimestampTZReader.init(allocator, &[_]u8{});
    }
    pub fn getStruct(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.StructReader {
        if (self._struct__buf) |buf| {
            return try Type.StructReader.init(allocator, buf);
        }
        return try Type.StructReader.init(allocator, &[_]u8{});
    }
    pub fn getList(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.ListReader {
        if (self._list_buf) |buf| {
            return try Type.ListReader.init(allocator, buf);
        }
        return try Type.ListReader.init(allocator, &[_]u8{});
    }
    pub fn getMap(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.MapReader {
        if (self._map_buf) |buf| {
            return try Type.MapReader.init(allocator, buf);
        }
        return try Type.MapReader.init(allocator, &[_]u8{});
    }
    pub fn getUserDefined(self: *const TypeReader, allocator: std.mem.Allocator) gremlin.Error!Type.UserDefinedReader {
        if (self._user_defined_buf) |buf| {
            return try Type.UserDefinedReader.init(allocator, buf);
        }
        return try Type.UserDefinedReader.init(allocator, &[_]u8{});
    }
    pub inline fn getUserDefinedTypeReference(self: *const TypeReader) u32 { return self._user_defined_type_reference; }
};

const NamedStructWire = struct {
    const NAMES_WIRE: gremlin.ProtoWireNumber = 1;
    const STRUCT_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const NamedStruct = struct {
    // fields
    names: ?[]const ?[]const u8 = null,
    struct_: ?Type.Struct = null,

    pub fn calcProtobufSize(self: *const NamedStruct) usize {
        var res: usize = 0;
        if (self.names) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(NamedStructWire.NAMES_WIRE);
                if (maybe_v) |v| {
                    res += gremlin.sizes.sizeUsize(v.len) + v.len;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.struct_) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(NamedStructWire.STRUCT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const NamedStruct, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const NamedStruct, target: *gremlin.Writer) void {
        if (self.names) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    target.appendBytes(NamedStructWire.NAMES_WIRE, v);
                } else {
                    target.appendBytesTag(NamedStructWire.NAMES_WIRE, 0);
                }
            }
        }
        if (self.struct_) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(NamedStructWire.STRUCT_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const NamedStructReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _names: ?std.ArrayList([]const u8) = null,
    _struct__buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!NamedStructReader {
        var buf = gremlin.Reader.init(src);
        var res = NamedStructReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                NamedStructWire.NAMES_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._names == null) {
                        res._names = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._names.?.append(result.value);
                },
                NamedStructWire.STRUCT_WIRE => {
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
    pub fn deinit(self: *const NamedStructReader) void {
        if (self._names) |arr| {
            arr.deinit();
        }
    }
    pub fn getNames(self: *const NamedStructReader) []const []const u8 {
        if (self._names) |arr| {
            return arr.items;
        }
        return &[_][]u8{};
    }
    pub fn getStruct(self: *const NamedStructReader, allocator: std.mem.Allocator) gremlin.Error!Type.StructReader {
        if (self._struct__buf) |buf| {
            return try Type.StructReader.init(allocator, buf);
        }
        return try Type.StructReader.init(allocator, &[_]u8{});
    }
};

