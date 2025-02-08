const std = @import("std");
const gremlin = @import("gremlin");

// structs
const CapabilitiesWire = struct {
    const SUBSTRAIT_VERSIONS_WIRE: gremlin.ProtoWireNumber = 1;
    const ADVANCED_EXTENSION_TYPE_URLS_WIRE: gremlin.ProtoWireNumber = 2;
    const SIMPLE_EXTENSIONS_WIRE: gremlin.ProtoWireNumber = 3;
};

pub const Capabilities = struct {
    // nested structs
    const SimpleExtensionWire = struct {
        const URI_WIRE: gremlin.ProtoWireNumber = 1;
        const FUNCTION_KEYS_WIRE: gremlin.ProtoWireNumber = 2;
        const TYPE_KEYS_WIRE: gremlin.ProtoWireNumber = 3;
        const TYPE_VARIATION_KEYS_WIRE: gremlin.ProtoWireNumber = 4;
    };
    
    pub const SimpleExtension = struct {
        // fields
        uri: ?[]const u8 = null,
        function_keys: ?[]const ?[]const u8 = null,
        type_keys: ?[]const ?[]const u8 = null,
        type_variation_keys: ?[]const ?[]const u8 = null,

        pub fn calcProtobufSize(self: *const SimpleExtension) usize {
            var res: usize = 0;
            if (self.uri) |v| { res += gremlin.sizes.sizeWireNumber(Capabilities.SimpleExtensionWire.URI_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.function_keys) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Capabilities.SimpleExtensionWire.FUNCTION_KEYS_WIRE);
                    if (maybe_v) |v| {
                        res += gremlin.sizes.sizeUsize(v.len) + v.len;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.type_keys) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Capabilities.SimpleExtensionWire.TYPE_KEYS_WIRE);
                    if (maybe_v) |v| {
                        res += gremlin.sizes.sizeUsize(v.len) + v.len;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.type_variation_keys) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Capabilities.SimpleExtensionWire.TYPE_VARIATION_KEYS_WIRE);
                    if (maybe_v) |v| {
                        res += gremlin.sizes.sizeUsize(v.len) + v.len;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            return res;
        }

        pub fn encode(self: *const SimpleExtension, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const SimpleExtension, target: *gremlin.Writer) void {
            if (self.uri) |v| { target.appendBytes(Capabilities.SimpleExtensionWire.URI_WIRE, v); }
            if (self.function_keys) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        target.appendBytes(Capabilities.SimpleExtensionWire.FUNCTION_KEYS_WIRE, v);
                    } else {
                        target.appendBytesTag(Capabilities.SimpleExtensionWire.FUNCTION_KEYS_WIRE, 0);
                    }
                }
            }
            if (self.type_keys) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        target.appendBytes(Capabilities.SimpleExtensionWire.TYPE_KEYS_WIRE, v);
                    } else {
                        target.appendBytesTag(Capabilities.SimpleExtensionWire.TYPE_KEYS_WIRE, 0);
                    }
                }
            }
            if (self.type_variation_keys) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        target.appendBytes(Capabilities.SimpleExtensionWire.TYPE_VARIATION_KEYS_WIRE, v);
                    } else {
                        target.appendBytesTag(Capabilities.SimpleExtensionWire.TYPE_VARIATION_KEYS_WIRE, 0);
                    }
                }
            }
        }
    };
    
    pub const SimpleExtensionReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _uri: ?[]const u8 = null,
        _function_keys: ?std.ArrayList([]const u8) = null,
        _type_keys: ?std.ArrayList([]const u8) = null,
        _type_variation_keys: ?std.ArrayList([]const u8) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!SimpleExtensionReader {
            var buf = gremlin.Reader.init(src);
            var res = SimpleExtensionReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Capabilities.SimpleExtensionWire.URI_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._uri = result.value;
                    },
                    Capabilities.SimpleExtensionWire.FUNCTION_KEYS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._function_keys == null) {
                            res._function_keys = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._function_keys.?.append(result.value);
                    },
                    Capabilities.SimpleExtensionWire.TYPE_KEYS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._type_keys == null) {
                            res._type_keys = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._type_keys.?.append(result.value);
                    },
                    Capabilities.SimpleExtensionWire.TYPE_VARIATION_KEYS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._type_variation_keys == null) {
                            res._type_variation_keys = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._type_variation_keys.?.append(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const SimpleExtensionReader) void {
            if (self._function_keys) |arr| {
                arr.deinit();
            }
            if (self._type_keys) |arr| {
                arr.deinit();
            }
            if (self._type_variation_keys) |arr| {
                arr.deinit();
            }
        }
        pub inline fn getUri(self: *const SimpleExtensionReader) []const u8 { return self._uri orelse &[_]u8{}; }
        pub fn getFunctionKeys(self: *const SimpleExtensionReader) []const []const u8 {
            if (self._function_keys) |arr| {
                return arr.items;
            }
            return &[_][]u8{};
        }
        pub fn getTypeKeys(self: *const SimpleExtensionReader) []const []const u8 {
            if (self._type_keys) |arr| {
                return arr.items;
            }
            return &[_][]u8{};
        }
        pub fn getTypeVariationKeys(self: *const SimpleExtensionReader) []const []const u8 {
            if (self._type_variation_keys) |arr| {
                return arr.items;
            }
            return &[_][]u8{};
        }
    };
    
    // fields
    substrait_versions: ?[]const ?[]const u8 = null,
    advanced_extension_type_urls: ?[]const ?[]const u8 = null,
    simple_extensions: ?[]const ?Capabilities.SimpleExtension = null,

    pub fn calcProtobufSize(self: *const Capabilities) usize {
        var res: usize = 0;
        if (self.substrait_versions) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(CapabilitiesWire.SUBSTRAIT_VERSIONS_WIRE);
                if (maybe_v) |v| {
                    res += gremlin.sizes.sizeUsize(v.len) + v.len;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.advanced_extension_type_urls) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(CapabilitiesWire.ADVANCED_EXTENSION_TYPE_URLS_WIRE);
                if (maybe_v) |v| {
                    res += gremlin.sizes.sizeUsize(v.len) + v.len;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.simple_extensions) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(CapabilitiesWire.SIMPLE_EXTENSIONS_WIRE);
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

    pub fn encode(self: *const Capabilities, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const Capabilities, target: *gremlin.Writer) void {
        if (self.substrait_versions) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    target.appendBytes(CapabilitiesWire.SUBSTRAIT_VERSIONS_WIRE, v);
                } else {
                    target.appendBytesTag(CapabilitiesWire.SUBSTRAIT_VERSIONS_WIRE, 0);
                }
            }
        }
        if (self.advanced_extension_type_urls) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    target.appendBytes(CapabilitiesWire.ADVANCED_EXTENSION_TYPE_URLS_WIRE, v);
                } else {
                    target.appendBytesTag(CapabilitiesWire.ADVANCED_EXTENSION_TYPE_URLS_WIRE, 0);
                }
            }
        }
        if (self.simple_extensions) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(CapabilitiesWire.SIMPLE_EXTENSIONS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(CapabilitiesWire.SIMPLE_EXTENSIONS_WIRE, 0);
                }
            }
        }
    }
};

pub const CapabilitiesReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _substrait_versions: ?std.ArrayList([]const u8) = null,
    _advanced_extension_type_urls: ?std.ArrayList([]const u8) = null,
    _simple_extensions_bufs: ?std.ArrayList([]const u8) = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!CapabilitiesReader {
        var buf = gremlin.Reader.init(src);
        var res = CapabilitiesReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                CapabilitiesWire.SUBSTRAIT_VERSIONS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._substrait_versions == null) {
                        res._substrait_versions = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._substrait_versions.?.append(result.value);
                },
                CapabilitiesWire.ADVANCED_EXTENSION_TYPE_URLS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._advanced_extension_type_urls == null) {
                        res._advanced_extension_type_urls = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._advanced_extension_type_urls.?.append(result.value);
                },
                CapabilitiesWire.SIMPLE_EXTENSIONS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._simple_extensions_bufs == null) {
                        res._simple_extensions_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._simple_extensions_bufs.?.append(result.value);
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const CapabilitiesReader) void {
        if (self._substrait_versions) |arr| {
            arr.deinit();
        }
        if (self._advanced_extension_type_urls) |arr| {
            arr.deinit();
        }
        if (self._simple_extensions_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getSubstraitVersions(self: *const CapabilitiesReader) []const []const u8 {
        if (self._substrait_versions) |arr| {
            return arr.items;
        }
        return &[_][]u8{};
    }
    pub fn getAdvancedExtensionTypeUrls(self: *const CapabilitiesReader) []const []const u8 {
        if (self._advanced_extension_type_urls) |arr| {
            return arr.items;
        }
        return &[_][]u8{};
    }
    pub fn getSimpleExtensions(self: *const CapabilitiesReader, allocator: std.mem.Allocator) gremlin.Error![]Capabilities.SimpleExtensionReader {
        if (self._simple_extensions_bufs) |bufs| {
            var result = try std.ArrayList(Capabilities.SimpleExtensionReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try Capabilities.SimpleExtensionReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]Capabilities.SimpleExtensionReader{};
    }
};

