const std = @import("std");
const predicate = @import("predicate.zig");
const schema = @import("../meta/schema.zig");
const batch = @import("../meta/batch.zig");

pub const Relation = union(enum) {
    const Self = @This();

    filter: Filter,
    project: Project,
    read: Read,

    pub const Error = std.mem.Allocator.Error || error{};

    fn execute(self: Self, rb: batch.RecordBatch, allocator: std.mem.Allocator) Relation.Error!?batch.RecordBatch {
        switch (self) {
            .filter => return self.filter.execute(rb, allocator),
            .project => return self.project.execute(rb, allocator),
            .read => return self.read.execute(rb, allocator),
        }
    }
};

pub const Filter = struct {
    input: *const Relation,
    predicate: predicate.Predicate,

    fn execute(self: Filter, rb: batch.RecordBatch, allocator: std.mem.Allocator) Relation.Error!?batch.RecordBatch {
        const input = try self.input.execute(rb, allocator);
        const result = try self.predicate.evaluate(rb, allocator);
        std.debug.print("{any}\n", .{result});
        result.deinit();
        return input;
    }
};

const Project = struct {
    input: *const Relation,
    projection: []predicate.Predicate,

    fn execute(self: Project, rb: batch.RecordBatch, allocator: std.mem.Allocator) Relation.Error!?batch.RecordBatch {
        const input = try self.input.execute(rb, allocator);
        return input;
    }
};

const Read = struct {
    fn execute(_: Read, rb: batch.RecordBatch, _: std.mem.Allocator) Relation.Error!?batch.RecordBatch {
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
        .columns = &.{.{ .i32 = input }},
        .rows = input.len(),
    }, testing.allocator);

    std.debug.print("{any}\n", .{result});
}
