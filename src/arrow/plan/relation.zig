const std = @import("std");
const predicate = @import("predicate.zig");
const schema = @import("../meta/schema.zig");
const batch = @import("../meta/batch.zig");

const Error = error{
    Invalid,
};

pub const Relation = union(enum) {
    const Self = @This();

    filter: Filter,
    project: Project,
    read: Read,

    fn execute(self: Self, rb: batch.RecordBatch) !?batch.RecordBatch {
        switch (self) {
            .filter => return self.filter.execute(rb),
            .project => return self.project.execute(rb),
            .read => return self.read.execute(rb),
        }
    }
};

pub const Filter = struct {
    input: *const Relation,
    predicate: predicate.Predicate,

    fn execute(self: Filter, rb: batch.RecordBatch) Error!?batch.RecordBatch {
        const input = try self.input.execute(rb);
        const result = try self.predicate.evaluate(rb, std.heap.page_allocator);
        std.debug.print("{any}", .{result});
        return input;
    }
};

const Project = struct {
    input: *const Relation,
    projection: []predicate.Predicate,

    fn execute(self: Project, rb: batch.RecordBatch) Error!?batch.RecordBatch {
        const input = try self.input.execute(rb);
        return input;
    }
};

const Read = struct {
    fn execute(_: Read, rb: batch.RecordBatch) Error!?batch.RecordBatch {
        return rb;
    }
};

test "relation" {
    const PrimitiveArray = @import("../array/primitive.zig").PrimitiveArray;
    const Scalar = @import("../meta/datum.zig").Scalar;
    const testing = std.testing;

    const scalar: i32 = 6;

    const plan = Relation{
        .filter = .{
            .input = &Relation{ .read = .{} },
            .predicate = predicate.Predicate{
                .binary = .{
                    .left = &predicate.Predicate{ .reference = .{ .index = 0 } },
                    .right = &predicate.Predicate{ .scalar = .{ .value = Scalar{ .i32 = scalar } } },
                    .op = predicate.Binary.Op.eq,
                },
            },
        },
    };

    const input = try PrimitiveArray(i32).fromSlice(&[_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, testing.allocator);
    defer input.deinit();

    const result = try plan.execute(batch.RecordBatch{
        .schema = schema.Schema{
            .fields = &.{
                .{
                    .name = "foo",
                    .dt = schema.DataType.i32,
                },
            },
        },
        .columns = &.{.{ .inner = @constCast(&input), .dt = schema.DataType.i32 }},
    });

    std.debug.print("{any}", .{result});
}
