const std = @import("std");
const gremlin = @import("gremlin");

// structs
pub const Empty = struct {

    pub fn calcProtobufSize(_: *const Empty) usize { return 0; }
    

    pub fn encode(self: *const Empty, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(_: *const Empty, _: *gremlin.Writer) void {}
    
};

pub const EmptyReader = struct {

    pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!EmptyReader {
        return EmptyReader{};
    }
    pub fn deinit(_: *const EmptyReader) void { }
    
};

