const std = @import("std");
const gremlin = @import("gremlin");
const type_expressions = @import("type_expressions.proto.zig");
const type = @import("type.proto.zig");
const parameterized_types = @import("parameterized_types.proto.zig");

// structs
pub const FunctionSignature = struct {
    // nested structs
    const FinalArgVariadicWire = struct {
        const MIN_ARGS_WIRE: gremlin.ProtoWireNumber = 1;
        const MAX_ARGS_WIRE: gremlin.ProtoWireNumber = 2;
        const CONSISTENCY_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const FinalArgVariadic = struct {
        // nested enums
        pub const ParameterConsistency = enum(i32) {
            PARAMETER_CONSISTENCY_UNSPECIFIED = 0,
            PARAMETER_CONSISTENCY_CONSISTENT = 1,
            PARAMETER_CONSISTENCY_INCONSISTENT = 2,
        };
        
        // fields
        min_args: i64 = 0,
        max_args: i64 = 0,
        consistency: FunctionSignature.FinalArgVariadic.ParameterConsistency = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const FinalArgVariadic) usize {
            var res: usize = 0;
            if (self.min_args != 0) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.FinalArgVariadicWire.MIN_ARGS_WIRE) + gremlin.sizes.sizeI64(self.min_args); }
            if (self.max_args != 0) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.FinalArgVariadicWire.MAX_ARGS_WIRE) + gremlin.sizes.sizeI64(self.max_args); }
            if (@intFromEnum(self.consistency) != 0) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.FinalArgVariadicWire.CONSISTENCY_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.consistency)); }
            return res;
        }

        pub fn encode(self: *const FinalArgVariadic, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const FinalArgVariadic, target: *gremlin.Writer) void {
            if (self.min_args != 0) { target.appendInt64(FunctionSignature.FinalArgVariadicWire.MIN_ARGS_WIRE, self.min_args); }
            if (self.max_args != 0) { target.appendInt64(FunctionSignature.FinalArgVariadicWire.MAX_ARGS_WIRE, self.max_args); }
            if (@intFromEnum(self.consistency) != 0) { target.appendInt32(FunctionSignature.FinalArgVariadicWire.CONSISTENCY_WIRE, @intFromEnum(self.consistency)); }
        }
    };
    
    pub const FinalArgVariadicReader = struct {
        _min_args: i64 = 0,
        _max_args: i64 = 0,
        _consistency: FunctionSignature.FinalArgVariadic.ParameterConsistency = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!FinalArgVariadicReader {
            var buf = gremlin.Reader.init(src);
            var res = FinalArgVariadicReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    FunctionSignature.FinalArgVariadicWire.MIN_ARGS_WIRE => {
                      const result = try buf.readInt64(offset);
                      offset += result.size;
                      res._min_args = result.value;
                    },
                    FunctionSignature.FinalArgVariadicWire.MAX_ARGS_WIRE => {
                      const result = try buf.readInt64(offset);
                      offset += result.size;
                      res._max_args = result.value;
                    },
                    FunctionSignature.FinalArgVariadicWire.CONSISTENCY_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._consistency = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const FinalArgVariadicReader) void { }
        
        pub inline fn getMinArgs(self: *const FinalArgVariadicReader) i64 { return self._min_args; }
        pub inline fn getMaxArgs(self: *const FinalArgVariadicReader) i64 { return self._max_args; }
        pub inline fn getConsistency(self: *const FinalArgVariadicReader) FunctionSignature.FinalArgVariadic.ParameterConsistency { return self._consistency; }
    };
    
    pub const FinalArgNormal = struct {

        pub fn calcProtobufSize(_: *const FinalArgNormal) usize { return 0; }
        

        pub fn encode(self: *const FinalArgNormal, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(_: *const FinalArgNormal, _: *gremlin.Writer) void {}
        
    };
    
    pub const FinalArgNormalReader = struct {

        pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!FinalArgNormalReader {
            return FinalArgNormalReader{};
        }
        pub fn deinit(_: *const FinalArgNormalReader) void { }
        
    };
    
    const ScalarWire = struct {
        const ARGUMENTS_WIRE: gremlin.ProtoWireNumber = 2;
        const NAME_WIRE: gremlin.ProtoWireNumber = 3;
        const DESCRIPTION_WIRE: gremlin.ProtoWireNumber = 4;
        const DETERMINISTIC_WIRE: gremlin.ProtoWireNumber = 7;
        const SESSION_DEPENDENT_WIRE: gremlin.ProtoWireNumber = 8;
        const OUTPUT_TYPE_WIRE: gremlin.ProtoWireNumber = 9;
        const IMPLEMENTATIONS_WIRE: gremlin.ProtoWireNumber = 12;
        const VARIADIC_WIRE: gremlin.ProtoWireNumber = 10;
        const NORMAL_WIRE: gremlin.ProtoWireNumber = 11;
    };
    
    pub const Scalar = struct {
        // fields
        arguments: ?[]const ?FunctionSignature.Argument = null,
        name: ?[]const ?[]const u8 = null,
        description: ?FunctionSignature.Description = null,
        deterministic: bool = false,
        session_dependent: bool = false,
        output_type: ?type_expressions.DerivationExpression = null,
        implementations: ?[]const ?FunctionSignature.Implementation = null,
        variadic: ?FunctionSignature.FinalArgVariadic = null,
        normal: ?FunctionSignature.FinalArgNormal = null,

        pub fn calcProtobufSize(self: *const Scalar) usize {
            var res: usize = 0;
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(FunctionSignature.ScalarWire.ARGUMENTS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.name) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(FunctionSignature.ScalarWire.NAME_WIRE);
                    if (maybe_v) |v| {
                        res += gremlin.sizes.sizeUsize(v.len) + v.len;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.description) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.ScalarWire.DESCRIPTION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.deterministic != false) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.ScalarWire.DETERMINISTIC_WIRE) + gremlin.sizes.sizeBool(self.deterministic); }
            if (self.session_dependent != false) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.ScalarWire.SESSION_DEPENDENT_WIRE) + gremlin.sizes.sizeBool(self.session_dependent); }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.ScalarWire.OUTPUT_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.implementations) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(FunctionSignature.ScalarWire.IMPLEMENTATIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.variadic) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.ScalarWire.VARIADIC_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.normal) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.ScalarWire.NORMAL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const Scalar, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Scalar, target: *gremlin.Writer) void {
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(FunctionSignature.ScalarWire.ARGUMENTS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(FunctionSignature.ScalarWire.ARGUMENTS_WIRE, 0);
                    }
                }
            }
            if (self.name) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        target.appendBytes(FunctionSignature.ScalarWire.NAME_WIRE, v);
                    } else {
                        target.appendBytesTag(FunctionSignature.ScalarWire.NAME_WIRE, 0);
                    }
                }
            }
            if (self.description) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.ScalarWire.DESCRIPTION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.deterministic != false) { target.appendBool(FunctionSignature.ScalarWire.DETERMINISTIC_WIRE, self.deterministic); }
            if (self.session_dependent != false) { target.appendBool(FunctionSignature.ScalarWire.SESSION_DEPENDENT_WIRE, self.session_dependent); }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.ScalarWire.OUTPUT_TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.implementations) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(FunctionSignature.ScalarWire.IMPLEMENTATIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(FunctionSignature.ScalarWire.IMPLEMENTATIONS_WIRE, 0);
                    }
                }
            }
            if (self.variadic) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.ScalarWire.VARIADIC_WIRE, size);
                v.encodeTo(target);
            }
            if (self.normal) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.ScalarWire.NORMAL_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const ScalarReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _arguments_bufs: ?std.ArrayList([]const u8) = null,
        _name: ?std.ArrayList([]const u8) = null,
        _description_buf: ?[]const u8 = null,
        _deterministic: bool = false,
        _session_dependent: bool = false,
        _output_type_buf: ?[]const u8 = null,
        _implementations_bufs: ?std.ArrayList([]const u8) = null,
        _variadic_buf: ?[]const u8 = null,
        _normal_buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ScalarReader {
            var buf = gremlin.Reader.init(src);
            var res = ScalarReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    FunctionSignature.ScalarWire.ARGUMENTS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._arguments_bufs == null) {
                            res._arguments_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._arguments_bufs.?.append(result.value);
                    },
                    FunctionSignature.ScalarWire.NAME_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._name == null) {
                            res._name = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._name.?.append(result.value);
                    },
                    FunctionSignature.ScalarWire.DESCRIPTION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._description_buf = result.value;
                    },
                    FunctionSignature.ScalarWire.DETERMINISTIC_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._deterministic = result.value;
                    },
                    FunctionSignature.ScalarWire.SESSION_DEPENDENT_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._session_dependent = result.value;
                    },
                    FunctionSignature.ScalarWire.OUTPUT_TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._output_type_buf = result.value;
                    },
                    FunctionSignature.ScalarWire.IMPLEMENTATIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._implementations_bufs == null) {
                            res._implementations_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._implementations_bufs.?.append(result.value);
                    },
                    FunctionSignature.ScalarWire.VARIADIC_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._variadic_buf = result.value;
                    },
                    FunctionSignature.ScalarWire.NORMAL_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._normal_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const ScalarReader) void {
            if (self._arguments_bufs) |arr| {
                arr.deinit();
            }
            if (self._name) |arr| {
                arr.deinit();
            }
            if (self._implementations_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getArguments(self: *const ScalarReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionSignature.ArgumentReader {
            if (self._arguments_bufs) |bufs| {
                var result = try std.ArrayList(FunctionSignature.ArgumentReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionSignature.ArgumentReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionSignature.ArgumentReader{};
        }
        pub fn getName(self: *const ScalarReader) []const []const u8 {
            if (self._name) |arr| {
                return arr.items;
            }
            return &[_][]u8{};
        }
        pub fn getDescription(self: *const ScalarReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.DescriptionReader {
            if (self._description_buf) |buf| {
                return try FunctionSignature.DescriptionReader.init(allocator, buf);
            }
            return try FunctionSignature.DescriptionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getDeterministic(self: *const ScalarReader) bool { return self._deterministic; }
        pub inline fn getSessionDependent(self: *const ScalarReader) bool { return self._session_dependent; }
        pub fn getOutputType(self: *const ScalarReader, allocator: std.mem.Allocator) gremlin.Error!type_expressions.DerivationExpressionReader {
            if (self._output_type_buf) |buf| {
                return try type_expressions.DerivationExpressionReader.init(allocator, buf);
            }
            return try type_expressions.DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub fn getImplementations(self: *const ScalarReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionSignature.ImplementationReader {
            if (self._implementations_bufs) |bufs| {
                var result = try std.ArrayList(FunctionSignature.ImplementationReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionSignature.ImplementationReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionSignature.ImplementationReader{};
        }
        pub fn getVariadic(self: *const ScalarReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.FinalArgVariadicReader {
            if (self._variadic_buf) |buf| {
                return try FunctionSignature.FinalArgVariadicReader.init(allocator, buf);
            }
            return try FunctionSignature.FinalArgVariadicReader.init(allocator, &[_]u8{});
        }
        pub fn getNormal(self: *const ScalarReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.FinalArgNormalReader {
            if (self._normal_buf) |buf| {
                return try FunctionSignature.FinalArgNormalReader.init(allocator, buf);
            }
            return try FunctionSignature.FinalArgNormalReader.init(allocator, &[_]u8{});
        }
    };
    
    const AggregateWire = struct {
        const ARGUMENTS_WIRE: gremlin.ProtoWireNumber = 2;
        const NAME_WIRE: gremlin.ProtoWireNumber = 3;
        const DESCRIPTION_WIRE: gremlin.ProtoWireNumber = 4;
        const DETERMINISTIC_WIRE: gremlin.ProtoWireNumber = 7;
        const SESSION_DEPENDENT_WIRE: gremlin.ProtoWireNumber = 8;
        const OUTPUT_TYPE_WIRE: gremlin.ProtoWireNumber = 9;
        const ORDERED_WIRE: gremlin.ProtoWireNumber = 14;
        const MAX_SET_WIRE: gremlin.ProtoWireNumber = 12;
        const INTERMEDIATE_TYPE_WIRE: gremlin.ProtoWireNumber = 13;
        const IMPLEMENTATIONS_WIRE: gremlin.ProtoWireNumber = 15;
        const VARIADIC_WIRE: gremlin.ProtoWireNumber = 10;
        const NORMAL_WIRE: gremlin.ProtoWireNumber = 11;
    };
    
    pub const Aggregate = struct {
        // fields
        arguments: ?[]const ?FunctionSignature.Argument = null,
        name: ?[]const u8 = null,
        description: ?FunctionSignature.Description = null,
        deterministic: bool = false,
        session_dependent: bool = false,
        output_type: ?type_expressions.DerivationExpression = null,
        ordered: bool = false,
        max_set: u64 = 0,
        intermediate_type: ?type.Type = null,
        implementations: ?[]const ?FunctionSignature.Implementation = null,
        variadic: ?FunctionSignature.FinalArgVariadic = null,
        normal: ?FunctionSignature.FinalArgNormal = null,

        pub fn calcProtobufSize(self: *const Aggregate) usize {
            var res: usize = 0;
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.ARGUMENTS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.name) |v| { res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.NAME_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.description) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.DESCRIPTION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.deterministic != false) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.DETERMINISTIC_WIRE) + gremlin.sizes.sizeBool(self.deterministic); }
            if (self.session_dependent != false) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.SESSION_DEPENDENT_WIRE) + gremlin.sizes.sizeBool(self.session_dependent); }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.OUTPUT_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.ordered != false) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.ORDERED_WIRE) + gremlin.sizes.sizeBool(self.ordered); }
            if (self.max_set != 0) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.MAX_SET_WIRE) + gremlin.sizes.sizeU64(self.max_set); }
            if (self.intermediate_type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.INTERMEDIATE_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.implementations) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.IMPLEMENTATIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.variadic) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.VARIADIC_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.normal) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.AggregateWire.NORMAL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const Aggregate, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Aggregate, target: *gremlin.Writer) void {
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(FunctionSignature.AggregateWire.ARGUMENTS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(FunctionSignature.AggregateWire.ARGUMENTS_WIRE, 0);
                    }
                }
            }
            if (self.name) |v| { target.appendBytes(FunctionSignature.AggregateWire.NAME_WIRE, v); }
            if (self.description) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.AggregateWire.DESCRIPTION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.deterministic != false) { target.appendBool(FunctionSignature.AggregateWire.DETERMINISTIC_WIRE, self.deterministic); }
            if (self.session_dependent != false) { target.appendBool(FunctionSignature.AggregateWire.SESSION_DEPENDENT_WIRE, self.session_dependent); }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.AggregateWire.OUTPUT_TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.ordered != false) { target.appendBool(FunctionSignature.AggregateWire.ORDERED_WIRE, self.ordered); }
            if (self.max_set != 0) { target.appendUint64(FunctionSignature.AggregateWire.MAX_SET_WIRE, self.max_set); }
            if (self.intermediate_type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.AggregateWire.INTERMEDIATE_TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.implementations) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(FunctionSignature.AggregateWire.IMPLEMENTATIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(FunctionSignature.AggregateWire.IMPLEMENTATIONS_WIRE, 0);
                    }
                }
            }
            if (self.variadic) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.AggregateWire.VARIADIC_WIRE, size);
                v.encodeTo(target);
            }
            if (self.normal) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.AggregateWire.NORMAL_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const AggregateReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _arguments_bufs: ?std.ArrayList([]const u8) = null,
        _name: ?[]const u8 = null,
        _description_buf: ?[]const u8 = null,
        _deterministic: bool = false,
        _session_dependent: bool = false,
        _output_type_buf: ?[]const u8 = null,
        _ordered: bool = false,
        _max_set: u64 = 0,
        _intermediate_type_buf: ?[]const u8 = null,
        _implementations_bufs: ?std.ArrayList([]const u8) = null,
        _variadic_buf: ?[]const u8 = null,
        _normal_buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!AggregateReader {
            var buf = gremlin.Reader.init(src);
            var res = AggregateReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    FunctionSignature.AggregateWire.ARGUMENTS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._arguments_bufs == null) {
                            res._arguments_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._arguments_bufs.?.append(result.value);
                    },
                    FunctionSignature.AggregateWire.NAME_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._name = result.value;
                    },
                    FunctionSignature.AggregateWire.DESCRIPTION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._description_buf = result.value;
                    },
                    FunctionSignature.AggregateWire.DETERMINISTIC_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._deterministic = result.value;
                    },
                    FunctionSignature.AggregateWire.SESSION_DEPENDENT_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._session_dependent = result.value;
                    },
                    FunctionSignature.AggregateWire.OUTPUT_TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._output_type_buf = result.value;
                    },
                    FunctionSignature.AggregateWire.ORDERED_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._ordered = result.value;
                    },
                    FunctionSignature.AggregateWire.MAX_SET_WIRE => {
                      const result = try buf.readUInt64(offset);
                      offset += result.size;
                      res._max_set = result.value;
                    },
                    FunctionSignature.AggregateWire.INTERMEDIATE_TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._intermediate_type_buf = result.value;
                    },
                    FunctionSignature.AggregateWire.IMPLEMENTATIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._implementations_bufs == null) {
                            res._implementations_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._implementations_bufs.?.append(result.value);
                    },
                    FunctionSignature.AggregateWire.VARIADIC_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._variadic_buf = result.value;
                    },
                    FunctionSignature.AggregateWire.NORMAL_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._normal_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const AggregateReader) void {
            if (self._arguments_bufs) |arr| {
                arr.deinit();
            }
            if (self._implementations_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getArguments(self: *const AggregateReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionSignature.ArgumentReader {
            if (self._arguments_bufs) |bufs| {
                var result = try std.ArrayList(FunctionSignature.ArgumentReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionSignature.ArgumentReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionSignature.ArgumentReader{};
        }
        pub inline fn getName(self: *const AggregateReader) []const u8 { return self._name orelse &[_]u8{}; }
        pub fn getDescription(self: *const AggregateReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.DescriptionReader {
            if (self._description_buf) |buf| {
                return try FunctionSignature.DescriptionReader.init(allocator, buf);
            }
            return try FunctionSignature.DescriptionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getDeterministic(self: *const AggregateReader) bool { return self._deterministic; }
        pub inline fn getSessionDependent(self: *const AggregateReader) bool { return self._session_dependent; }
        pub fn getOutputType(self: *const AggregateReader, allocator: std.mem.Allocator) gremlin.Error!type_expressions.DerivationExpressionReader {
            if (self._output_type_buf) |buf| {
                return try type_expressions.DerivationExpressionReader.init(allocator, buf);
            }
            return try type_expressions.DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getOrdered(self: *const AggregateReader) bool { return self._ordered; }
        pub inline fn getMaxSet(self: *const AggregateReader) u64 { return self._max_set; }
        pub fn getIntermediateType(self: *const AggregateReader, allocator: std.mem.Allocator) gremlin.Error!type.TypeReader {
            if (self._intermediate_type_buf) |buf| {
                return try type.TypeReader.init(allocator, buf);
            }
            return try type.TypeReader.init(allocator, &[_]u8{});
        }
        pub fn getImplementations(self: *const AggregateReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionSignature.ImplementationReader {
            if (self._implementations_bufs) |bufs| {
                var result = try std.ArrayList(FunctionSignature.ImplementationReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionSignature.ImplementationReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionSignature.ImplementationReader{};
        }
        pub fn getVariadic(self: *const AggregateReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.FinalArgVariadicReader {
            if (self._variadic_buf) |buf| {
                return try FunctionSignature.FinalArgVariadicReader.init(allocator, buf);
            }
            return try FunctionSignature.FinalArgVariadicReader.init(allocator, &[_]u8{});
        }
        pub fn getNormal(self: *const AggregateReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.FinalArgNormalReader {
            if (self._normal_buf) |buf| {
                return try FunctionSignature.FinalArgNormalReader.init(allocator, buf);
            }
            return try FunctionSignature.FinalArgNormalReader.init(allocator, &[_]u8{});
        }
    };
    
    const WindowWire = struct {
        const ARGUMENTS_WIRE: gremlin.ProtoWireNumber = 2;
        const NAME_WIRE: gremlin.ProtoWireNumber = 3;
        const DESCRIPTION_WIRE: gremlin.ProtoWireNumber = 4;
        const DETERMINISTIC_WIRE: gremlin.ProtoWireNumber = 7;
        const SESSION_DEPENDENT_WIRE: gremlin.ProtoWireNumber = 8;
        const INTERMEDIATE_TYPE_WIRE: gremlin.ProtoWireNumber = 9;
        const OUTPUT_TYPE_WIRE: gremlin.ProtoWireNumber = 10;
        const ORDERED_WIRE: gremlin.ProtoWireNumber = 11;
        const MAX_SET_WIRE: gremlin.ProtoWireNumber = 12;
        const WINDOW_TYPE_WIRE: gremlin.ProtoWireNumber = 14;
        const IMPLEMENTATIONS_WIRE: gremlin.ProtoWireNumber = 15;
        const VARIADIC_WIRE: gremlin.ProtoWireNumber = 16;
        const NORMAL_WIRE: gremlin.ProtoWireNumber = 17;
    };
    
    pub const Window = struct {
        // nested enums
        pub const WindowType = enum(i32) {
            WINDOW_TYPE_UNSPECIFIED = 0,
            WINDOW_TYPE_STREAMING = 1,
            WINDOW_TYPE_PARTITION = 2,
        };
        
        // fields
        arguments: ?[]const ?FunctionSignature.Argument = null,
        name: ?[]const ?[]const u8 = null,
        description: ?FunctionSignature.Description = null,
        deterministic: bool = false,
        session_dependent: bool = false,
        intermediate_type: ?type_expressions.DerivationExpression = null,
        output_type: ?type_expressions.DerivationExpression = null,
        ordered: bool = false,
        max_set: u64 = 0,
        window_type: FunctionSignature.Window.WindowType = @enumFromInt(0),
        implementations: ?[]const ?FunctionSignature.Implementation = null,
        variadic: ?FunctionSignature.FinalArgVariadic = null,
        normal: ?FunctionSignature.FinalArgNormal = null,

        pub fn calcProtobufSize(self: *const Window) usize {
            var res: usize = 0;
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.ARGUMENTS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.name) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.NAME_WIRE);
                    if (maybe_v) |v| {
                        res += gremlin.sizes.sizeUsize(v.len) + v.len;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.description) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.DESCRIPTION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.deterministic != false) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.DETERMINISTIC_WIRE) + gremlin.sizes.sizeBool(self.deterministic); }
            if (self.session_dependent != false) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.SESSION_DEPENDENT_WIRE) + gremlin.sizes.sizeBool(self.session_dependent); }
            if (self.intermediate_type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.INTERMEDIATE_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.OUTPUT_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.ordered != false) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.ORDERED_WIRE) + gremlin.sizes.sizeBool(self.ordered); }
            if (self.max_set != 0) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.MAX_SET_WIRE) + gremlin.sizes.sizeU64(self.max_set); }
            if (@intFromEnum(self.window_type) != 0) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.WINDOW_TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.window_type)); }
            if (self.implementations) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.IMPLEMENTATIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.variadic) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.VARIADIC_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.normal) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.WindowWire.NORMAL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const Window, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Window, target: *gremlin.Writer) void {
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(FunctionSignature.WindowWire.ARGUMENTS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(FunctionSignature.WindowWire.ARGUMENTS_WIRE, 0);
                    }
                }
            }
            if (self.name) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        target.appendBytes(FunctionSignature.WindowWire.NAME_WIRE, v);
                    } else {
                        target.appendBytesTag(FunctionSignature.WindowWire.NAME_WIRE, 0);
                    }
                }
            }
            if (self.description) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.WindowWire.DESCRIPTION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.deterministic != false) { target.appendBool(FunctionSignature.WindowWire.DETERMINISTIC_WIRE, self.deterministic); }
            if (self.session_dependent != false) { target.appendBool(FunctionSignature.WindowWire.SESSION_DEPENDENT_WIRE, self.session_dependent); }
            if (self.intermediate_type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.WindowWire.INTERMEDIATE_TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.WindowWire.OUTPUT_TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.ordered != false) { target.appendBool(FunctionSignature.WindowWire.ORDERED_WIRE, self.ordered); }
            if (self.max_set != 0) { target.appendUint64(FunctionSignature.WindowWire.MAX_SET_WIRE, self.max_set); }
            if (@intFromEnum(self.window_type) != 0) { target.appendInt32(FunctionSignature.WindowWire.WINDOW_TYPE_WIRE, @intFromEnum(self.window_type)); }
            if (self.implementations) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(FunctionSignature.WindowWire.IMPLEMENTATIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(FunctionSignature.WindowWire.IMPLEMENTATIONS_WIRE, 0);
                    }
                }
            }
            if (self.variadic) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.WindowWire.VARIADIC_WIRE, size);
                v.encodeTo(target);
            }
            if (self.normal) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.WindowWire.NORMAL_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const WindowReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _arguments_bufs: ?std.ArrayList([]const u8) = null,
        _name: ?std.ArrayList([]const u8) = null,
        _description_buf: ?[]const u8 = null,
        _deterministic: bool = false,
        _session_dependent: bool = false,
        _intermediate_type_buf: ?[]const u8 = null,
        _output_type_buf: ?[]const u8 = null,
        _ordered: bool = false,
        _max_set: u64 = 0,
        _window_type: FunctionSignature.Window.WindowType = @enumFromInt(0),
        _implementations_bufs: ?std.ArrayList([]const u8) = null,
        _variadic_buf: ?[]const u8 = null,
        _normal_buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!WindowReader {
            var buf = gremlin.Reader.init(src);
            var res = WindowReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    FunctionSignature.WindowWire.ARGUMENTS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._arguments_bufs == null) {
                            res._arguments_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._arguments_bufs.?.append(result.value);
                    },
                    FunctionSignature.WindowWire.NAME_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._name == null) {
                            res._name = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._name.?.append(result.value);
                    },
                    FunctionSignature.WindowWire.DESCRIPTION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._description_buf = result.value;
                    },
                    FunctionSignature.WindowWire.DETERMINISTIC_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._deterministic = result.value;
                    },
                    FunctionSignature.WindowWire.SESSION_DEPENDENT_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._session_dependent = result.value;
                    },
                    FunctionSignature.WindowWire.INTERMEDIATE_TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._intermediate_type_buf = result.value;
                    },
                    FunctionSignature.WindowWire.OUTPUT_TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._output_type_buf = result.value;
                    },
                    FunctionSignature.WindowWire.ORDERED_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._ordered = result.value;
                    },
                    FunctionSignature.WindowWire.MAX_SET_WIRE => {
                      const result = try buf.readUInt64(offset);
                      offset += result.size;
                      res._max_set = result.value;
                    },
                    FunctionSignature.WindowWire.WINDOW_TYPE_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._window_type = @enumFromInt(result.value);
                    },
                    FunctionSignature.WindowWire.IMPLEMENTATIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._implementations_bufs == null) {
                            res._implementations_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._implementations_bufs.?.append(result.value);
                    },
                    FunctionSignature.WindowWire.VARIADIC_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._variadic_buf = result.value;
                    },
                    FunctionSignature.WindowWire.NORMAL_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._normal_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const WindowReader) void {
            if (self._arguments_bufs) |arr| {
                arr.deinit();
            }
            if (self._name) |arr| {
                arr.deinit();
            }
            if (self._implementations_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getArguments(self: *const WindowReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionSignature.ArgumentReader {
            if (self._arguments_bufs) |bufs| {
                var result = try std.ArrayList(FunctionSignature.ArgumentReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionSignature.ArgumentReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionSignature.ArgumentReader{};
        }
        pub fn getName(self: *const WindowReader) []const []const u8 {
            if (self._name) |arr| {
                return arr.items;
            }
            return &[_][]u8{};
        }
        pub fn getDescription(self: *const WindowReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.DescriptionReader {
            if (self._description_buf) |buf| {
                return try FunctionSignature.DescriptionReader.init(allocator, buf);
            }
            return try FunctionSignature.DescriptionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getDeterministic(self: *const WindowReader) bool { return self._deterministic; }
        pub inline fn getSessionDependent(self: *const WindowReader) bool { return self._session_dependent; }
        pub fn getIntermediateType(self: *const WindowReader, allocator: std.mem.Allocator) gremlin.Error!type_expressions.DerivationExpressionReader {
            if (self._intermediate_type_buf) |buf| {
                return try type_expressions.DerivationExpressionReader.init(allocator, buf);
            }
            return try type_expressions.DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub fn getOutputType(self: *const WindowReader, allocator: std.mem.Allocator) gremlin.Error!type_expressions.DerivationExpressionReader {
            if (self._output_type_buf) |buf| {
                return try type_expressions.DerivationExpressionReader.init(allocator, buf);
            }
            return try type_expressions.DerivationExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getOrdered(self: *const WindowReader) bool { return self._ordered; }
        pub inline fn getMaxSet(self: *const WindowReader) u64 { return self._max_set; }
        pub inline fn getWindowType(self: *const WindowReader) FunctionSignature.Window.WindowType { return self._window_type; }
        pub fn getImplementations(self: *const WindowReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionSignature.ImplementationReader {
            if (self._implementations_bufs) |bufs| {
                var result = try std.ArrayList(FunctionSignature.ImplementationReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionSignature.ImplementationReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionSignature.ImplementationReader{};
        }
        pub fn getVariadic(self: *const WindowReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.FinalArgVariadicReader {
            if (self._variadic_buf) |buf| {
                return try FunctionSignature.FinalArgVariadicReader.init(allocator, buf);
            }
            return try FunctionSignature.FinalArgVariadicReader.init(allocator, &[_]u8{});
        }
        pub fn getNormal(self: *const WindowReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.FinalArgNormalReader {
            if (self._normal_buf) |buf| {
                return try FunctionSignature.FinalArgNormalReader.init(allocator, buf);
            }
            return try FunctionSignature.FinalArgNormalReader.init(allocator, &[_]u8{});
        }
    };
    
    const DescriptionWire = struct {
        const LANGUAGE_WIRE: gremlin.ProtoWireNumber = 1;
        const BODY_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const Description = struct {
        // fields
        language: ?[]const u8 = null,
        body: ?[]const u8 = null,

        pub fn calcProtobufSize(self: *const Description) usize {
            var res: usize = 0;
            if (self.language) |v| { res += gremlin.sizes.sizeWireNumber(FunctionSignature.DescriptionWire.LANGUAGE_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.body) |v| { res += gremlin.sizes.sizeWireNumber(FunctionSignature.DescriptionWire.BODY_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            return res;
        }

        pub fn encode(self: *const Description, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Description, target: *gremlin.Writer) void {
            if (self.language) |v| { target.appendBytes(FunctionSignature.DescriptionWire.LANGUAGE_WIRE, v); }
            if (self.body) |v| { target.appendBytes(FunctionSignature.DescriptionWire.BODY_WIRE, v); }
        }
    };
    
    pub const DescriptionReader = struct {
        _language: ?[]const u8 = null,
        _body: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!DescriptionReader {
            var buf = gremlin.Reader.init(src);
            var res = DescriptionReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    FunctionSignature.DescriptionWire.LANGUAGE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._language = result.value;
                    },
                    FunctionSignature.DescriptionWire.BODY_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._body = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const DescriptionReader) void { }
        
        pub inline fn getLanguage(self: *const DescriptionReader) []const u8 { return self._language orelse &[_]u8{}; }
        pub inline fn getBody(self: *const DescriptionReader) []const u8 { return self._body orelse &[_]u8{}; }
    };
    
    const ImplementationWire = struct {
        const TYPE_WIRE: gremlin.ProtoWireNumber = 1;
        const URI_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const Implementation = struct {
        // nested enums
        pub const Type = enum(i32) {
            TYPE_UNSPECIFIED = 0,
            TYPE_WEB_ASSEMBLY = 1,
            TYPE_TRINO_JAR = 2,
        };
        
        // fields
        type: FunctionSignature.Implementation.Type = @enumFromInt(0),
        uri: ?[]const u8 = null,

        pub fn calcProtobufSize(self: *const Implementation) usize {
            var res: usize = 0;
            if (@intFromEnum(self.type) != 0) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.ImplementationWire.TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.type)); }
            if (self.uri) |v| { res += gremlin.sizes.sizeWireNumber(FunctionSignature.ImplementationWire.URI_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            return res;
        }

        pub fn encode(self: *const Implementation, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Implementation, target: *gremlin.Writer) void {
            if (@intFromEnum(self.type) != 0) { target.appendInt32(FunctionSignature.ImplementationWire.TYPE_WIRE, @intFromEnum(self.type)); }
            if (self.uri) |v| { target.appendBytes(FunctionSignature.ImplementationWire.URI_WIRE, v); }
        }
    };
    
    pub const ImplementationReader = struct {
        _type: FunctionSignature.Implementation.Type = @enumFromInt(0),
        _uri: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ImplementationReader {
            var buf = gremlin.Reader.init(src);
            var res = ImplementationReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    FunctionSignature.ImplementationWire.TYPE_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._type = @enumFromInt(result.value);
                    },
                    FunctionSignature.ImplementationWire.URI_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._uri = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ImplementationReader) void { }
        
        pub inline fn getType(self: *const ImplementationReader) FunctionSignature.Implementation.Type { return self._type; }
        pub inline fn getUri(self: *const ImplementationReader) []const u8 { return self._uri orelse &[_]u8{}; }
    };
    
    const ArgumentWire = struct {
        const NAME_WIRE: gremlin.ProtoWireNumber = 1;
        const VALUE_WIRE: gremlin.ProtoWireNumber = 2;
        const TYPE_WIRE: gremlin.ProtoWireNumber = 3;
        const ENUM_WIRE: gremlin.ProtoWireNumber = 4;
    };
    
    pub const Argument = struct {
        // nested structs
        const ValueArgumentWire = struct {
            const TYPE_WIRE: gremlin.ProtoWireNumber = 1;
            const CONSTANT_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const ValueArgument = struct {
            // fields
            type: ?parameterized_types.ParameterizedType = null,
            constant: bool = false,

            pub fn calcProtobufSize(self: *const ValueArgument) usize {
                var res: usize = 0;
                if (self.type) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(FunctionSignature.Argument.ValueArgumentWire.TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.constant != false) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.Argument.ValueArgumentWire.CONSTANT_WIRE) + gremlin.sizes.sizeBool(self.constant); }
                return res;
            }

            pub fn encode(self: *const ValueArgument, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const ValueArgument, target: *gremlin.Writer) void {
                if (self.type) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(FunctionSignature.Argument.ValueArgumentWire.TYPE_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.constant != false) { target.appendBool(FunctionSignature.Argument.ValueArgumentWire.CONSTANT_WIRE, self.constant); }
            }
        };
        
        pub const ValueArgumentReader = struct {
            _type_buf: ?[]const u8 = null,
            _constant: bool = false,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ValueArgumentReader {
                var buf = gremlin.Reader.init(src);
                var res = ValueArgumentReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        FunctionSignature.Argument.ValueArgumentWire.TYPE_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._type_buf = result.value;
                        },
                        FunctionSignature.Argument.ValueArgumentWire.CONSTANT_WIRE => {
                          const result = try buf.readBool(offset);
                          offset += result.size;
                          res._constant = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const ValueArgumentReader) void { }
            
            pub fn getType(self: *const ValueArgumentReader, allocator: std.mem.Allocator) gremlin.Error!parameterized_types.ParameterizedTypeReader {
                if (self._type_buf) |buf| {
                    return try parameterized_types.ParameterizedTypeReader.init(allocator, buf);
                }
                return try parameterized_types.ParameterizedTypeReader.init(allocator, &[_]u8{});
            }
            pub inline fn getConstant(self: *const ValueArgumentReader) bool { return self._constant; }
        };
        
        const TypeArgumentWire = struct {
            const TYPE_WIRE: gremlin.ProtoWireNumber = 1;
        };
        
        pub const TypeArgument = struct {
            // fields
            type: ?parameterized_types.ParameterizedType = null,

            pub fn calcProtobufSize(self: *const TypeArgument) usize {
                var res: usize = 0;
                if (self.type) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(FunctionSignature.Argument.TypeArgumentWire.TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const TypeArgument, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const TypeArgument, target: *gremlin.Writer) void {
                if (self.type) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(FunctionSignature.Argument.TypeArgumentWire.TYPE_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const TypeArgumentReader = struct {
            _type_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!TypeArgumentReader {
                var buf = gremlin.Reader.init(src);
                var res = TypeArgumentReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        FunctionSignature.Argument.TypeArgumentWire.TYPE_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._type_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const TypeArgumentReader) void { }
            
            pub fn getType(self: *const TypeArgumentReader, allocator: std.mem.Allocator) gremlin.Error!parameterized_types.ParameterizedTypeReader {
                if (self._type_buf) |buf| {
                    return try parameterized_types.ParameterizedTypeReader.init(allocator, buf);
                }
                return try parameterized_types.ParameterizedTypeReader.init(allocator, &[_]u8{});
            }
        };
        
        const EnumArgumentWire = struct {
            const OPTIONS_WIRE: gremlin.ProtoWireNumber = 1;
            const OPTIONAL_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const EnumArgument = struct {
            // fields
            options: ?[]const ?[]const u8 = null,
            optional: bool = false,

            pub fn calcProtobufSize(self: *const EnumArgument) usize {
                var res: usize = 0;
                if (self.options) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(FunctionSignature.Argument.EnumArgumentWire.OPTIONS_WIRE);
                        if (maybe_v) |v| {
                            res += gremlin.sizes.sizeUsize(v.len) + v.len;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                if (self.optional != false) { res += gremlin.sizes.sizeWireNumber(FunctionSignature.Argument.EnumArgumentWire.OPTIONAL_WIRE) + gremlin.sizes.sizeBool(self.optional); }
                return res;
            }

            pub fn encode(self: *const EnumArgument, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const EnumArgument, target: *gremlin.Writer) void {
                if (self.options) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            target.appendBytes(FunctionSignature.Argument.EnumArgumentWire.OPTIONS_WIRE, v);
                        } else {
                            target.appendBytesTag(FunctionSignature.Argument.EnumArgumentWire.OPTIONS_WIRE, 0);
                        }
                    }
                }
                if (self.optional != false) { target.appendBool(FunctionSignature.Argument.EnumArgumentWire.OPTIONAL_WIRE, self.optional); }
            }
        };
        
        pub const EnumArgumentReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _options: ?std.ArrayList([]const u8) = null,
            _optional: bool = false,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!EnumArgumentReader {
                var buf = gremlin.Reader.init(src);
                var res = EnumArgumentReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        FunctionSignature.Argument.EnumArgumentWire.OPTIONS_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._options == null) {
                                res._options = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._options.?.append(result.value);
                        },
                        FunctionSignature.Argument.EnumArgumentWire.OPTIONAL_WIRE => {
                          const result = try buf.readBool(offset);
                          offset += result.size;
                          res._optional = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const EnumArgumentReader) void {
                if (self._options) |arr| {
                    arr.deinit();
                }
            }
            pub fn getOptions(self: *const EnumArgumentReader) []const []const u8 {
                if (self._options) |arr| {
                    return arr.items;
                }
                return &[_][]u8{};
            }
            pub inline fn getOptional(self: *const EnumArgumentReader) bool { return self._optional; }
        };
        
        // fields
        name: ?[]const u8 = null,
        value: ?FunctionSignature.Argument.ValueArgument = null,
        type: ?FunctionSignature.Argument.TypeArgument = null,
        enum_: ?FunctionSignature.Argument.EnumArgument = null,

        pub fn calcProtobufSize(self: *const Argument) usize {
            var res: usize = 0;
            if (self.name) |v| { res += gremlin.sizes.sizeWireNumber(FunctionSignature.ArgumentWire.NAME_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.value) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.ArgumentWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.ArgumentWire.TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.enum_) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(FunctionSignature.ArgumentWire.ENUM_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const Argument, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Argument, target: *gremlin.Writer) void {
            if (self.name) |v| { target.appendBytes(FunctionSignature.ArgumentWire.NAME_WIRE, v); }
            if (self.value) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.ArgumentWire.VALUE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.ArgumentWire.TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.enum_) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(FunctionSignature.ArgumentWire.ENUM_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const ArgumentReader = struct {
        _name: ?[]const u8 = null,
        _value_buf: ?[]const u8 = null,
        _type_buf: ?[]const u8 = null,
        _enum__buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ArgumentReader {
            var buf = gremlin.Reader.init(src);
            var res = ArgumentReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    FunctionSignature.ArgumentWire.NAME_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._name = result.value;
                    },
                    FunctionSignature.ArgumentWire.VALUE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._value_buf = result.value;
                    },
                    FunctionSignature.ArgumentWire.TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._type_buf = result.value;
                    },
                    FunctionSignature.ArgumentWire.ENUM_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._enum__buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ArgumentReader) void { }
        
        pub inline fn getName(self: *const ArgumentReader) []const u8 { return self._name orelse &[_]u8{}; }
        pub fn getValue(self: *const ArgumentReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.Argument.ValueArgumentReader {
            if (self._value_buf) |buf| {
                return try FunctionSignature.Argument.ValueArgumentReader.init(allocator, buf);
            }
            return try FunctionSignature.Argument.ValueArgumentReader.init(allocator, &[_]u8{});
        }
        pub fn getType(self: *const ArgumentReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.Argument.TypeArgumentReader {
            if (self._type_buf) |buf| {
                return try FunctionSignature.Argument.TypeArgumentReader.init(allocator, buf);
            }
            return try FunctionSignature.Argument.TypeArgumentReader.init(allocator, &[_]u8{});
        }
        pub fn getEnum(self: *const ArgumentReader, allocator: std.mem.Allocator) gremlin.Error!FunctionSignature.Argument.EnumArgumentReader {
            if (self._enum__buf) |buf| {
                return try FunctionSignature.Argument.EnumArgumentReader.init(allocator, buf);
            }
            return try FunctionSignature.Argument.EnumArgumentReader.init(allocator, &[_]u8{});
        }
    };
    

    pub fn calcProtobufSize(_: *const FunctionSignature) usize { return 0; }
    

    pub fn encode(self: *const FunctionSignature, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(_: *const FunctionSignature, _: *gremlin.Writer) void {}
    
};

pub const FunctionSignatureReader = struct {

    pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!FunctionSignatureReader {
        return FunctionSignatureReader{};
    }
    pub fn deinit(_: *const FunctionSignatureReader) void { }
    
};

