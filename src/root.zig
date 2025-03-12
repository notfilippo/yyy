const std = @import("std");
pub const arrow = @import("arrow.zig");

comptime {
    std.testing.refAllDeclsRecursive(@This());
}

test "test" {
    const pb_encode = @cImport({
        @cInclude("pb_encode.h");
    });
    const plan = @cImport({
        @cInclude("substrait/plan.pb.h");
    });

    const plan_obj = plan.substrait_Plan_t{
        .has_version = true,
        .version = .{
            .major_number = 1234,
        },
    };

    var buffer: [1024 * 10]u8 = undefined;
    @memset(&buffer, 0);

    var stream = pb_encode.pb_ostream_from_buffer(buffer[0..], 1024 * 10);
    const result = pb_encode.pb_encode(&stream, @ptrCast(plan.SUBSTRAIT_PLAN_FIELDS), &plan_obj);

    std.debug.print("{b}\n", .{buffer});
    std.debug.print("{d}\n", .{stream.bytes_written});
    std.debug.print("{any}\n", .{plan_obj});

    try std.testing.expect(result);
}
