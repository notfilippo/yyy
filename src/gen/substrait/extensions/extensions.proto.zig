const std = @import("std");
const gremlin = @import("gremlin");
const any = @import("src/gen/google/protobuf/any.proto.zig");

// structs
const SimpleExtensionURIWire = struct {
    const EXTENSION_URI_ANCHOR_WIRE: gremlin.ProtoWireNumber = 1;
    const URI_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const SimpleExtensionURI = struct {
    // fields
    extension_uri_anchor: u32 = 0,
    uri: ?[]const u8 = null,

    pub fn calcProtobufSize(self: *const SimpleExtensionURI) usize {
        var res: usize = 0;
        if (self.extension_uri_anchor != 0) { res += gremlin.sizes.sizeWireNumber(SimpleExtensionURIWire.EXTENSION_URI_ANCHOR_WIRE) + gremlin.sizes.sizeU32(self.extension_uri_anchor); }
        if (self.uri) |v| { res += gremlin.sizes.sizeWireNumber(SimpleExtensionURIWire.URI_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
        return res;
    }

    pub fn encode(self: *const SimpleExtensionURI, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const SimpleExtensionURI, target: *gremlin.Writer) void {
        if (self.extension_uri_anchor != 0) { target.appendUint32(SimpleExtensionURIWire.EXTENSION_URI_ANCHOR_WIRE, self.extension_uri_anchor); }
        if (self.uri) |v| { target.appendBytes(SimpleExtensionURIWire.URI_WIRE, v); }
    }
};

pub const SimpleExtensionURIReader = struct {
    _extension_uri_anchor: u32 = 0,
    _uri: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!SimpleExtensionURIReader {
        var buf = gremlin.Reader.init(src);
        var res = SimpleExtensionURIReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                SimpleExtensionURIWire.EXTENSION_URI_ANCHOR_WIRE => {
                  const result = try buf.readUInt32(offset);
                  offset += result.size;
                  res._extension_uri_anchor = result.value;
                },
                SimpleExtensionURIWire.URI_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._uri = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const SimpleExtensionURIReader) void { }
    
    pub inline fn getExtensionUriAnchor(self: *const SimpleExtensionURIReader) u32 { return self._extension_uri_anchor; }
    pub inline fn getUri(self: *const SimpleExtensionURIReader) []const u8 { return self._uri orelse &[_]u8{}; }
};

const SimpleExtensionDeclarationWire = struct {
    const EXTENSION_TYPE_WIRE: gremlin.ProtoWireNumber = 1;
    const EXTENSION_TYPE_VARIATION_WIRE: gremlin.ProtoWireNumber = 2;
    const EXTENSION_FUNCTION_WIRE: gremlin.ProtoWireNumber = 3;
};

pub const SimpleExtensionDeclaration = struct {
    // nested structs
    const ExtensionTypeWire = struct {
        const EXTENSION_URI_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const TYPE_ANCHOR_WIRE: gremlin.ProtoWireNumber = 2;
        const NAME_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExtensionType = struct {
        // fields
        extension_uri_reference: u32 = 0,
        type_anchor: u32 = 0,
        name: ?[]const u8 = null,

        pub fn calcProtobufSize(self: *const ExtensionType) usize {
            var res: usize = 0;
            if (self.extension_uri_reference != 0) { res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclaration.ExtensionTypeWire.EXTENSION_URI_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.extension_uri_reference); }
            if (self.type_anchor != 0) { res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclaration.ExtensionTypeWire.TYPE_ANCHOR_WIRE) + gremlin.sizes.sizeU32(self.type_anchor); }
            if (self.name) |v| { res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclaration.ExtensionTypeWire.NAME_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            return res;
        }

        pub fn encode(self: *const ExtensionType, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExtensionType, target: *gremlin.Writer) void {
            if (self.extension_uri_reference != 0) { target.appendUint32(SimpleExtensionDeclaration.ExtensionTypeWire.EXTENSION_URI_REFERENCE_WIRE, self.extension_uri_reference); }
            if (self.type_anchor != 0) { target.appendUint32(SimpleExtensionDeclaration.ExtensionTypeWire.TYPE_ANCHOR_WIRE, self.type_anchor); }
            if (self.name) |v| { target.appendBytes(SimpleExtensionDeclaration.ExtensionTypeWire.NAME_WIRE, v); }
        }
    };
    
    pub const ExtensionTypeReader = struct {
        _extension_uri_reference: u32 = 0,
        _type_anchor: u32 = 0,
        _name: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExtensionTypeReader {
            var buf = gremlin.Reader.init(src);
            var res = ExtensionTypeReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    SimpleExtensionDeclaration.ExtensionTypeWire.EXTENSION_URI_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._extension_uri_reference = result.value;
                    },
                    SimpleExtensionDeclaration.ExtensionTypeWire.TYPE_ANCHOR_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_anchor = result.value;
                    },
                    SimpleExtensionDeclaration.ExtensionTypeWire.NAME_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._name = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ExtensionTypeReader) void { }
        
        pub inline fn getExtensionUriReference(self: *const ExtensionTypeReader) u32 { return self._extension_uri_reference; }
        pub inline fn getTypeAnchor(self: *const ExtensionTypeReader) u32 { return self._type_anchor; }
        pub inline fn getName(self: *const ExtensionTypeReader) []const u8 { return self._name orelse &[_]u8{}; }
    };
    
    const ExtensionTypeVariationWire = struct {
        const EXTENSION_URI_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const TYPE_VARIATION_ANCHOR_WIRE: gremlin.ProtoWireNumber = 2;
        const NAME_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExtensionTypeVariation = struct {
        // fields
        extension_uri_reference: u32 = 0,
        type_variation_anchor: u32 = 0,
        name: ?[]const u8 = null,

        pub fn calcProtobufSize(self: *const ExtensionTypeVariation) usize {
            var res: usize = 0;
            if (self.extension_uri_reference != 0) { res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclaration.ExtensionTypeVariationWire.EXTENSION_URI_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.extension_uri_reference); }
            if (self.type_variation_anchor != 0) { res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclaration.ExtensionTypeVariationWire.TYPE_VARIATION_ANCHOR_WIRE) + gremlin.sizes.sizeU32(self.type_variation_anchor); }
            if (self.name) |v| { res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclaration.ExtensionTypeVariationWire.NAME_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            return res;
        }

        pub fn encode(self: *const ExtensionTypeVariation, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExtensionTypeVariation, target: *gremlin.Writer) void {
            if (self.extension_uri_reference != 0) { target.appendUint32(SimpleExtensionDeclaration.ExtensionTypeVariationWire.EXTENSION_URI_REFERENCE_WIRE, self.extension_uri_reference); }
            if (self.type_variation_anchor != 0) { target.appendUint32(SimpleExtensionDeclaration.ExtensionTypeVariationWire.TYPE_VARIATION_ANCHOR_WIRE, self.type_variation_anchor); }
            if (self.name) |v| { target.appendBytes(SimpleExtensionDeclaration.ExtensionTypeVariationWire.NAME_WIRE, v); }
        }
    };
    
    pub const ExtensionTypeVariationReader = struct {
        _extension_uri_reference: u32 = 0,
        _type_variation_anchor: u32 = 0,
        _name: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExtensionTypeVariationReader {
            var buf = gremlin.Reader.init(src);
            var res = ExtensionTypeVariationReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    SimpleExtensionDeclaration.ExtensionTypeVariationWire.EXTENSION_URI_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._extension_uri_reference = result.value;
                    },
                    SimpleExtensionDeclaration.ExtensionTypeVariationWire.TYPE_VARIATION_ANCHOR_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_anchor = result.value;
                    },
                    SimpleExtensionDeclaration.ExtensionTypeVariationWire.NAME_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._name = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ExtensionTypeVariationReader) void { }
        
        pub inline fn getExtensionUriReference(self: *const ExtensionTypeVariationReader) u32 { return self._extension_uri_reference; }
        pub inline fn getTypeVariationAnchor(self: *const ExtensionTypeVariationReader) u32 { return self._type_variation_anchor; }
        pub inline fn getName(self: *const ExtensionTypeVariationReader) []const u8 { return self._name orelse &[_]u8{}; }
    };
    
    const ExtensionFunctionWire = struct {
        const EXTENSION_URI_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const FUNCTION_ANCHOR_WIRE: gremlin.ProtoWireNumber = 2;
        const NAME_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExtensionFunction = struct {
        // fields
        extension_uri_reference: u32 = 0,
        function_anchor: u32 = 0,
        name: ?[]const u8 = null,

        pub fn calcProtobufSize(self: *const ExtensionFunction) usize {
            var res: usize = 0;
            if (self.extension_uri_reference != 0) { res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclaration.ExtensionFunctionWire.EXTENSION_URI_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.extension_uri_reference); }
            if (self.function_anchor != 0) { res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclaration.ExtensionFunctionWire.FUNCTION_ANCHOR_WIRE) + gremlin.sizes.sizeU32(self.function_anchor); }
            if (self.name) |v| { res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclaration.ExtensionFunctionWire.NAME_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            return res;
        }

        pub fn encode(self: *const ExtensionFunction, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExtensionFunction, target: *gremlin.Writer) void {
            if (self.extension_uri_reference != 0) { target.appendUint32(SimpleExtensionDeclaration.ExtensionFunctionWire.EXTENSION_URI_REFERENCE_WIRE, self.extension_uri_reference); }
            if (self.function_anchor != 0) { target.appendUint32(SimpleExtensionDeclaration.ExtensionFunctionWire.FUNCTION_ANCHOR_WIRE, self.function_anchor); }
            if (self.name) |v| { target.appendBytes(SimpleExtensionDeclaration.ExtensionFunctionWire.NAME_WIRE, v); }
        }
    };
    
    pub const ExtensionFunctionReader = struct {
        _extension_uri_reference: u32 = 0,
        _function_anchor: u32 = 0,
        _name: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExtensionFunctionReader {
            var buf = gremlin.Reader.init(src);
            var res = ExtensionFunctionReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    SimpleExtensionDeclaration.ExtensionFunctionWire.EXTENSION_URI_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._extension_uri_reference = result.value;
                    },
                    SimpleExtensionDeclaration.ExtensionFunctionWire.FUNCTION_ANCHOR_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._function_anchor = result.value;
                    },
                    SimpleExtensionDeclaration.ExtensionFunctionWire.NAME_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._name = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ExtensionFunctionReader) void { }
        
        pub inline fn getExtensionUriReference(self: *const ExtensionFunctionReader) u32 { return self._extension_uri_reference; }
        pub inline fn getFunctionAnchor(self: *const ExtensionFunctionReader) u32 { return self._function_anchor; }
        pub inline fn getName(self: *const ExtensionFunctionReader) []const u8 { return self._name orelse &[_]u8{}; }
    };
    
    // fields
    extension_type: ?SimpleExtensionDeclaration.ExtensionType = null,
    extension_type_variation: ?SimpleExtensionDeclaration.ExtensionTypeVariation = null,
    extension_function: ?SimpleExtensionDeclaration.ExtensionFunction = null,

    pub fn calcProtobufSize(self: *const SimpleExtensionDeclaration) usize {
        var res: usize = 0;
        if (self.extension_type) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclarationWire.EXTENSION_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.extension_type_variation) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclarationWire.EXTENSION_TYPE_VARIATION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.extension_function) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(SimpleExtensionDeclarationWire.EXTENSION_FUNCTION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const SimpleExtensionDeclaration, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const SimpleExtensionDeclaration, target: *gremlin.Writer) void {
        if (self.extension_type) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(SimpleExtensionDeclarationWire.EXTENSION_TYPE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.extension_type_variation) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(SimpleExtensionDeclarationWire.EXTENSION_TYPE_VARIATION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.extension_function) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(SimpleExtensionDeclarationWire.EXTENSION_FUNCTION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const SimpleExtensionDeclarationReader = struct {
    _extension_type_buf: ?[]const u8 = null,
    _extension_type_variation_buf: ?[]const u8 = null,
    _extension_function_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!SimpleExtensionDeclarationReader {
        var buf = gremlin.Reader.init(src);
        var res = SimpleExtensionDeclarationReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                SimpleExtensionDeclarationWire.EXTENSION_TYPE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._extension_type_buf = result.value;
                },
                SimpleExtensionDeclarationWire.EXTENSION_TYPE_VARIATION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._extension_type_variation_buf = result.value;
                },
                SimpleExtensionDeclarationWire.EXTENSION_FUNCTION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._extension_function_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const SimpleExtensionDeclarationReader) void { }
    
    pub fn getExtensionType(self: *const SimpleExtensionDeclarationReader, allocator: std.mem.Allocator) gremlin.Error!SimpleExtensionDeclaration.ExtensionTypeReader {
        if (self._extension_type_buf) |buf| {
            return try SimpleExtensionDeclaration.ExtensionTypeReader.init(allocator, buf);
        }
        return try SimpleExtensionDeclaration.ExtensionTypeReader.init(allocator, &[_]u8{});
    }
    pub fn getExtensionTypeVariation(self: *const SimpleExtensionDeclarationReader, allocator: std.mem.Allocator) gremlin.Error!SimpleExtensionDeclaration.ExtensionTypeVariationReader {
        if (self._extension_type_variation_buf) |buf| {
            return try SimpleExtensionDeclaration.ExtensionTypeVariationReader.init(allocator, buf);
        }
        return try SimpleExtensionDeclaration.ExtensionTypeVariationReader.init(allocator, &[_]u8{});
    }
    pub fn getExtensionFunction(self: *const SimpleExtensionDeclarationReader, allocator: std.mem.Allocator) gremlin.Error!SimpleExtensionDeclaration.ExtensionFunctionReader {
        if (self._extension_function_buf) |buf| {
            return try SimpleExtensionDeclaration.ExtensionFunctionReader.init(allocator, buf);
        }
        return try SimpleExtensionDeclaration.ExtensionFunctionReader.init(allocator, &[_]u8{});
    }
};

const AdvancedExtensionWire = struct {
    const OPTIMIZATION_WIRE: gremlin.ProtoWireNumber = 1;
    const ENHANCEMENT_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const AdvancedExtension = struct {
    // fields
    optimization: ?[]const ?any.Any = null,
    enhancement: ?any.Any = null,

    pub fn calcProtobufSize(self: *const AdvancedExtension) usize {
        var res: usize = 0;
        if (self.optimization) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(AdvancedExtensionWire.OPTIMIZATION_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.enhancement) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(AdvancedExtensionWire.ENHANCEMENT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const AdvancedExtension, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const AdvancedExtension, target: *gremlin.Writer) void {
        if (self.optimization) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(AdvancedExtensionWire.OPTIMIZATION_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(AdvancedExtensionWire.OPTIMIZATION_WIRE, 0);
                }
            }
        }
        if (self.enhancement) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(AdvancedExtensionWire.ENHANCEMENT_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const AdvancedExtensionReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _optimization_bufs: ?std.ArrayList([]const u8) = null,
    _enhancement_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!AdvancedExtensionReader {
        var buf = gremlin.Reader.init(src);
        var res = AdvancedExtensionReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                AdvancedExtensionWire.OPTIMIZATION_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._optimization_bufs == null) {
                        res._optimization_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._optimization_bufs.?.append(result.value);
                },
                AdvancedExtensionWire.ENHANCEMENT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._enhancement_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const AdvancedExtensionReader) void {
        if (self._optimization_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getOptimization(self: *const AdvancedExtensionReader, allocator: std.mem.Allocator) gremlin.Error![]any.AnyReader {
        if (self._optimization_bufs) |bufs| {
            var result = try std.ArrayList(any.AnyReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try any.AnyReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]any.AnyReader{};
    }
    pub fn getEnhancement(self: *const AdvancedExtensionReader, allocator: std.mem.Allocator) gremlin.Error!any.AnyReader {
        if (self._enhancement_buf) |buf| {
            return try any.AnyReader.init(allocator, buf);
        }
        return try any.AnyReader.init(allocator, &[_]u8{});
    }
};

