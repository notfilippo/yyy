const std = @import("std");
const batch = @import("../meta/batch.zig");
const datum = @import("../meta//datum.zig");

const Error = error{
    Invalid,
};

pub const Predicate = union(enum) {
    const Self = @This();

    binary: Binary,
    reference: Reference,
    scalar: Scalar,

    pub fn evaluate(self: Self, rb: batch.RecordBatch, allocator: std.mem.Allocator) Error!datum.Datum {
        switch (self) {
            .binary => return self.binary.evaluate(rb, allocator),
            .reference => return self.reference.evaluate(rb, allocator),
            .scalar => return self.scalar.evaluate(rb, allocator),
        }
    }
};

pub const Binary = struct {
    pub const Op = enum {
        eq,
    };

    op: Op,
    left: *const Predicate,
    right: *const Predicate,

    fn evaluate(self: Binary, rb: batch.RecordBatch, allocator: std.mem.Allocator) Error!datum.Datum {
        const left = try self.left.evaluate(rb, allocator);
        const right = try self.right.evaluate(rb, allocator);

        switch (self.op) {
            Op.eq => return try datum.eq(left, right, allocator),
        }

        return left;
    }
};

pub const Reference = struct {
    index: usize,

    fn evaluate(self: Reference, rb: batch.RecordBatch, _: std.mem.Allocator) Error!datum.Datum {
        return rb.columns[self.index].datum();
    }
};

pub const Scalar = struct {
    value: datum.Scalar,

    fn evaluate(self: Scalar, _: batch.RecordBatch, _: std.mem.Allocator) Error!datum.Datum {
        return self.value.datum();
    }
};
