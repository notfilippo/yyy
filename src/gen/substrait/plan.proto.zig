const std = @import("std");
const gremlin = @import("gremlin");
const algebra = @import("algebra.proto.zig");
const extensions = @import("src/gen/substrait/extensions/extensions.proto.zig");

// structs
const PlanRelWire = struct {
    const REL_WIRE: gremlin.ProtoWireNumber = 1;
    const ROOT_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const PlanRel = struct {
    // fields
    rel: ?algebra.Rel = null,
    root: ?algebra.RelRoot = null,

    pub fn calcProtobufSize(self: *const PlanRel) usize {
        var res: usize = 0;
        if (self.rel) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(PlanRelWire.REL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.root) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(PlanRelWire.ROOT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const PlanRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const PlanRel, target: *gremlin.Writer) void {
        if (self.rel) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(PlanRelWire.REL_WIRE, size);
            v.encodeTo(target);
        }
        if (self.root) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(PlanRelWire.ROOT_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const PlanRelReader = struct {
    _rel_buf: ?[]const u8 = null,
    _root_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!PlanRelReader {
        var buf = gremlin.Reader.init(src);
        var res = PlanRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                PlanRelWire.REL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._rel_buf = result.value;
                },
                PlanRelWire.ROOT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._root_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const PlanRelReader) void { }
    
    pub fn getRel(self: *const PlanRelReader, allocator: std.mem.Allocator) gremlin.Error!algebra.RelReader {
        if (self._rel_buf) |buf| {
            return try algebra.RelReader.init(allocator, buf);
        }
        return try algebra.RelReader.init(allocator, &[_]u8{});
    }
    pub fn getRoot(self: *const PlanRelReader, allocator: std.mem.Allocator) gremlin.Error!algebra.RelRootReader {
        if (self._root_buf) |buf| {
            return try algebra.RelRootReader.init(allocator, buf);
        }
        return try algebra.RelRootReader.init(allocator, &[_]u8{});
    }
};

const PlanWire = struct {
    const VERSION_WIRE: gremlin.ProtoWireNumber = 6;
    const EXTENSION_URIS_WIRE: gremlin.ProtoWireNumber = 1;
    const EXTENSIONS_WIRE: gremlin.ProtoWireNumber = 2;
    const RELATIONS_WIRE: gremlin.ProtoWireNumber = 3;
    const ADVANCED_EXTENSIONS_WIRE: gremlin.ProtoWireNumber = 4;
    const EXPECTED_TYPE_URLS_WIRE: gremlin.ProtoWireNumber = 5;
};

pub const Plan = struct {
    // fields
    version: ?Version = null,
    extension_uris: ?[]const ?extensions.SimpleExtensionURI = null,
    extensions: ?[]const ?extensions.SimpleExtensionDeclaration = null,
    relations: ?[]const ?PlanRel = null,
    advanced_extensions: ?extensions.AdvancedExtension = null,
    expected_type_urls: ?[]const ?[]const u8 = null,

    pub fn calcProtobufSize(self: *const Plan) usize {
        var res: usize = 0;
        if (self.version) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(PlanWire.VERSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.extension_uris) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(PlanWire.EXTENSION_URIS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.extensions) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(PlanWire.EXTENSIONS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.relations) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(PlanWire.RELATIONS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.advanced_extensions) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(PlanWire.ADVANCED_EXTENSIONS_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.expected_type_urls) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(PlanWire.EXPECTED_TYPE_URLS_WIRE);
                if (maybe_v) |v| {
                    res += gremlin.sizes.sizeUsize(v.len) + v.len;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        return res;
    }

    pub fn encode(self: *const Plan, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const Plan, target: *gremlin.Writer) void {
        if (self.version) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(PlanWire.VERSION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.extension_uris) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(PlanWire.EXTENSION_URIS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(PlanWire.EXTENSION_URIS_WIRE, 0);
                }
            }
        }
        if (self.extensions) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(PlanWire.EXTENSIONS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(PlanWire.EXTENSIONS_WIRE, 0);
                }
            }
        }
        if (self.relations) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(PlanWire.RELATIONS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(PlanWire.RELATIONS_WIRE, 0);
                }
            }
        }
        if (self.advanced_extensions) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(PlanWire.ADVANCED_EXTENSIONS_WIRE, size);
            v.encodeTo(target);
        }
        if (self.expected_type_urls) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    target.appendBytes(PlanWire.EXPECTED_TYPE_URLS_WIRE, v);
                } else {
                    target.appendBytesTag(PlanWire.EXPECTED_TYPE_URLS_WIRE, 0);
                }
            }
        }
    }
};

pub const PlanReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _version_buf: ?[]const u8 = null,
    _extension_uris_bufs: ?std.ArrayList([]const u8) = null,
    _extensions_bufs: ?std.ArrayList([]const u8) = null,
    _relations_bufs: ?std.ArrayList([]const u8) = null,
    _advanced_extensions_buf: ?[]const u8 = null,
    _expected_type_urls: ?std.ArrayList([]const u8) = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!PlanReader {
        var buf = gremlin.Reader.init(src);
        var res = PlanReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                PlanWire.VERSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._version_buf = result.value;
                },
                PlanWire.EXTENSION_URIS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._extension_uris_bufs == null) {
                        res._extension_uris_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._extension_uris_bufs.?.append(result.value);
                },
                PlanWire.EXTENSIONS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._extensions_bufs == null) {
                        res._extensions_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._extensions_bufs.?.append(result.value);
                },
                PlanWire.RELATIONS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._relations_bufs == null) {
                        res._relations_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._relations_bufs.?.append(result.value);
                },
                PlanWire.ADVANCED_EXTENSIONS_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extensions_buf = result.value;
                },
                PlanWire.EXPECTED_TYPE_URLS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._expected_type_urls == null) {
                        res._expected_type_urls = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._expected_type_urls.?.append(result.value);
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const PlanReader) void {
        if (self._extension_uris_bufs) |arr| {
            arr.deinit();
        }
        if (self._extensions_bufs) |arr| {
            arr.deinit();
        }
        if (self._relations_bufs) |arr| {
            arr.deinit();
        }
        if (self._expected_type_urls) |arr| {
            arr.deinit();
        }
    }
    pub fn getVersion(self: *const PlanReader, allocator: std.mem.Allocator) gremlin.Error!VersionReader {
        if (self._version_buf) |buf| {
            return try VersionReader.init(allocator, buf);
        }
        return try VersionReader.init(allocator, &[_]u8{});
    }
    pub fn getExtensionUris(self: *const PlanReader, allocator: std.mem.Allocator) gremlin.Error![]extensions.SimpleExtensionURIReader {
        if (self._extension_uris_bufs) |bufs| {
            var result = try std.ArrayList(extensions.SimpleExtensionURIReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try extensions.SimpleExtensionURIReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]extensions.SimpleExtensionURIReader{};
    }
    pub fn getExtensions(self: *const PlanReader, allocator: std.mem.Allocator) gremlin.Error![]extensions.SimpleExtensionDeclarationReader {
        if (self._extensions_bufs) |bufs| {
            var result = try std.ArrayList(extensions.SimpleExtensionDeclarationReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try extensions.SimpleExtensionDeclarationReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]extensions.SimpleExtensionDeclarationReader{};
    }
    pub fn getRelations(self: *const PlanReader, allocator: std.mem.Allocator) gremlin.Error![]PlanRelReader {
        if (self._relations_bufs) |bufs| {
            var result = try std.ArrayList(PlanRelReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try PlanRelReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]PlanRelReader{};
    }
    pub fn getAdvancedExtensions(self: *const PlanReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extensions_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
    pub fn getExpectedTypeUrls(self: *const PlanReader) []const []const u8 {
        if (self._expected_type_urls) |arr| {
            return arr.items;
        }
        return &[_][]u8{};
    }
};

const PlanVersionWire = struct {
    const VERSION_WIRE: gremlin.ProtoWireNumber = 6;
};

pub const PlanVersion = struct {
    // fields
    version: ?Version = null,

    pub fn calcProtobufSize(self: *const PlanVersion) usize {
        var res: usize = 0;
        if (self.version) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(PlanVersionWire.VERSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const PlanVersion, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const PlanVersion, target: *gremlin.Writer) void {
        if (self.version) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(PlanVersionWire.VERSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const PlanVersionReader = struct {
    _version_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!PlanVersionReader {
        var buf = gremlin.Reader.init(src);
        var res = PlanVersionReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                PlanVersionWire.VERSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._version_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const PlanVersionReader) void { }
    
    pub fn getVersion(self: *const PlanVersionReader, allocator: std.mem.Allocator) gremlin.Error!VersionReader {
        if (self._version_buf) |buf| {
            return try VersionReader.init(allocator, buf);
        }
        return try VersionReader.init(allocator, &[_]u8{});
    }
};

const VersionWire = struct {
    const MAJOR_NUMBER_WIRE: gremlin.ProtoWireNumber = 1;
    const MINOR_NUMBER_WIRE: gremlin.ProtoWireNumber = 2;
    const PATCH_NUMBER_WIRE: gremlin.ProtoWireNumber = 3;
    const GIT_HASH_WIRE: gremlin.ProtoWireNumber = 4;
    const PRODUCER_WIRE: gremlin.ProtoWireNumber = 5;
};

pub const Version = struct {
    // fields
    major_number: u32 = 0,
    minor_number: u32 = 0,
    patch_number: u32 = 0,
    git_hash: ?[]const u8 = null,
    producer: ?[]const u8 = null,

    pub fn calcProtobufSize(self: *const Version) usize {
        var res: usize = 0;
        if (self.major_number != 0) { res += gremlin.sizes.sizeWireNumber(VersionWire.MAJOR_NUMBER_WIRE) + gremlin.sizes.sizeU32(self.major_number); }
        if (self.minor_number != 0) { res += gremlin.sizes.sizeWireNumber(VersionWire.MINOR_NUMBER_WIRE) + gremlin.sizes.sizeU32(self.minor_number); }
        if (self.patch_number != 0) { res += gremlin.sizes.sizeWireNumber(VersionWire.PATCH_NUMBER_WIRE) + gremlin.sizes.sizeU32(self.patch_number); }
        if (self.git_hash) |v| { res += gremlin.sizes.sizeWireNumber(VersionWire.GIT_HASH_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
        if (self.producer) |v| { res += gremlin.sizes.sizeWireNumber(VersionWire.PRODUCER_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
        return res;
    }

    pub fn encode(self: *const Version, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const Version, target: *gremlin.Writer) void {
        if (self.major_number != 0) { target.appendUint32(VersionWire.MAJOR_NUMBER_WIRE, self.major_number); }
        if (self.minor_number != 0) { target.appendUint32(VersionWire.MINOR_NUMBER_WIRE, self.minor_number); }
        if (self.patch_number != 0) { target.appendUint32(VersionWire.PATCH_NUMBER_WIRE, self.patch_number); }
        if (self.git_hash) |v| { target.appendBytes(VersionWire.GIT_HASH_WIRE, v); }
        if (self.producer) |v| { target.appendBytes(VersionWire.PRODUCER_WIRE, v); }
    }
};

pub const VersionReader = struct {
    _major_number: u32 = 0,
    _minor_number: u32 = 0,
    _patch_number: u32 = 0,
    _git_hash: ?[]const u8 = null,
    _producer: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!VersionReader {
        var buf = gremlin.Reader.init(src);
        var res = VersionReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                VersionWire.MAJOR_NUMBER_WIRE => {
                  const result = try buf.readUInt32(offset);
                  offset += result.size;
                  res._major_number = result.value;
                },
                VersionWire.MINOR_NUMBER_WIRE => {
                  const result = try buf.readUInt32(offset);
                  offset += result.size;
                  res._minor_number = result.value;
                },
                VersionWire.PATCH_NUMBER_WIRE => {
                  const result = try buf.readUInt32(offset);
                  offset += result.size;
                  res._patch_number = result.value;
                },
                VersionWire.GIT_HASH_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._git_hash = result.value;
                },
                VersionWire.PRODUCER_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._producer = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const VersionReader) void { }
    
    pub inline fn getMajorNumber(self: *const VersionReader) u32 { return self._major_number; }
    pub inline fn getMinorNumber(self: *const VersionReader) u32 { return self._minor_number; }
    pub inline fn getPatchNumber(self: *const VersionReader) u32 { return self._patch_number; }
    pub inline fn getGitHash(self: *const VersionReader) []const u8 { return self._git_hash orelse &[_]u8{}; }
    pub inline fn getProducer(self: *const VersionReader) []const u8 { return self._producer orelse &[_]u8{}; }
};

