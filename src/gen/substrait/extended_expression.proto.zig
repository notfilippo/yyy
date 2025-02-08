const std = @import("std");
const gremlin = @import("gremlin");
const algebra = @import("algebra.proto.zig");
const plan = @import("plan.proto.zig");
const extensions = @import("src/gen/substrait/extensions/extensions.proto.zig");
const type = @import("type.proto.zig");

// structs
const ExpressionReferenceWire = struct {
    const OUTPUT_NAMES_WIRE: gremlin.ProtoWireNumber = 3;
    const EXPRESSION_WIRE: gremlin.ProtoWireNumber = 1;
    const MEASURE_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const ExpressionReference = struct {
    // fields
    output_names: ?[]const ?[]const u8 = null,
    expression: ?algebra.Expression = null,
    measure: ?algebra.AggregateFunction = null,

    pub fn calcProtobufSize(self: *const ExpressionReference) usize {
        var res: usize = 0;
        if (self.output_names) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(ExpressionReferenceWire.OUTPUT_NAMES_WIRE);
                if (maybe_v) |v| {
                    res += gremlin.sizes.sizeUsize(v.len) + v.len;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.expression) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionReferenceWire.EXPRESSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.measure) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionReferenceWire.MEASURE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const ExpressionReference, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ExpressionReference, target: *gremlin.Writer) void {
        if (self.output_names) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    target.appendBytes(ExpressionReferenceWire.OUTPUT_NAMES_WIRE, v);
                } else {
                    target.appendBytesTag(ExpressionReferenceWire.OUTPUT_NAMES_WIRE, 0);
                }
            }
        }
        if (self.expression) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionReferenceWire.EXPRESSION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.measure) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionReferenceWire.MEASURE_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ExpressionReferenceReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _output_names: ?std.ArrayList([]const u8) = null,
    _expression_buf: ?[]const u8 = null,
    _measure_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionReferenceReader {
        var buf = gremlin.Reader.init(src);
        var res = ExpressionReferenceReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ExpressionReferenceWire.OUTPUT_NAMES_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._output_names == null) {
                        res._output_names = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._output_names.?.append(result.value);
                },
                ExpressionReferenceWire.EXPRESSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._expression_buf = result.value;
                },
                ExpressionReferenceWire.MEASURE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._measure_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const ExpressionReferenceReader) void {
        if (self._output_names) |arr| {
            arr.deinit();
        }
    }
    pub fn getOutputNames(self: *const ExpressionReferenceReader) []const []const u8 {
        if (self._output_names) |arr| {
            return arr.items;
        }
        return &[_][]u8{};
    }
    pub fn getExpression(self: *const ExpressionReferenceReader, allocator: std.mem.Allocator) gremlin.Error!algebra.ExpressionReader {
        if (self._expression_buf) |buf| {
            return try algebra.ExpressionReader.init(allocator, buf);
        }
        return try algebra.ExpressionReader.init(allocator, &[_]u8{});
    }
    pub fn getMeasure(self: *const ExpressionReferenceReader, allocator: std.mem.Allocator) gremlin.Error!algebra.AggregateFunctionReader {
        if (self._measure_buf) |buf| {
            return try algebra.AggregateFunctionReader.init(allocator, buf);
        }
        return try algebra.AggregateFunctionReader.init(allocator, &[_]u8{});
    }
};

const ExtendedExpressionWire = struct {
    const VERSION_WIRE: gremlin.ProtoWireNumber = 7;
    const EXTENSION_URIS_WIRE: gremlin.ProtoWireNumber = 1;
    const EXTENSIONS_WIRE: gremlin.ProtoWireNumber = 2;
    const REFERRED_EXPR_WIRE: gremlin.ProtoWireNumber = 3;
    const BASE_SCHEMA_WIRE: gremlin.ProtoWireNumber = 4;
    const ADVANCED_EXTENSIONS_WIRE: gremlin.ProtoWireNumber = 5;
    const EXPECTED_TYPE_URLS_WIRE: gremlin.ProtoWireNumber = 6;
};

pub const ExtendedExpression = struct {
    // fields
    version: ?plan.Version = null,
    extension_uris: ?[]const ?extensions.SimpleExtensionURI = null,
    extensions: ?[]const ?extensions.SimpleExtensionDeclaration = null,
    referred_expr: ?[]const ?ExpressionReference = null,
    base_schema: ?type.NamedStruct = null,
    advanced_extensions: ?extensions.AdvancedExtension = null,
    expected_type_urls: ?[]const ?[]const u8 = null,

    pub fn calcProtobufSize(self: *const ExtendedExpression) usize {
        var res: usize = 0;
        if (self.version) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExtendedExpressionWire.VERSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.extension_uris) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(ExtendedExpressionWire.EXTENSION_URIS_WIRE);
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
                res += gremlin.sizes.sizeWireNumber(ExtendedExpressionWire.EXTENSIONS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.referred_expr) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(ExtendedExpressionWire.REFERRED_EXPR_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.base_schema) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExtendedExpressionWire.BASE_SCHEMA_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.advanced_extensions) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExtendedExpressionWire.ADVANCED_EXTENSIONS_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.expected_type_urls) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(ExtendedExpressionWire.EXPECTED_TYPE_URLS_WIRE);
                if (maybe_v) |v| {
                    res += gremlin.sizes.sizeUsize(v.len) + v.len;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        return res;
    }

    pub fn encode(self: *const ExtendedExpression, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ExtendedExpression, target: *gremlin.Writer) void {
        if (self.version) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExtendedExpressionWire.VERSION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.extension_uris) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ExtendedExpressionWire.EXTENSION_URIS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(ExtendedExpressionWire.EXTENSION_URIS_WIRE, 0);
                }
            }
        }
        if (self.extensions) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ExtendedExpressionWire.EXTENSIONS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(ExtendedExpressionWire.EXTENSIONS_WIRE, 0);
                }
            }
        }
        if (self.referred_expr) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ExtendedExpressionWire.REFERRED_EXPR_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(ExtendedExpressionWire.REFERRED_EXPR_WIRE, 0);
                }
            }
        }
        if (self.base_schema) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExtendedExpressionWire.BASE_SCHEMA_WIRE, size);
            v.encodeTo(target);
        }
        if (self.advanced_extensions) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExtendedExpressionWire.ADVANCED_EXTENSIONS_WIRE, size);
            v.encodeTo(target);
        }
        if (self.expected_type_urls) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    target.appendBytes(ExtendedExpressionWire.EXPECTED_TYPE_URLS_WIRE, v);
                } else {
                    target.appendBytesTag(ExtendedExpressionWire.EXPECTED_TYPE_URLS_WIRE, 0);
                }
            }
        }
    }
};

pub const ExtendedExpressionReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _version_buf: ?[]const u8 = null,
    _extension_uris_bufs: ?std.ArrayList([]const u8) = null,
    _extensions_bufs: ?std.ArrayList([]const u8) = null,
    _referred_expr_bufs: ?std.ArrayList([]const u8) = null,
    _base_schema_buf: ?[]const u8 = null,
    _advanced_extensions_buf: ?[]const u8 = null,
    _expected_type_urls: ?std.ArrayList([]const u8) = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ExtendedExpressionReader {
        var buf = gremlin.Reader.init(src);
        var res = ExtendedExpressionReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ExtendedExpressionWire.VERSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._version_buf = result.value;
                },
                ExtendedExpressionWire.EXTENSION_URIS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._extension_uris_bufs == null) {
                        res._extension_uris_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._extension_uris_bufs.?.append(result.value);
                },
                ExtendedExpressionWire.EXTENSIONS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._extensions_bufs == null) {
                        res._extensions_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._extensions_bufs.?.append(result.value);
                },
                ExtendedExpressionWire.REFERRED_EXPR_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._referred_expr_bufs == null) {
                        res._referred_expr_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._referred_expr_bufs.?.append(result.value);
                },
                ExtendedExpressionWire.BASE_SCHEMA_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._base_schema_buf = result.value;
                },
                ExtendedExpressionWire.ADVANCED_EXTENSIONS_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extensions_buf = result.value;
                },
                ExtendedExpressionWire.EXPECTED_TYPE_URLS_WIRE => {
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
    pub fn deinit(self: *const ExtendedExpressionReader) void {
        if (self._extension_uris_bufs) |arr| {
            arr.deinit();
        }
        if (self._extensions_bufs) |arr| {
            arr.deinit();
        }
        if (self._referred_expr_bufs) |arr| {
            arr.deinit();
        }
        if (self._expected_type_urls) |arr| {
            arr.deinit();
        }
    }
    pub fn getVersion(self: *const ExtendedExpressionReader, allocator: std.mem.Allocator) gremlin.Error!plan.VersionReader {
        if (self._version_buf) |buf| {
            return try plan.VersionReader.init(allocator, buf);
        }
        return try plan.VersionReader.init(allocator, &[_]u8{});
    }
    pub fn getExtensionUris(self: *const ExtendedExpressionReader, allocator: std.mem.Allocator) gremlin.Error![]extensions.SimpleExtensionURIReader {
        if (self._extension_uris_bufs) |bufs| {
            var result = try std.ArrayList(extensions.SimpleExtensionURIReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try extensions.SimpleExtensionURIReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]extensions.SimpleExtensionURIReader{};
    }
    pub fn getExtensions(self: *const ExtendedExpressionReader, allocator: std.mem.Allocator) gremlin.Error![]extensions.SimpleExtensionDeclarationReader {
        if (self._extensions_bufs) |bufs| {
            var result = try std.ArrayList(extensions.SimpleExtensionDeclarationReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try extensions.SimpleExtensionDeclarationReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]extensions.SimpleExtensionDeclarationReader{};
    }
    pub fn getReferredExpr(self: *const ExtendedExpressionReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReferenceReader {
        if (self._referred_expr_bufs) |bufs| {
            var result = try std.ArrayList(ExpressionReferenceReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try ExpressionReferenceReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]ExpressionReferenceReader{};
    }
    pub fn getBaseSchema(self: *const ExtendedExpressionReader, allocator: std.mem.Allocator) gremlin.Error!type.NamedStructReader {
        if (self._base_schema_buf) |buf| {
            return try type.NamedStructReader.init(allocator, buf);
        }
        return try type.NamedStructReader.init(allocator, &[_]u8{});
    }
    pub fn getAdvancedExtensions(self: *const ExtendedExpressionReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extensions_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
    pub fn getExpectedTypeUrls(self: *const ExtendedExpressionReader) []const []const u8 {
        if (self._expected_type_urls) |arr| {
            return arr.items;
        }
        return &[_][]u8{};
    }
};

