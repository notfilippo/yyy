const std = @import("std");
const gremlin = @import("gremlin");

// structs
const AnyWire = struct {
    const TYPE_URL_WIRE: gremlin.ProtoWireNumber = 1;
    const VALUE_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const Any = struct {
    // fields
    type_url: ?[]const u8 = null,
    value: ?[]const u8 = null,

    pub fn calcProtobufSize(self: *const Any) usize {
        var res: usize = 0;
        if (self.type_url) |v| { res += gremlin.sizes.sizeWireNumber(AnyWire.TYPE_URL_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
        if (self.value) |v| { res += gremlin.sizes.sizeWireNumber(AnyWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
        return res;
    }

    pub fn encode(self: *const Any, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const Any, target: *gremlin.Writer) void {
        if (self.type_url) |v| { target.appendBytes(AnyWire.TYPE_URL_WIRE, v); }
        if (self.value) |v| { target.appendBytes(AnyWire.VALUE_WIRE, v); }
    }
};

pub const AnyReader = struct {
    _type_url: ?[]const u8 = null,
    _value: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!AnyReader {
        var buf = gremlin.Reader.init(src);
        var res = AnyReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                AnyWire.TYPE_URL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._type_url = result.value;
                },
                AnyWire.VALUE_WIRE => {
                  const result = try buf.readBytes(offset);
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
    pub fn deinit(_: *const AnyReader) void { }
    
    pub inline fn getTypeUrl(self: *const AnyReader) []const u8 { return self._type_url orelse &[_]u8{}; }
    pub inline fn getValue(self: *const AnyReader) []const u8 { return self._value orelse &[_]u8{}; }
};

