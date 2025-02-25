const schema = @import("schema.zig");
const datum = @import("datum.zig");

pub const RecordBatch = struct {
    const Self = @This();

    schema: schema.Schema,
    columns: []const datum.Array,
};
