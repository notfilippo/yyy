const std = @import("std");
pub const arrow = @import("arrow.zig");

comptime {
    std.testing.refAllDeclsRecursive(@This());
}

test "test" {
    const c = @cImport({
        @cInclude("nanopb/pb.h");
    });
}
