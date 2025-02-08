const std = @import("std");
const gremlin = @import("gremlin");
const extensions = @import("src/gen/substrait/extensions/extensions.proto.zig");
const any = @import("src/gen/google/protobuf/any.proto.zig");
const type = @import("type.proto.zig");

// enums
pub const AggregationPhase = enum(i32) {
    AGGREGATION_PHASE_UNSPECIFIED = 0,
    AGGREGATION_PHASE_INITIAL_TO_INTERMEDIATE = 1,
    AGGREGATION_PHASE_INTERMEDIATE_TO_INTERMEDIATE = 2,
    AGGREGATION_PHASE_INITIAL_TO_RESULT = 3,
    AGGREGATION_PHASE_INTERMEDIATE_TO_RESULT = 4,
};


// structs
const RelCommonWire = struct {
    const HINT_WIRE: gremlin.ProtoWireNumber = 3;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 4;
    const DIRECT_WIRE: gremlin.ProtoWireNumber = 1;
    const EMIT_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const RelCommon = struct {
    // nested structs
    pub const Direct = struct {

        pub fn calcProtobufSize(_: *const Direct) usize { return 0; }
        

        pub fn encode(self: *const Direct, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(_: *const Direct, _: *gremlin.Writer) void {}
        
    };
    
    pub const DirectReader = struct {

        pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!DirectReader {
            return DirectReader{};
        }
        pub fn deinit(_: *const DirectReader) void { }
        
    };
    
    const EmitWire = struct {
        const OUTPUT_MAPPING_WIRE: gremlin.ProtoWireNumber = 1;
    };
    
    pub const Emit = struct {
        // fields
        output_mapping: ?[]const i32 = null,

        pub fn calcProtobufSize(self: *const Emit) usize {
            var res: usize = 0;
            if (self.output_mapping) |arr| {
                if (arr.len == 0) {
                } else if (arr.len == 1) {
                    res += gremlin.sizes.sizeWireNumber(RelCommon.EmitWire.OUTPUT_MAPPING_WIRE) + gremlin.sizes.sizeI32(arr[0]);
                } else {
                    var packed_size: usize = 0;
                    for (arr) |v| {
                        packed_size += gremlin.sizes.sizeI32(v);
                    }
                    res += gremlin.sizes.sizeWireNumber(RelCommon.EmitWire.OUTPUT_MAPPING_WIRE) + gremlin.sizes.sizeUsize(packed_size) + packed_size;
                }
            }
            return res;
        }

        pub fn encode(self: *const Emit, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Emit, target: *gremlin.Writer) void {
            if (self.output_mapping) |arr| {
                if (arr.len == 0) {
                } else if (arr.len == 1) {
                    target.appendInt32(RelCommon.EmitWire.OUTPUT_MAPPING_WIRE, arr[0]);
                } else {
                    var packed_size: usize = 0;
                    for (arr) |v| {
                        packed_size += gremlin.sizes.sizeI32(v);
                    }
                    target.appendBytesTag(RelCommon.EmitWire.OUTPUT_MAPPING_WIRE, packed_size);
                    for (arr) |v| {
                        target.appendInt32WithoutTag(v);
                    }
                }
            }
        }
    };
    
    pub const EmitReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _output_mapping_offsets: ?std.ArrayList(usize) = null,
        _output_mapping_wires: ?std.ArrayList(gremlin.ProtoWireType) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!EmitReader {
            var buf = gremlin.Reader.init(src);
            var res = EmitReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    RelCommon.EmitWire.OUTPUT_MAPPING_WIRE => {
                        if (res._output_mapping_offsets == null) {
                            res._output_mapping_offsets = std.ArrayList(usize).init(allocator);
                            res._output_mapping_wires = std.ArrayList(gremlin.ProtoWireType).init(allocator);
                        }
                        try res._output_mapping_offsets.?.append(offset);
                        try res._output_mapping_wires.?.append(tag.wire);
                        if (tag.wire == gremlin.ProtoWireType.bytes) {
                            const length_result = try buf.readVarInt(offset);
                            offset += length_result.size + length_result.value;
                        } else {
                            const result = try buf.readInt32(offset);
                            offset += result.size;
                        }
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const EmitReader) void {
            if (self._output_mapping_offsets) |arr| {
                arr.deinit();
            }
            if (self._output_mapping_wires) |arr| {
                arr.deinit();
            }
        }
        pub fn getOutputMapping(self: *const EmitReader, allocator: std.mem.Allocator) gremlin.Error![]i32 {
            if (self._output_mapping_offsets) |offsets| {
                if (offsets.items.len == 0) return &[_]i32{};
        
                var result = std.ArrayList(i32).init(allocator);
                errdefer result.deinit();
        
                for (offsets.items, self._output_mapping_wires.?.items) |start_offset, wire_type| {
                    if (wire_type == .bytes) {
                        const length_result = try self.buf.readVarInt(start_offset);
                        var offset = start_offset + length_result.size;
                        const end_offset = offset + length_result.value;
        
                        while (offset < end_offset) {
                            const value_result = try self.buf.readInt32(offset);
                            try result.append(value_result.value);
                            offset += value_result.size;
                        }
                    } else {
                        const value_result = try self.buf.readInt32(start_offset);
                        try result.append(value_result.value);
                    }
                }
                return result.toOwnedSlice();
            }
            return &[_]i32{};
        }
    };
    
    const HintWire = struct {
        const STATS_WIRE: gremlin.ProtoWireNumber = 1;
        const CONSTRAINT_WIRE: gremlin.ProtoWireNumber = 2;
        const ALIAS_WIRE: gremlin.ProtoWireNumber = 3;
        const OUTPUT_NAMES_WIRE: gremlin.ProtoWireNumber = 4;
        const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
        const SAVED_COMPUTATIONS_WIRE: gremlin.ProtoWireNumber = 11;
        const LOADED_COMPUTATIONS_WIRE: gremlin.ProtoWireNumber = 12;
    };
    
    pub const Hint = struct {
        // nested enums
        pub const ComputationType = enum(i32) {
            COMPUTATION_TYPE_UNSPECIFIED = 0,
            COMPUTATION_TYPE_HASHTABLE = 1,
            COMPUTATION_TYPE_BLOOM_FILTER = 2,
            COMPUTATION_TYPE_UNKNOWN = 9999,
        };
        
        // nested structs
        const StatsWire = struct {
            const ROW_COUNT_WIRE: gremlin.ProtoWireNumber = 1;
            const RECORD_SIZE_WIRE: gremlin.ProtoWireNumber = 2;
            const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
        };
        
        pub const Stats = struct {
            // fields
            row_count: f64 = 0.0,
            record_size: f64 = 0.0,
            advanced_extension: ?extensions.AdvancedExtension = null,

            pub fn calcProtobufSize(self: *const Stats) usize {
                var res: usize = 0;
                if (self.row_count != 0.0) { res += gremlin.sizes.sizeWireNumber(RelCommon.Hint.StatsWire.ROW_COUNT_WIRE) + gremlin.sizes.sizeDouble(self.row_count); }
                if (self.record_size != 0.0) { res += gremlin.sizes.sizeWireNumber(RelCommon.Hint.StatsWire.RECORD_SIZE_WIRE) + gremlin.sizes.sizeDouble(self.record_size); }
                if (self.advanced_extension) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(RelCommon.Hint.StatsWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const Stats, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const Stats, target: *gremlin.Writer) void {
                if (self.row_count != 0.0) { target.appendFloat64(RelCommon.Hint.StatsWire.ROW_COUNT_WIRE, self.row_count); }
                if (self.record_size != 0.0) { target.appendFloat64(RelCommon.Hint.StatsWire.RECORD_SIZE_WIRE, self.record_size); }
                if (self.advanced_extension) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(RelCommon.Hint.StatsWire.ADVANCED_EXTENSION_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const StatsReader = struct {
            _row_count: f64 = 0.0,
            _record_size: f64 = 0.0,
            _advanced_extension_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!StatsReader {
                var buf = gremlin.Reader.init(src);
                var res = StatsReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        RelCommon.Hint.StatsWire.ROW_COUNT_WIRE => {
                          const result = try buf.readFloat64(offset);
                          offset += result.size;
                          res._row_count = result.value;
                        },
                        RelCommon.Hint.StatsWire.RECORD_SIZE_WIRE => {
                          const result = try buf.readFloat64(offset);
                          offset += result.size;
                          res._record_size = result.value;
                        },
                        RelCommon.Hint.StatsWire.ADVANCED_EXTENSION_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._advanced_extension_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const StatsReader) void { }
            
            pub inline fn getRowCount(self: *const StatsReader) f64 { return self._row_count; }
            pub inline fn getRecordSize(self: *const StatsReader) f64 { return self._record_size; }
            pub fn getAdvancedExtension(self: *const StatsReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
                if (self._advanced_extension_buf) |buf| {
                    return try extensions.AdvancedExtensionReader.init(allocator, buf);
                }
                return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
            }
        };
        
        const RuntimeConstraintWire = struct {
            const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
        };
        
        pub const RuntimeConstraint = struct {
            // fields
            advanced_extension: ?extensions.AdvancedExtension = null,

            pub fn calcProtobufSize(self: *const RuntimeConstraint) usize {
                var res: usize = 0;
                if (self.advanced_extension) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(RelCommon.Hint.RuntimeConstraintWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const RuntimeConstraint, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const RuntimeConstraint, target: *gremlin.Writer) void {
                if (self.advanced_extension) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(RelCommon.Hint.RuntimeConstraintWire.ADVANCED_EXTENSION_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const RuntimeConstraintReader = struct {
            _advanced_extension_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!RuntimeConstraintReader {
                var buf = gremlin.Reader.init(src);
                var res = RuntimeConstraintReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        RelCommon.Hint.RuntimeConstraintWire.ADVANCED_EXTENSION_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._advanced_extension_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const RuntimeConstraintReader) void { }
            
            pub fn getAdvancedExtension(self: *const RuntimeConstraintReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
                if (self._advanced_extension_buf) |buf| {
                    return try extensions.AdvancedExtensionReader.init(allocator, buf);
                }
                return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
            }
        };
        
        const SavedComputationWire = struct {
            const COMPUTATION_ID_WIRE: gremlin.ProtoWireNumber = 1;
            const TYPE_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const SavedComputation = struct {
            // fields
            computation_id: i32 = 0,
            type: RelCommon.Hint.ComputationType = @enumFromInt(0),

            pub fn calcProtobufSize(self: *const SavedComputation) usize {
                var res: usize = 0;
                if (self.computation_id != 0) { res += gremlin.sizes.sizeWireNumber(RelCommon.Hint.SavedComputationWire.COMPUTATION_ID_WIRE) + gremlin.sizes.sizeI32(self.computation_id); }
                if (@intFromEnum(self.type) != 0) { res += gremlin.sizes.sizeWireNumber(RelCommon.Hint.SavedComputationWire.TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.type)); }
                return res;
            }

            pub fn encode(self: *const SavedComputation, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const SavedComputation, target: *gremlin.Writer) void {
                if (self.computation_id != 0) { target.appendInt32(RelCommon.Hint.SavedComputationWire.COMPUTATION_ID_WIRE, self.computation_id); }
                if (@intFromEnum(self.type) != 0) { target.appendInt32(RelCommon.Hint.SavedComputationWire.TYPE_WIRE, @intFromEnum(self.type)); }
            }
        };
        
        pub const SavedComputationReader = struct {
            _computation_id: i32 = 0,
            _type: RelCommon.Hint.ComputationType = @enumFromInt(0),

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!SavedComputationReader {
                var buf = gremlin.Reader.init(src);
                var res = SavedComputationReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        RelCommon.Hint.SavedComputationWire.COMPUTATION_ID_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._computation_id = result.value;
                        },
                        RelCommon.Hint.SavedComputationWire.TYPE_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._type = @enumFromInt(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const SavedComputationReader) void { }
            
            pub inline fn getComputationId(self: *const SavedComputationReader) i32 { return self._computation_id; }
            pub inline fn getType(self: *const SavedComputationReader) RelCommon.Hint.ComputationType { return self._type; }
        };
        
        const LoadedComputationWire = struct {
            const COMPUTATION_ID_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
            const TYPE_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const LoadedComputation = struct {
            // fields
            computation_id_reference: i32 = 0,
            type: RelCommon.Hint.ComputationType = @enumFromInt(0),

            pub fn calcProtobufSize(self: *const LoadedComputation) usize {
                var res: usize = 0;
                if (self.computation_id_reference != 0) { res += gremlin.sizes.sizeWireNumber(RelCommon.Hint.LoadedComputationWire.COMPUTATION_ID_REFERENCE_WIRE) + gremlin.sizes.sizeI32(self.computation_id_reference); }
                if (@intFromEnum(self.type) != 0) { res += gremlin.sizes.sizeWireNumber(RelCommon.Hint.LoadedComputationWire.TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.type)); }
                return res;
            }

            pub fn encode(self: *const LoadedComputation, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const LoadedComputation, target: *gremlin.Writer) void {
                if (self.computation_id_reference != 0) { target.appendInt32(RelCommon.Hint.LoadedComputationWire.COMPUTATION_ID_REFERENCE_WIRE, self.computation_id_reference); }
                if (@intFromEnum(self.type) != 0) { target.appendInt32(RelCommon.Hint.LoadedComputationWire.TYPE_WIRE, @intFromEnum(self.type)); }
            }
        };
        
        pub const LoadedComputationReader = struct {
            _computation_id_reference: i32 = 0,
            _type: RelCommon.Hint.ComputationType = @enumFromInt(0),

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!LoadedComputationReader {
                var buf = gremlin.Reader.init(src);
                var res = LoadedComputationReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        RelCommon.Hint.LoadedComputationWire.COMPUTATION_ID_REFERENCE_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._computation_id_reference = result.value;
                        },
                        RelCommon.Hint.LoadedComputationWire.TYPE_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._type = @enumFromInt(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const LoadedComputationReader) void { }
            
            pub inline fn getComputationIdReference(self: *const LoadedComputationReader) i32 { return self._computation_id_reference; }
            pub inline fn getType(self: *const LoadedComputationReader) RelCommon.Hint.ComputationType { return self._type; }
        };
        
        // fields
        stats: ?RelCommon.Hint.Stats = null,
        constraint: ?RelCommon.Hint.RuntimeConstraint = null,
        alias: ?[]const u8 = null,
        output_names: ?[]const ?[]const u8 = null,
        advanced_extension: ?extensions.AdvancedExtension = null,
        saved_computations: ?[]const ?RelCommon.Hint.SavedComputation = null,
        loaded_computations: ?[]const ?RelCommon.Hint.LoadedComputation = null,

        pub fn calcProtobufSize(self: *const Hint) usize {
            var res: usize = 0;
            if (self.stats) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(RelCommon.HintWire.STATS_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.constraint) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(RelCommon.HintWire.CONSTRAINT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.alias) |v| { res += gremlin.sizes.sizeWireNumber(RelCommon.HintWire.ALIAS_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.output_names) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(RelCommon.HintWire.OUTPUT_NAMES_WIRE);
                    if (maybe_v) |v| {
                        res += gremlin.sizes.sizeUsize(v.len) + v.len;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.advanced_extension) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(RelCommon.HintWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.saved_computations) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(RelCommon.HintWire.SAVED_COMPUTATIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.loaded_computations) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(RelCommon.HintWire.LOADED_COMPUTATIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            return res;
        }

        pub fn encode(self: *const Hint, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Hint, target: *gremlin.Writer) void {
            if (self.stats) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(RelCommon.HintWire.STATS_WIRE, size);
                v.encodeTo(target);
            }
            if (self.constraint) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(RelCommon.HintWire.CONSTRAINT_WIRE, size);
                v.encodeTo(target);
            }
            if (self.alias) |v| { target.appendBytes(RelCommon.HintWire.ALIAS_WIRE, v); }
            if (self.output_names) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        target.appendBytes(RelCommon.HintWire.OUTPUT_NAMES_WIRE, v);
                    } else {
                        target.appendBytesTag(RelCommon.HintWire.OUTPUT_NAMES_WIRE, 0);
                    }
                }
            }
            if (self.advanced_extension) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(RelCommon.HintWire.ADVANCED_EXTENSION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.saved_computations) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(RelCommon.HintWire.SAVED_COMPUTATIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(RelCommon.HintWire.SAVED_COMPUTATIONS_WIRE, 0);
                    }
                }
            }
            if (self.loaded_computations) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(RelCommon.HintWire.LOADED_COMPUTATIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(RelCommon.HintWire.LOADED_COMPUTATIONS_WIRE, 0);
                    }
                }
            }
        }
    };
    
    pub const HintReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _stats_buf: ?[]const u8 = null,
        _constraint_buf: ?[]const u8 = null,
        _alias: ?[]const u8 = null,
        _output_names: ?std.ArrayList([]const u8) = null,
        _advanced_extension_buf: ?[]const u8 = null,
        _saved_computations_bufs: ?std.ArrayList([]const u8) = null,
        _loaded_computations_bufs: ?std.ArrayList([]const u8) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!HintReader {
            var buf = gremlin.Reader.init(src);
            var res = HintReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    RelCommon.HintWire.STATS_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._stats_buf = result.value;
                    },
                    RelCommon.HintWire.CONSTRAINT_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._constraint_buf = result.value;
                    },
                    RelCommon.HintWire.ALIAS_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._alias = result.value;
                    },
                    RelCommon.HintWire.OUTPUT_NAMES_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._output_names == null) {
                            res._output_names = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._output_names.?.append(result.value);
                    },
                    RelCommon.HintWire.ADVANCED_EXTENSION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._advanced_extension_buf = result.value;
                    },
                    RelCommon.HintWire.SAVED_COMPUTATIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._saved_computations_bufs == null) {
                            res._saved_computations_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._saved_computations_bufs.?.append(result.value);
                    },
                    RelCommon.HintWire.LOADED_COMPUTATIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._loaded_computations_bufs == null) {
                            res._loaded_computations_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._loaded_computations_bufs.?.append(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const HintReader) void {
            if (self._output_names) |arr| {
                arr.deinit();
            }
            if (self._saved_computations_bufs) |arr| {
                arr.deinit();
            }
            if (self._loaded_computations_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getStats(self: *const HintReader, allocator: std.mem.Allocator) gremlin.Error!RelCommon.Hint.StatsReader {
            if (self._stats_buf) |buf| {
                return try RelCommon.Hint.StatsReader.init(allocator, buf);
            }
            return try RelCommon.Hint.StatsReader.init(allocator, &[_]u8{});
        }
        pub fn getConstraint(self: *const HintReader, allocator: std.mem.Allocator) gremlin.Error!RelCommon.Hint.RuntimeConstraintReader {
            if (self._constraint_buf) |buf| {
                return try RelCommon.Hint.RuntimeConstraintReader.init(allocator, buf);
            }
            return try RelCommon.Hint.RuntimeConstraintReader.init(allocator, &[_]u8{});
        }
        pub inline fn getAlias(self: *const HintReader) []const u8 { return self._alias orelse &[_]u8{}; }
        pub fn getOutputNames(self: *const HintReader) []const []const u8 {
            if (self._output_names) |arr| {
                return arr.items;
            }
            return &[_][]u8{};
        }
        pub fn getAdvancedExtension(self: *const HintReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
            if (self._advanced_extension_buf) |buf| {
                return try extensions.AdvancedExtensionReader.init(allocator, buf);
            }
            return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
        }
        pub fn getSavedComputations(self: *const HintReader, allocator: std.mem.Allocator) gremlin.Error![]RelCommon.Hint.SavedComputationReader {
            if (self._saved_computations_bufs) |bufs| {
                var result = try std.ArrayList(RelCommon.Hint.SavedComputationReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try RelCommon.Hint.SavedComputationReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]RelCommon.Hint.SavedComputationReader{};
        }
        pub fn getLoadedComputations(self: *const HintReader, allocator: std.mem.Allocator) gremlin.Error![]RelCommon.Hint.LoadedComputationReader {
            if (self._loaded_computations_bufs) |bufs| {
                var result = try std.ArrayList(RelCommon.Hint.LoadedComputationReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try RelCommon.Hint.LoadedComputationReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]RelCommon.Hint.LoadedComputationReader{};
        }
    };
    
    // fields
    hint: ?RelCommon.Hint = null,
    advanced_extension: ?extensions.AdvancedExtension = null,
    direct: ?RelCommon.Direct = null,
    emit: ?RelCommon.Emit = null,

    pub fn calcProtobufSize(self: *const RelCommon) usize {
        var res: usize = 0;
        if (self.hint) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelCommonWire.HINT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelCommonWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.direct) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelCommonWire.DIRECT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.emit) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelCommonWire.EMIT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const RelCommon, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const RelCommon, target: *gremlin.Writer) void {
        if (self.hint) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelCommonWire.HINT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelCommonWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.direct) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelCommonWire.DIRECT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.emit) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelCommonWire.EMIT_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const RelCommonReader = struct {
    _hint_buf: ?[]const u8 = null,
    _advanced_extension_buf: ?[]const u8 = null,
    _direct_buf: ?[]const u8 = null,
    _emit_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!RelCommonReader {
        var buf = gremlin.Reader.init(src);
        var res = RelCommonReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                RelCommonWire.HINT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._hint_buf = result.value;
                },
                RelCommonWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                RelCommonWire.DIRECT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._direct_buf = result.value;
                },
                RelCommonWire.EMIT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._emit_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const RelCommonReader) void { }
    
    pub fn getHint(self: *const RelCommonReader, allocator: std.mem.Allocator) gremlin.Error!RelCommon.HintReader {
        if (self._hint_buf) |buf| {
            return try RelCommon.HintReader.init(allocator, buf);
        }
        return try RelCommon.HintReader.init(allocator, &[_]u8{});
    }
    pub fn getAdvancedExtension(self: *const RelCommonReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
    pub fn getDirect(self: *const RelCommonReader, allocator: std.mem.Allocator) gremlin.Error!RelCommon.DirectReader {
        if (self._direct_buf) |buf| {
            return try RelCommon.DirectReader.init(allocator, buf);
        }
        return try RelCommon.DirectReader.init(allocator, &[_]u8{});
    }
    pub fn getEmit(self: *const RelCommonReader, allocator: std.mem.Allocator) gremlin.Error!RelCommon.EmitReader {
        if (self._emit_buf) |buf| {
            return try RelCommon.EmitReader.init(allocator, buf);
        }
        return try RelCommon.EmitReader.init(allocator, &[_]u8{});
    }
};

const ReadRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const BASE_SCHEMA_WIRE: gremlin.ProtoWireNumber = 2;
    const FILTER_WIRE: gremlin.ProtoWireNumber = 3;
    const BEST_EFFORT_FILTER_WIRE: gremlin.ProtoWireNumber = 11;
    const PROJECTION_WIRE: gremlin.ProtoWireNumber = 4;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
    const VIRTUAL_TABLE_WIRE: gremlin.ProtoWireNumber = 5;
    const LOCAL_FILES_WIRE: gremlin.ProtoWireNumber = 6;
    const NAMED_TABLE_WIRE: gremlin.ProtoWireNumber = 7;
    const EXTENSION_TABLE_WIRE: gremlin.ProtoWireNumber = 8;
};

pub const ReadRel = struct {
    // nested structs
    const NamedTableWire = struct {
        const NAMES_WIRE: gremlin.ProtoWireNumber = 1;
        const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
    };
    
    pub const NamedTable = struct {
        // fields
        names: ?[]const ?[]const u8 = null,
        advanced_extension: ?extensions.AdvancedExtension = null,

        pub fn calcProtobufSize(self: *const NamedTable) usize {
            var res: usize = 0;
            if (self.names) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(ReadRel.NamedTableWire.NAMES_WIRE);
                    if (maybe_v) |v| {
                        res += gremlin.sizes.sizeUsize(v.len) + v.len;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.advanced_extension) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ReadRel.NamedTableWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const NamedTable, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const NamedTable, target: *gremlin.Writer) void {
            if (self.names) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        target.appendBytes(ReadRel.NamedTableWire.NAMES_WIRE, v);
                    } else {
                        target.appendBytesTag(ReadRel.NamedTableWire.NAMES_WIRE, 0);
                    }
                }
            }
            if (self.advanced_extension) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ReadRel.NamedTableWire.ADVANCED_EXTENSION_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const NamedTableReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _names: ?std.ArrayList([]const u8) = null,
        _advanced_extension_buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!NamedTableReader {
            var buf = gremlin.Reader.init(src);
            var res = NamedTableReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ReadRel.NamedTableWire.NAMES_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._names == null) {
                            res._names = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._names.?.append(result.value);
                    },
                    ReadRel.NamedTableWire.ADVANCED_EXTENSION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._advanced_extension_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const NamedTableReader) void {
            if (self._names) |arr| {
                arr.deinit();
            }
        }
        pub fn getNames(self: *const NamedTableReader) []const []const u8 {
            if (self._names) |arr| {
                return arr.items;
            }
            return &[_][]u8{};
        }
        pub fn getAdvancedExtension(self: *const NamedTableReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
            if (self._advanced_extension_buf) |buf| {
                return try extensions.AdvancedExtensionReader.init(allocator, buf);
            }
            return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
        }
    };
    
    const VirtualTableWire = struct {
        const VALUES_WIRE: gremlin.ProtoWireNumber = 1;
        const EXPRESSIONS_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const VirtualTable = struct {
        // fields
        values: ?[]const ?Expression.Literal.Struct = null,
        expressions: ?[]const ?Expression.Nested.Struct = null,

        pub fn calcProtobufSize(self: *const VirtualTable) usize {
            var res: usize = 0;
            if (self.values) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(ReadRel.VirtualTableWire.VALUES_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.expressions) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(ReadRel.VirtualTableWire.EXPRESSIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            return res;
        }

        pub fn encode(self: *const VirtualTable, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const VirtualTable, target: *gremlin.Writer) void {
            if (self.values) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(ReadRel.VirtualTableWire.VALUES_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(ReadRel.VirtualTableWire.VALUES_WIRE, 0);
                    }
                }
            }
            if (self.expressions) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(ReadRel.VirtualTableWire.EXPRESSIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(ReadRel.VirtualTableWire.EXPRESSIONS_WIRE, 0);
                    }
                }
            }
        }
    };
    
    pub const VirtualTableReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _values_bufs: ?std.ArrayList([]const u8) = null,
        _expressions_bufs: ?std.ArrayList([]const u8) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!VirtualTableReader {
            var buf = gremlin.Reader.init(src);
            var res = VirtualTableReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ReadRel.VirtualTableWire.VALUES_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._values_bufs == null) {
                            res._values_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._values_bufs.?.append(result.value);
                    },
                    ReadRel.VirtualTableWire.EXPRESSIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._expressions_bufs == null) {
                            res._expressions_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._expressions_bufs.?.append(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const VirtualTableReader) void {
            if (self._values_bufs) |arr| {
                arr.deinit();
            }
            if (self._expressions_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getValues(self: *const VirtualTableReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.Literal.StructReader {
            if (self._values_bufs) |bufs| {
                var result = try std.ArrayList(Expression.Literal.StructReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try Expression.Literal.StructReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]Expression.Literal.StructReader{};
        }
        pub fn getExpressions(self: *const VirtualTableReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.Nested.StructReader {
            if (self._expressions_bufs) |bufs| {
                var result = try std.ArrayList(Expression.Nested.StructReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try Expression.Nested.StructReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]Expression.Nested.StructReader{};
        }
    };
    
    const ExtensionTableWire = struct {
        const DETAIL_WIRE: gremlin.ProtoWireNumber = 1;
    };
    
    pub const ExtensionTable = struct {
        // fields
        detail: ?any.Any = null,

        pub fn calcProtobufSize(self: *const ExtensionTable) usize {
            var res: usize = 0;
            if (self.detail) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ReadRel.ExtensionTableWire.DETAIL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const ExtensionTable, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExtensionTable, target: *gremlin.Writer) void {
            if (self.detail) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ReadRel.ExtensionTableWire.DETAIL_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const ExtensionTableReader = struct {
        _detail_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExtensionTableReader {
            var buf = gremlin.Reader.init(src);
            var res = ExtensionTableReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ReadRel.ExtensionTableWire.DETAIL_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._detail_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ExtensionTableReader) void { }
        
        pub fn getDetail(self: *const ExtensionTableReader, allocator: std.mem.Allocator) gremlin.Error!any.AnyReader {
            if (self._detail_buf) |buf| {
                return try any.AnyReader.init(allocator, buf);
            }
            return try any.AnyReader.init(allocator, &[_]u8{});
        }
    };
    
    const LocalFilesWire = struct {
        const ITEMS_WIRE: gremlin.ProtoWireNumber = 1;
        const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
    };
    
    pub const LocalFiles = struct {
        // nested structs
        const FileOrFilesWire = struct {
            const PARTITION_INDEX_WIRE: gremlin.ProtoWireNumber = 6;
            const START_WIRE: gremlin.ProtoWireNumber = 7;
            const LENGTH_WIRE: gremlin.ProtoWireNumber = 8;
            const URI_PATH_WIRE: gremlin.ProtoWireNumber = 1;
            const URI_PATH_GLOB_WIRE: gremlin.ProtoWireNumber = 2;
            const URI_FILE_WIRE: gremlin.ProtoWireNumber = 3;
            const URI_FOLDER_WIRE: gremlin.ProtoWireNumber = 4;
            const PARQUET_WIRE: gremlin.ProtoWireNumber = 9;
            const ARROW_WIRE: gremlin.ProtoWireNumber = 10;
            const ORC_WIRE: gremlin.ProtoWireNumber = 11;
            const EXTENSION_WIRE: gremlin.ProtoWireNumber = 12;
            const DWRF_WIRE: gremlin.ProtoWireNumber = 13;
            const TEXT_WIRE: gremlin.ProtoWireNumber = 14;
        };
        
        pub const FileOrFiles = struct {
            // nested structs
            pub const ParquetReadOptions = struct {

                pub fn calcProtobufSize(_: *const ParquetReadOptions) usize { return 0; }
                

                pub fn encode(self: *const ParquetReadOptions, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(_: *const ParquetReadOptions, _: *gremlin.Writer) void {}
                
            };
            
            pub const ParquetReadOptionsReader = struct {

                pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!ParquetReadOptionsReader {
                    return ParquetReadOptionsReader{};
                }
                pub fn deinit(_: *const ParquetReadOptionsReader) void { }
                
            };
            
            pub const ArrowReadOptions = struct {

                pub fn calcProtobufSize(_: *const ArrowReadOptions) usize { return 0; }
                

                pub fn encode(self: *const ArrowReadOptions, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(_: *const ArrowReadOptions, _: *gremlin.Writer) void {}
                
            };
            
            pub const ArrowReadOptionsReader = struct {

                pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!ArrowReadOptionsReader {
                    return ArrowReadOptionsReader{};
                }
                pub fn deinit(_: *const ArrowReadOptionsReader) void { }
                
            };
            
            pub const OrcReadOptions = struct {

                pub fn calcProtobufSize(_: *const OrcReadOptions) usize { return 0; }
                

                pub fn encode(self: *const OrcReadOptions, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(_: *const OrcReadOptions, _: *gremlin.Writer) void {}
                
            };
            
            pub const OrcReadOptionsReader = struct {

                pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!OrcReadOptionsReader {
                    return OrcReadOptionsReader{};
                }
                pub fn deinit(_: *const OrcReadOptionsReader) void { }
                
            };
            
            pub const DwrfReadOptions = struct {

                pub fn calcProtobufSize(_: *const DwrfReadOptions) usize { return 0; }
                

                pub fn encode(self: *const DwrfReadOptions, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(_: *const DwrfReadOptions, _: *gremlin.Writer) void {}
                
            };
            
            pub const DwrfReadOptionsReader = struct {

                pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!DwrfReadOptionsReader {
                    return DwrfReadOptionsReader{};
                }
                pub fn deinit(_: *const DwrfReadOptionsReader) void { }
                
            };
            
            const DelimiterSeparatedTextReadOptionsWire = struct {
                const FIELD_DELIMITER_WIRE: gremlin.ProtoWireNumber = 1;
                const MAX_LINE_SIZE_WIRE: gremlin.ProtoWireNumber = 2;
                const QUOTE_WIRE: gremlin.ProtoWireNumber = 3;
                const HEADER_LINES_TO_SKIP_WIRE: gremlin.ProtoWireNumber = 4;
                const ESCAPE_WIRE: gremlin.ProtoWireNumber = 5;
                const VALUE_TREATED_AS_NULL_WIRE: gremlin.ProtoWireNumber = 6;
            };
            
            pub const DelimiterSeparatedTextReadOptions = struct {
                // fields
                field_delimiter: ?[]const u8 = null,
                max_line_size: u64 = 0,
                quote: ?[]const u8 = null,
                header_lines_to_skip: u64 = 0,
                escape: ?[]const u8 = null,
                value_treated_as_null: ?[]const u8 = null,

                pub fn calcProtobufSize(self: *const DelimiterSeparatedTextReadOptions) usize {
                    var res: usize = 0;
                    if (self.field_delimiter) |v| { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.FIELD_DELIMITER_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                    if (self.max_line_size != 0) { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.MAX_LINE_SIZE_WIRE) + gremlin.sizes.sizeU64(self.max_line_size); }
                    if (self.quote) |v| { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.QUOTE_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                    if (self.header_lines_to_skip != 0) { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.HEADER_LINES_TO_SKIP_WIRE) + gremlin.sizes.sizeU64(self.header_lines_to_skip); }
                    if (self.escape) |v| { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.ESCAPE_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                    if (self.value_treated_as_null) |v| { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.VALUE_TREATED_AS_NULL_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                    return res;
                }

                pub fn encode(self: *const DelimiterSeparatedTextReadOptions, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(self: *const DelimiterSeparatedTextReadOptions, target: *gremlin.Writer) void {
                    if (self.field_delimiter) |v| { target.appendBytes(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.FIELD_DELIMITER_WIRE, v); }
                    if (self.max_line_size != 0) { target.appendUint64(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.MAX_LINE_SIZE_WIRE, self.max_line_size); }
                    if (self.quote) |v| { target.appendBytes(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.QUOTE_WIRE, v); }
                    if (self.header_lines_to_skip != 0) { target.appendUint64(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.HEADER_LINES_TO_SKIP_WIRE, self.header_lines_to_skip); }
                    if (self.escape) |v| { target.appendBytes(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.ESCAPE_WIRE, v); }
                    if (self.value_treated_as_null) |v| { target.appendBytes(ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.VALUE_TREATED_AS_NULL_WIRE, v); }
                }
            };
            
            pub const DelimiterSeparatedTextReadOptionsReader = struct {
                _field_delimiter: ?[]const u8 = null,
                _max_line_size: u64 = 0,
                _quote: ?[]const u8 = null,
                _header_lines_to_skip: u64 = 0,
                _escape: ?[]const u8 = null,
                _value_treated_as_null: ?[]const u8 = null,

                pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!DelimiterSeparatedTextReadOptionsReader {
                    var buf = gremlin.Reader.init(src);
                    var res = DelimiterSeparatedTextReadOptionsReader{};
                    if (buf.buf.len == 0) {
                        return res;
                    }
                    var offset: usize = 0;
                    while (buf.hasNext(offset, 0)) {
                        const tag = try buf.readTagAt(offset);
                        offset += tag.size;
                        switch (tag.number) {
                            ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.FIELD_DELIMITER_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._field_delimiter = result.value;
                            },
                            ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.MAX_LINE_SIZE_WIRE => {
                              const result = try buf.readUInt64(offset);
                              offset += result.size;
                              res._max_line_size = result.value;
                            },
                            ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.QUOTE_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._quote = result.value;
                            },
                            ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.HEADER_LINES_TO_SKIP_WIRE => {
                              const result = try buf.readUInt64(offset);
                              offset += result.size;
                              res._header_lines_to_skip = result.value;
                            },
                            ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.ESCAPE_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._escape = result.value;
                            },
                            ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsWire.VALUE_TREATED_AS_NULL_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._value_treated_as_null = result.value;
                            },
                            else => {
                                offset = try buf.skipData(offset, tag.wire);
                            }
                        }
                    }
                    return res;
                }
                pub fn deinit(_: *const DelimiterSeparatedTextReadOptionsReader) void { }
                
                pub inline fn getFieldDelimiter(self: *const DelimiterSeparatedTextReadOptionsReader) []const u8 { return self._field_delimiter orelse &[_]u8{}; }
                pub inline fn getMaxLineSize(self: *const DelimiterSeparatedTextReadOptionsReader) u64 { return self._max_line_size; }
                pub inline fn getQuote(self: *const DelimiterSeparatedTextReadOptionsReader) []const u8 { return self._quote orelse &[_]u8{}; }
                pub inline fn getHeaderLinesToSkip(self: *const DelimiterSeparatedTextReadOptionsReader) u64 { return self._header_lines_to_skip; }
                pub inline fn getEscape(self: *const DelimiterSeparatedTextReadOptionsReader) []const u8 { return self._escape orelse &[_]u8{}; }
                pub inline fn getValueTreatedAsNull(self: *const DelimiterSeparatedTextReadOptionsReader) []const u8 { return self._value_treated_as_null orelse &[_]u8{}; }
            };
            
            // fields
            partition_index: u64 = 0,
            start: u64 = 0,
            length: u64 = 0,
            uri_path: ?[]const u8 = null,
            uri_path_glob: ?[]const u8 = null,
            uri_file: ?[]const u8 = null,
            uri_folder: ?[]const u8 = null,
            parquet: ?ReadRel.LocalFiles.FileOrFiles.ParquetReadOptions = null,
            arrow: ?ReadRel.LocalFiles.FileOrFiles.ArrowReadOptions = null,
            orc: ?ReadRel.LocalFiles.FileOrFiles.OrcReadOptions = null,
            extension: ?any.Any = null,
            dwrf: ?ReadRel.LocalFiles.FileOrFiles.DwrfReadOptions = null,
            text: ?ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptions = null,

            pub fn calcProtobufSize(self: *const FileOrFiles) usize {
                var res: usize = 0;
                if (self.partition_index != 0) { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.PARTITION_INDEX_WIRE) + gremlin.sizes.sizeU64(self.partition_index); }
                if (self.start != 0) { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.START_WIRE) + gremlin.sizes.sizeU64(self.start); }
                if (self.length != 0) { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.LENGTH_WIRE) + gremlin.sizes.sizeU64(self.length); }
                if (self.uri_path) |v| { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.URI_PATH_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                if (self.uri_path_glob) |v| { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.URI_PATH_GLOB_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                if (self.uri_file) |v| { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.URI_FILE_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                if (self.uri_folder) |v| { res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.URI_FOLDER_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                if (self.parquet) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.PARQUET_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.arrow) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.ARROW_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.orc) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.ORC_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.extension) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.dwrf) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.DWRF_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.text) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFiles.FileOrFilesWire.TEXT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const FileOrFiles, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const FileOrFiles, target: *gremlin.Writer) void {
                if (self.partition_index != 0) { target.appendUint64(ReadRel.LocalFiles.FileOrFilesWire.PARTITION_INDEX_WIRE, self.partition_index); }
                if (self.start != 0) { target.appendUint64(ReadRel.LocalFiles.FileOrFilesWire.START_WIRE, self.start); }
                if (self.length != 0) { target.appendUint64(ReadRel.LocalFiles.FileOrFilesWire.LENGTH_WIRE, self.length); }
                if (self.uri_path) |v| { target.appendBytes(ReadRel.LocalFiles.FileOrFilesWire.URI_PATH_WIRE, v); }
                if (self.uri_path_glob) |v| { target.appendBytes(ReadRel.LocalFiles.FileOrFilesWire.URI_PATH_GLOB_WIRE, v); }
                if (self.uri_file) |v| { target.appendBytes(ReadRel.LocalFiles.FileOrFilesWire.URI_FILE_WIRE, v); }
                if (self.uri_folder) |v| { target.appendBytes(ReadRel.LocalFiles.FileOrFilesWire.URI_FOLDER_WIRE, v); }
                if (self.parquet) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ReadRel.LocalFiles.FileOrFilesWire.PARQUET_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.arrow) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ReadRel.LocalFiles.FileOrFilesWire.ARROW_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.orc) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ReadRel.LocalFiles.FileOrFilesWire.ORC_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.extension) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ReadRel.LocalFiles.FileOrFilesWire.EXTENSION_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.dwrf) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ReadRel.LocalFiles.FileOrFilesWire.DWRF_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.text) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ReadRel.LocalFiles.FileOrFilesWire.TEXT_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const FileOrFilesReader = struct {
            _partition_index: u64 = 0,
            _start: u64 = 0,
            _length: u64 = 0,
            _uri_path: ?[]const u8 = null,
            _uri_path_glob: ?[]const u8 = null,
            _uri_file: ?[]const u8 = null,
            _uri_folder: ?[]const u8 = null,
            _parquet_buf: ?[]const u8 = null,
            _arrow_buf: ?[]const u8 = null,
            _orc_buf: ?[]const u8 = null,
            _extension_buf: ?[]const u8 = null,
            _dwrf_buf: ?[]const u8 = null,
            _text_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!FileOrFilesReader {
                var buf = gremlin.Reader.init(src);
                var res = FileOrFilesReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        ReadRel.LocalFiles.FileOrFilesWire.PARTITION_INDEX_WIRE => {
                          const result = try buf.readUInt64(offset);
                          offset += result.size;
                          res._partition_index = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.START_WIRE => {
                          const result = try buf.readUInt64(offset);
                          offset += result.size;
                          res._start = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.LENGTH_WIRE => {
                          const result = try buf.readUInt64(offset);
                          offset += result.size;
                          res._length = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.URI_PATH_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._uri_path = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.URI_PATH_GLOB_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._uri_path_glob = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.URI_FILE_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._uri_file = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.URI_FOLDER_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._uri_folder = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.PARQUET_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._parquet_buf = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.ARROW_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._arrow_buf = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.ORC_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._orc_buf = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.EXTENSION_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._extension_buf = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.DWRF_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._dwrf_buf = result.value;
                        },
                        ReadRel.LocalFiles.FileOrFilesWire.TEXT_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._text_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const FileOrFilesReader) void { }
            
            pub inline fn getPartitionIndex(self: *const FileOrFilesReader) u64 { return self._partition_index; }
            pub inline fn getStart(self: *const FileOrFilesReader) u64 { return self._start; }
            pub inline fn getLength(self: *const FileOrFilesReader) u64 { return self._length; }
            pub inline fn getUriPath(self: *const FileOrFilesReader) []const u8 { return self._uri_path orelse &[_]u8{}; }
            pub inline fn getUriPathGlob(self: *const FileOrFilesReader) []const u8 { return self._uri_path_glob orelse &[_]u8{}; }
            pub inline fn getUriFile(self: *const FileOrFilesReader) []const u8 { return self._uri_file orelse &[_]u8{}; }
            pub inline fn getUriFolder(self: *const FileOrFilesReader) []const u8 { return self._uri_folder orelse &[_]u8{}; }
            pub fn getParquet(self: *const FileOrFilesReader, allocator: std.mem.Allocator) gremlin.Error!ReadRel.LocalFiles.FileOrFiles.ParquetReadOptionsReader {
                if (self._parquet_buf) |buf| {
                    return try ReadRel.LocalFiles.FileOrFiles.ParquetReadOptionsReader.init(allocator, buf);
                }
                return try ReadRel.LocalFiles.FileOrFiles.ParquetReadOptionsReader.init(allocator, &[_]u8{});
            }
            pub fn getArrow(self: *const FileOrFilesReader, allocator: std.mem.Allocator) gremlin.Error!ReadRel.LocalFiles.FileOrFiles.ArrowReadOptionsReader {
                if (self._arrow_buf) |buf| {
                    return try ReadRel.LocalFiles.FileOrFiles.ArrowReadOptionsReader.init(allocator, buf);
                }
                return try ReadRel.LocalFiles.FileOrFiles.ArrowReadOptionsReader.init(allocator, &[_]u8{});
            }
            pub fn getOrc(self: *const FileOrFilesReader, allocator: std.mem.Allocator) gremlin.Error!ReadRel.LocalFiles.FileOrFiles.OrcReadOptionsReader {
                if (self._orc_buf) |buf| {
                    return try ReadRel.LocalFiles.FileOrFiles.OrcReadOptionsReader.init(allocator, buf);
                }
                return try ReadRel.LocalFiles.FileOrFiles.OrcReadOptionsReader.init(allocator, &[_]u8{});
            }
            pub fn getExtension(self: *const FileOrFilesReader, allocator: std.mem.Allocator) gremlin.Error!any.AnyReader {
                if (self._extension_buf) |buf| {
                    return try any.AnyReader.init(allocator, buf);
                }
                return try any.AnyReader.init(allocator, &[_]u8{});
            }
            pub fn getDwrf(self: *const FileOrFilesReader, allocator: std.mem.Allocator) gremlin.Error!ReadRel.LocalFiles.FileOrFiles.DwrfReadOptionsReader {
                if (self._dwrf_buf) |buf| {
                    return try ReadRel.LocalFiles.FileOrFiles.DwrfReadOptionsReader.init(allocator, buf);
                }
                return try ReadRel.LocalFiles.FileOrFiles.DwrfReadOptionsReader.init(allocator, &[_]u8{});
            }
            pub fn getText(self: *const FileOrFilesReader, allocator: std.mem.Allocator) gremlin.Error!ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsReader {
                if (self._text_buf) |buf| {
                    return try ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsReader.init(allocator, buf);
                }
                return try ReadRel.LocalFiles.FileOrFiles.DelimiterSeparatedTextReadOptionsReader.init(allocator, &[_]u8{});
            }
        };
        
        // fields
        items: ?[]const ?ReadRel.LocalFiles.FileOrFiles = null,
        advanced_extension: ?extensions.AdvancedExtension = null,

        pub fn calcProtobufSize(self: *const LocalFiles) usize {
            var res: usize = 0;
            if (self.items) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFilesWire.ITEMS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.advanced_extension) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ReadRel.LocalFilesWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const LocalFiles, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const LocalFiles, target: *gremlin.Writer) void {
            if (self.items) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(ReadRel.LocalFilesWire.ITEMS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(ReadRel.LocalFilesWire.ITEMS_WIRE, 0);
                    }
                }
            }
            if (self.advanced_extension) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ReadRel.LocalFilesWire.ADVANCED_EXTENSION_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const LocalFilesReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _items_bufs: ?std.ArrayList([]const u8) = null,
        _advanced_extension_buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!LocalFilesReader {
            var buf = gremlin.Reader.init(src);
            var res = LocalFilesReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ReadRel.LocalFilesWire.ITEMS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._items_bufs == null) {
                            res._items_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._items_bufs.?.append(result.value);
                    },
                    ReadRel.LocalFilesWire.ADVANCED_EXTENSION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._advanced_extension_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const LocalFilesReader) void {
            if (self._items_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getItems(self: *const LocalFilesReader, allocator: std.mem.Allocator) gremlin.Error![]ReadRel.LocalFiles.FileOrFilesReader {
            if (self._items_bufs) |bufs| {
                var result = try std.ArrayList(ReadRel.LocalFiles.FileOrFilesReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try ReadRel.LocalFiles.FileOrFilesReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]ReadRel.LocalFiles.FileOrFilesReader{};
        }
        pub fn getAdvancedExtension(self: *const LocalFilesReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
            if (self._advanced_extension_buf) |buf| {
                return try extensions.AdvancedExtensionReader.init(allocator, buf);
            }
            return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
        }
    };
    
    // fields
    common: ?RelCommon = null,
    base_schema: ?type.NamedStruct = null,
    filter: ?Expression = null,
    best_effort_filter: ?Expression = null,
    projection: ?Expression.MaskExpression = null,
    advanced_extension: ?extensions.AdvancedExtension = null,
    virtual_table: ?ReadRel.VirtualTable = null,
    local_files: ?ReadRel.LocalFiles = null,
    named_table: ?ReadRel.NamedTable = null,
    extension_table: ?ReadRel.ExtensionTable = null,

    pub fn calcProtobufSize(self: *const ReadRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ReadRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.base_schema) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ReadRelWire.BASE_SCHEMA_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.filter) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ReadRelWire.FILTER_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.best_effort_filter) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ReadRelWire.BEST_EFFORT_FILTER_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.projection) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ReadRelWire.PROJECTION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ReadRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.virtual_table) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ReadRelWire.VIRTUAL_TABLE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.local_files) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ReadRelWire.LOCAL_FILES_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.named_table) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ReadRelWire.NAMED_TABLE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.extension_table) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ReadRelWire.EXTENSION_TABLE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const ReadRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ReadRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ReadRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.base_schema) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ReadRelWire.BASE_SCHEMA_WIRE, size);
            v.encodeTo(target);
        }
        if (self.filter) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ReadRelWire.FILTER_WIRE, size);
            v.encodeTo(target);
        }
        if (self.best_effort_filter) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ReadRelWire.BEST_EFFORT_FILTER_WIRE, size);
            v.encodeTo(target);
        }
        if (self.projection) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ReadRelWire.PROJECTION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ReadRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.virtual_table) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ReadRelWire.VIRTUAL_TABLE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.local_files) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ReadRelWire.LOCAL_FILES_WIRE, size);
            v.encodeTo(target);
        }
        if (self.named_table) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ReadRelWire.NAMED_TABLE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.extension_table) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ReadRelWire.EXTENSION_TABLE_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ReadRelReader = struct {
    _common_buf: ?[]const u8 = null,
    _base_schema_buf: ?[]const u8 = null,
    _filter_buf: ?[]const u8 = null,
    _best_effort_filter_buf: ?[]const u8 = null,
    _projection_buf: ?[]const u8 = null,
    _advanced_extension_buf: ?[]const u8 = null,
    _virtual_table_buf: ?[]const u8 = null,
    _local_files_buf: ?[]const u8 = null,
    _named_table_buf: ?[]const u8 = null,
    _extension_table_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ReadRelReader {
        var buf = gremlin.Reader.init(src);
        var res = ReadRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ReadRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                ReadRelWire.BASE_SCHEMA_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._base_schema_buf = result.value;
                },
                ReadRelWire.FILTER_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._filter_buf = result.value;
                },
                ReadRelWire.BEST_EFFORT_FILTER_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._best_effort_filter_buf = result.value;
                },
                ReadRelWire.PROJECTION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._projection_buf = result.value;
                },
                ReadRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                ReadRelWire.VIRTUAL_TABLE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._virtual_table_buf = result.value;
                },
                ReadRelWire.LOCAL_FILES_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._local_files_buf = result.value;
                },
                ReadRelWire.NAMED_TABLE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._named_table_buf = result.value;
                },
                ReadRelWire.EXTENSION_TABLE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._extension_table_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const ReadRelReader) void { }
    
    pub fn getCommon(self: *const ReadRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getBaseSchema(self: *const ReadRelReader, allocator: std.mem.Allocator) gremlin.Error!type.NamedStructReader {
        if (self._base_schema_buf) |buf| {
            return try type.NamedStructReader.init(allocator, buf);
        }
        return try type.NamedStructReader.init(allocator, &[_]u8{});
    }
    pub fn getFilter(self: *const ReadRelReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._filter_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
    pub fn getBestEffortFilter(self: *const ReadRelReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._best_effort_filter_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
    pub fn getProjection(self: *const ReadRelReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpressionReader {
        if (self._projection_buf) |buf| {
            return try Expression.MaskExpressionReader.init(allocator, buf);
        }
        return try Expression.MaskExpressionReader.init(allocator, &[_]u8{});
    }
    pub fn getAdvancedExtension(self: *const ReadRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
    pub fn getVirtualTable(self: *const ReadRelReader, allocator: std.mem.Allocator) gremlin.Error!ReadRel.VirtualTableReader {
        if (self._virtual_table_buf) |buf| {
            return try ReadRel.VirtualTableReader.init(allocator, buf);
        }
        return try ReadRel.VirtualTableReader.init(allocator, &[_]u8{});
    }
    pub fn getLocalFiles(self: *const ReadRelReader, allocator: std.mem.Allocator) gremlin.Error!ReadRel.LocalFilesReader {
        if (self._local_files_buf) |buf| {
            return try ReadRel.LocalFilesReader.init(allocator, buf);
        }
        return try ReadRel.LocalFilesReader.init(allocator, &[_]u8{});
    }
    pub fn getNamedTable(self: *const ReadRelReader, allocator: std.mem.Allocator) gremlin.Error!ReadRel.NamedTableReader {
        if (self._named_table_buf) |buf| {
            return try ReadRel.NamedTableReader.init(allocator, buf);
        }
        return try ReadRel.NamedTableReader.init(allocator, &[_]u8{});
    }
    pub fn getExtensionTable(self: *const ReadRelReader, allocator: std.mem.Allocator) gremlin.Error!ReadRel.ExtensionTableReader {
        if (self._extension_table_buf) |buf| {
            return try ReadRel.ExtensionTableReader.init(allocator, buf);
        }
        return try ReadRel.ExtensionTableReader.init(allocator, &[_]u8{});
    }
};

const ProjectRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const INPUT_WIRE: gremlin.ProtoWireNumber = 2;
    const EXPRESSIONS_WIRE: gremlin.ProtoWireNumber = 3;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const ProjectRel = struct {
    // fields
    common: ?RelCommon = null,
    input: ?Rel = null,
    expressions: ?[]const ?Expression = null,
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const ProjectRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ProjectRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ProjectRelWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.expressions) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(ProjectRelWire.EXPRESSIONS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ProjectRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const ProjectRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ProjectRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ProjectRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ProjectRelWire.INPUT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.expressions) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ProjectRelWire.EXPRESSIONS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(ProjectRelWire.EXPRESSIONS_WIRE, 0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ProjectRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ProjectRelReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _common_buf: ?[]const u8 = null,
    _input_buf: ?[]const u8 = null,
    _expressions_bufs: ?std.ArrayList([]const u8) = null,
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ProjectRelReader {
        var buf = gremlin.Reader.init(src);
        var res = ProjectRelReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ProjectRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                ProjectRelWire.INPUT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._input_buf = result.value;
                },
                ProjectRelWire.EXPRESSIONS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._expressions_bufs == null) {
                        res._expressions_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._expressions_bufs.?.append(result.value);
                },
                ProjectRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const ProjectRelReader) void {
        if (self._expressions_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getCommon(self: *const ProjectRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getInput(self: *const ProjectRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._input_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getExpressions(self: *const ProjectRelReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
        if (self._expressions_bufs) |bufs| {
            var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try ExpressionReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]ExpressionReader{};
    }
    pub fn getAdvancedExtension(self: *const ProjectRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const JoinRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const LEFT_WIRE: gremlin.ProtoWireNumber = 2;
    const RIGHT_WIRE: gremlin.ProtoWireNumber = 3;
    const EXPRESSION_WIRE: gremlin.ProtoWireNumber = 4;
    const POST_JOIN_FILTER_WIRE: gremlin.ProtoWireNumber = 5;
    const TYPE_WIRE: gremlin.ProtoWireNumber = 6;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const JoinRel = struct {
    // nested enums
    pub const JoinType = enum(i32) {
        JOIN_TYPE_UNSPECIFIED = 0,
        JOIN_TYPE_INNER = 1,
        JOIN_TYPE_OUTER = 2,
        JOIN_TYPE_LEFT = 3,
        JOIN_TYPE_RIGHT = 4,
        JOIN_TYPE_LEFT_SEMI = 5,
        JOIN_TYPE_LEFT_ANTI = 6,
        JOIN_TYPE_LEFT_SINGLE = 7,
        JOIN_TYPE_RIGHT_SEMI = 8,
        JOIN_TYPE_RIGHT_ANTI = 9,
        JOIN_TYPE_RIGHT_SINGLE = 10,
        JOIN_TYPE_LEFT_MARK = 11,
        JOIN_TYPE_RIGHT_MARK = 12,
    };
    
    // fields
    common: ?RelCommon = null,
    left: ?Rel = null,
    right: ?Rel = null,
    expression: ?Expression = null,
    post_join_filter: ?Expression = null,
    type: JoinRel.JoinType = @enumFromInt(0),
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const JoinRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(JoinRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(JoinRelWire.LEFT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(JoinRelWire.RIGHT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.expression) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(JoinRelWire.EXPRESSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.post_join_filter) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(JoinRelWire.POST_JOIN_FILTER_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (@intFromEnum(self.type) != 0) { res += gremlin.sizes.sizeWireNumber(JoinRelWire.TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.type)); }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(JoinRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const JoinRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const JoinRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(JoinRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(JoinRelWire.LEFT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(JoinRelWire.RIGHT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.expression) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(JoinRelWire.EXPRESSION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.post_join_filter) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(JoinRelWire.POST_JOIN_FILTER_WIRE, size);
            v.encodeTo(target);
        }
        if (@intFromEnum(self.type) != 0) { target.appendInt32(JoinRelWire.TYPE_WIRE, @intFromEnum(self.type)); }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(JoinRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const JoinRelReader = struct {
    _common_buf: ?[]const u8 = null,
    _left_buf: ?[]const u8 = null,
    _right_buf: ?[]const u8 = null,
    _expression_buf: ?[]const u8 = null,
    _post_join_filter_buf: ?[]const u8 = null,
    _type: JoinRel.JoinType = @enumFromInt(0),
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!JoinRelReader {
        var buf = gremlin.Reader.init(src);
        var res = JoinRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                JoinRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                JoinRelWire.LEFT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._left_buf = result.value;
                },
                JoinRelWire.RIGHT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._right_buf = result.value;
                },
                JoinRelWire.EXPRESSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._expression_buf = result.value;
                },
                JoinRelWire.POST_JOIN_FILTER_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._post_join_filter_buf = result.value;
                },
                JoinRelWire.TYPE_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._type = @enumFromInt(result.value);
                },
                JoinRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const JoinRelReader) void { }
    
    pub fn getCommon(self: *const JoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getLeft(self: *const JoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._left_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getRight(self: *const JoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._right_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getExpression(self: *const JoinRelReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._expression_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
    pub fn getPostJoinFilter(self: *const JoinRelReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._post_join_filter_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
    pub inline fn getType(self: *const JoinRelReader) JoinRel.JoinType { return self._type; }
    pub fn getAdvancedExtension(self: *const JoinRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const CrossRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const LEFT_WIRE: gremlin.ProtoWireNumber = 2;
    const RIGHT_WIRE: gremlin.ProtoWireNumber = 3;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const CrossRel = struct {
    // fields
    common: ?RelCommon = null,
    left: ?Rel = null,
    right: ?Rel = null,
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const CrossRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(CrossRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(CrossRelWire.LEFT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(CrossRelWire.RIGHT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(CrossRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const CrossRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const CrossRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(CrossRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(CrossRelWire.LEFT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(CrossRelWire.RIGHT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(CrossRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const CrossRelReader = struct {
    _common_buf: ?[]const u8 = null,
    _left_buf: ?[]const u8 = null,
    _right_buf: ?[]const u8 = null,
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!CrossRelReader {
        var buf = gremlin.Reader.init(src);
        var res = CrossRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                CrossRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                CrossRelWire.LEFT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._left_buf = result.value;
                },
                CrossRelWire.RIGHT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._right_buf = result.value;
                },
                CrossRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const CrossRelReader) void { }
    
    pub fn getCommon(self: *const CrossRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getLeft(self: *const CrossRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._left_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getRight(self: *const CrossRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._right_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getAdvancedExtension(self: *const CrossRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const FetchRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const INPUT_WIRE: gremlin.ProtoWireNumber = 2;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
    const OFFSET_WIRE: gremlin.ProtoWireNumber = 3;
    const OFFSET_EXPR_WIRE: gremlin.ProtoWireNumber = 5;
    const COUNT_WIRE: gremlin.ProtoWireNumber = 4;
    const COUNT_EXPR_WIRE: gremlin.ProtoWireNumber = 6;
};

pub const FetchRel = struct {
    // fields
    common: ?RelCommon = null,
    input: ?Rel = null,
    advanced_extension: ?extensions.AdvancedExtension = null,
    offset: i64 = 0,
    offset_expr: ?Expression = null,
    count: i64 = 0,
    count_expr: ?Expression = null,

    pub fn calcProtobufSize(self: *const FetchRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(FetchRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(FetchRelWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(FetchRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.offset != 0) { res += gremlin.sizes.sizeWireNumber(FetchRelWire.OFFSET_WIRE) + gremlin.sizes.sizeI64(self.offset); }
        if (self.offset_expr) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(FetchRelWire.OFFSET_EXPR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.count != 0) { res += gremlin.sizes.sizeWireNumber(FetchRelWire.COUNT_WIRE) + gremlin.sizes.sizeI64(self.count); }
        if (self.count_expr) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(FetchRelWire.COUNT_EXPR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const FetchRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const FetchRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(FetchRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(FetchRelWire.INPUT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(FetchRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.offset != 0) { target.appendInt64(FetchRelWire.OFFSET_WIRE, self.offset); }
        if (self.offset_expr) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(FetchRelWire.OFFSET_EXPR_WIRE, size);
            v.encodeTo(target);
        }
        if (self.count != 0) { target.appendInt64(FetchRelWire.COUNT_WIRE, self.count); }
        if (self.count_expr) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(FetchRelWire.COUNT_EXPR_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const FetchRelReader = struct {
    _common_buf: ?[]const u8 = null,
    _input_buf: ?[]const u8 = null,
    _advanced_extension_buf: ?[]const u8 = null,
    _offset: i64 = 0,
    _offset_expr_buf: ?[]const u8 = null,
    _count: i64 = 0,
    _count_expr_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!FetchRelReader {
        var buf = gremlin.Reader.init(src);
        var res = FetchRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                FetchRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                FetchRelWire.INPUT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._input_buf = result.value;
                },
                FetchRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                FetchRelWire.OFFSET_WIRE => {
                  const result = try buf.readInt64(offset);
                  offset += result.size;
                  res._offset = result.value;
                },
                FetchRelWire.OFFSET_EXPR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._offset_expr_buf = result.value;
                },
                FetchRelWire.COUNT_WIRE => {
                  const result = try buf.readInt64(offset);
                  offset += result.size;
                  res._count = result.value;
                },
                FetchRelWire.COUNT_EXPR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._count_expr_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const FetchRelReader) void { }
    
    pub fn getCommon(self: *const FetchRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getInput(self: *const FetchRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._input_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getAdvancedExtension(self: *const FetchRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
    pub inline fn getOffset(self: *const FetchRelReader) i64 { return self._offset; }
    pub fn getOffsetExpr(self: *const FetchRelReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._offset_expr_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
    pub inline fn getCount(self: *const FetchRelReader) i64 { return self._count; }
    pub fn getCountExpr(self: *const FetchRelReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._count_expr_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
};

const AggregateRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const INPUT_WIRE: gremlin.ProtoWireNumber = 2;
    const GROUPINGS_WIRE: gremlin.ProtoWireNumber = 3;
    const MEASURES_WIRE: gremlin.ProtoWireNumber = 4;
    const GROUPING_EXPRESSIONS_WIRE: gremlin.ProtoWireNumber = 5;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const AggregateRel = struct {
    // nested structs
    const GroupingWire = struct {
        const GROUPING_EXPRESSIONS_WIRE: gremlin.ProtoWireNumber = 1;
        const EXPRESSION_REFERENCES_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const Grouping = struct {
        // fields
        grouping_expressions: ?[]const ?Expression = null,
        expression_references: ?[]const u32 = null,

        pub fn calcProtobufSize(self: *const Grouping) usize {
            var res: usize = 0;
            if (self.grouping_expressions) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(AggregateRel.GroupingWire.GROUPING_EXPRESSIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.expression_references) |arr| {
                if (arr.len == 0) {
                } else if (arr.len == 1) {
                    res += gremlin.sizes.sizeWireNumber(AggregateRel.GroupingWire.EXPRESSION_REFERENCES_WIRE) + gremlin.sizes.sizeU32(arr[0]);
                } else {
                    var packed_size: usize = 0;
                    for (arr) |v| {
                        packed_size += gremlin.sizes.sizeU32(v);
                    }
                    res += gremlin.sizes.sizeWireNumber(AggregateRel.GroupingWire.EXPRESSION_REFERENCES_WIRE) + gremlin.sizes.sizeUsize(packed_size) + packed_size;
                }
            }
            return res;
        }

        pub fn encode(self: *const Grouping, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Grouping, target: *gremlin.Writer) void {
            if (self.grouping_expressions) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(AggregateRel.GroupingWire.GROUPING_EXPRESSIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(AggregateRel.GroupingWire.GROUPING_EXPRESSIONS_WIRE, 0);
                    }
                }
            }
            if (self.expression_references) |arr| {
                if (arr.len == 0) {
                } else if (arr.len == 1) {
                    target.appendUint32(AggregateRel.GroupingWire.EXPRESSION_REFERENCES_WIRE, arr[0]);
                } else {
                    var packed_size: usize = 0;
                    for (arr) |v| {
                        packed_size += gremlin.sizes.sizeU32(v);
                    }
                    target.appendBytesTag(AggregateRel.GroupingWire.EXPRESSION_REFERENCES_WIRE, packed_size);
                    for (arr) |v| {
                        target.appendUint32WithoutTag(v);
                    }
                }
            }
        }
    };
    
    pub const GroupingReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _grouping_expressions_bufs: ?std.ArrayList([]const u8) = null,
        _expression_references_offsets: ?std.ArrayList(usize) = null,
        _expression_references_wires: ?std.ArrayList(gremlin.ProtoWireType) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!GroupingReader {
            var buf = gremlin.Reader.init(src);
            var res = GroupingReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    AggregateRel.GroupingWire.GROUPING_EXPRESSIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._grouping_expressions_bufs == null) {
                            res._grouping_expressions_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._grouping_expressions_bufs.?.append(result.value);
                    },
                    AggregateRel.GroupingWire.EXPRESSION_REFERENCES_WIRE => {
                        if (res._expression_references_offsets == null) {
                            res._expression_references_offsets = std.ArrayList(usize).init(allocator);
                            res._expression_references_wires = std.ArrayList(gremlin.ProtoWireType).init(allocator);
                        }
                        try res._expression_references_offsets.?.append(offset);
                        try res._expression_references_wires.?.append(tag.wire);
                        if (tag.wire == gremlin.ProtoWireType.bytes) {
                            const length_result = try buf.readVarInt(offset);
                            offset += length_result.size + length_result.value;
                        } else {
                            const result = try buf.readUInt32(offset);
                            offset += result.size;
                        }
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const GroupingReader) void {
            if (self._grouping_expressions_bufs) |arr| {
                arr.deinit();
            }
            if (self._expression_references_offsets) |arr| {
                arr.deinit();
            }
            if (self._expression_references_wires) |arr| {
                arr.deinit();
            }
        }
        pub fn getGroupingExpressions(self: *const GroupingReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
            if (self._grouping_expressions_bufs) |bufs| {
                var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try ExpressionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]ExpressionReader{};
        }
        pub fn getExpressionReferences(self: *const GroupingReader, allocator: std.mem.Allocator) gremlin.Error![]u32 {
            if (self._expression_references_offsets) |offsets| {
                if (offsets.items.len == 0) return &[_]u32{};
        
                var result = std.ArrayList(u32).init(allocator);
                errdefer result.deinit();
        
                for (offsets.items, self._expression_references_wires.?.items) |start_offset, wire_type| {
                    if (wire_type == .bytes) {
                        const length_result = try self.buf.readVarInt(start_offset);
                        var offset = start_offset + length_result.size;
                        const end_offset = offset + length_result.value;
        
                        while (offset < end_offset) {
                            const value_result = try self.buf.readUInt32(offset);
                            try result.append(value_result.value);
                            offset += value_result.size;
                        }
                    } else {
                        const value_result = try self.buf.readUInt32(start_offset);
                        try result.append(value_result.value);
                    }
                }
                return result.toOwnedSlice();
            }
            return &[_]u32{};
        }
    };
    
    const MeasureWire = struct {
        const MEASURE_WIRE: gremlin.ProtoWireNumber = 1;
        const FILTER_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const Measure = struct {
        // fields
        measure: ?AggregateFunction = null,
        filter: ?Expression = null,

        pub fn calcProtobufSize(self: *const Measure) usize {
            var res: usize = 0;
            if (self.measure) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(AggregateRel.MeasureWire.MEASURE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.filter) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(AggregateRel.MeasureWire.FILTER_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const Measure, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Measure, target: *gremlin.Writer) void {
            if (self.measure) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(AggregateRel.MeasureWire.MEASURE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.filter) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(AggregateRel.MeasureWire.FILTER_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const MeasureReader = struct {
        _measure_buf: ?[]const u8 = null,
        _filter_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!MeasureReader {
            var buf = gremlin.Reader.init(src);
            var res = MeasureReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    AggregateRel.MeasureWire.MEASURE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._measure_buf = result.value;
                    },
                    AggregateRel.MeasureWire.FILTER_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._filter_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const MeasureReader) void { }
        
        pub fn getMeasure(self: *const MeasureReader, allocator: std.mem.Allocator) gremlin.Error!AggregateFunctionReader {
            if (self._measure_buf) |buf| {
                return try AggregateFunctionReader.init(allocator, buf);
            }
            return try AggregateFunctionReader.init(allocator, &[_]u8{});
        }
        pub fn getFilter(self: *const MeasureReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
            if (self._filter_buf) |buf| {
                return try ExpressionReader.init(allocator, buf);
            }
            return try ExpressionReader.init(allocator, &[_]u8{});
        }
    };
    
    // fields
    common: ?RelCommon = null,
    input: ?Rel = null,
    groupings: ?[]const ?AggregateRel.Grouping = null,
    measures: ?[]const ?AggregateRel.Measure = null,
    grouping_expressions: ?[]const ?Expression = null,
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const AggregateRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(AggregateRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(AggregateRelWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.groupings) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(AggregateRelWire.GROUPINGS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.measures) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(AggregateRelWire.MEASURES_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.grouping_expressions) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(AggregateRelWire.GROUPING_EXPRESSIONS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(AggregateRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const AggregateRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const AggregateRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(AggregateRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(AggregateRelWire.INPUT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.groupings) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(AggregateRelWire.GROUPINGS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(AggregateRelWire.GROUPINGS_WIRE, 0);
                }
            }
        }
        if (self.measures) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(AggregateRelWire.MEASURES_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(AggregateRelWire.MEASURES_WIRE, 0);
                }
            }
        }
        if (self.grouping_expressions) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(AggregateRelWire.GROUPING_EXPRESSIONS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(AggregateRelWire.GROUPING_EXPRESSIONS_WIRE, 0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(AggregateRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const AggregateRelReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _common_buf: ?[]const u8 = null,
    _input_buf: ?[]const u8 = null,
    _groupings_bufs: ?std.ArrayList([]const u8) = null,
    _measures_bufs: ?std.ArrayList([]const u8) = null,
    _grouping_expressions_bufs: ?std.ArrayList([]const u8) = null,
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!AggregateRelReader {
        var buf = gremlin.Reader.init(src);
        var res = AggregateRelReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                AggregateRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                AggregateRelWire.INPUT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._input_buf = result.value;
                },
                AggregateRelWire.GROUPINGS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._groupings_bufs == null) {
                        res._groupings_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._groupings_bufs.?.append(result.value);
                },
                AggregateRelWire.MEASURES_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._measures_bufs == null) {
                        res._measures_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._measures_bufs.?.append(result.value);
                },
                AggregateRelWire.GROUPING_EXPRESSIONS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._grouping_expressions_bufs == null) {
                        res._grouping_expressions_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._grouping_expressions_bufs.?.append(result.value);
                },
                AggregateRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const AggregateRelReader) void {
        if (self._groupings_bufs) |arr| {
            arr.deinit();
        }
        if (self._measures_bufs) |arr| {
            arr.deinit();
        }
        if (self._grouping_expressions_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getCommon(self: *const AggregateRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getInput(self: *const AggregateRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._input_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getGroupings(self: *const AggregateRelReader, allocator: std.mem.Allocator) gremlin.Error![]AggregateRel.GroupingReader {
        if (self._groupings_bufs) |bufs| {
            var result = try std.ArrayList(AggregateRel.GroupingReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try AggregateRel.GroupingReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]AggregateRel.GroupingReader{};
    }
    pub fn getMeasures(self: *const AggregateRelReader, allocator: std.mem.Allocator) gremlin.Error![]AggregateRel.MeasureReader {
        if (self._measures_bufs) |bufs| {
            var result = try std.ArrayList(AggregateRel.MeasureReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try AggregateRel.MeasureReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]AggregateRel.MeasureReader{};
    }
    pub fn getGroupingExpressions(self: *const AggregateRelReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
        if (self._grouping_expressions_bufs) |bufs| {
            var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try ExpressionReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]ExpressionReader{};
    }
    pub fn getAdvancedExtension(self: *const AggregateRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const ConsistentPartitionWindowRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const INPUT_WIRE: gremlin.ProtoWireNumber = 2;
    const WINDOW_FUNCTIONS_WIRE: gremlin.ProtoWireNumber = 3;
    const PARTITION_EXPRESSIONS_WIRE: gremlin.ProtoWireNumber = 4;
    const SORTS_WIRE: gremlin.ProtoWireNumber = 5;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const ConsistentPartitionWindowRel = struct {
    // nested structs
    const WindowRelFunctionWire = struct {
        const FUNCTION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const ARGUMENTS_WIRE: gremlin.ProtoWireNumber = 9;
        const OPTIONS_WIRE: gremlin.ProtoWireNumber = 11;
        const OUTPUT_TYPE_WIRE: gremlin.ProtoWireNumber = 7;
        const PHASE_WIRE: gremlin.ProtoWireNumber = 6;
        const INVOCATION_WIRE: gremlin.ProtoWireNumber = 10;
        const LOWER_BOUND_WIRE: gremlin.ProtoWireNumber = 5;
        const UPPER_BOUND_WIRE: gremlin.ProtoWireNumber = 4;
        const BOUNDS_TYPE_WIRE: gremlin.ProtoWireNumber = 12;
    };
    
    pub const WindowRelFunction = struct {
        // fields
        function_reference: u32 = 0,
        arguments: ?[]const ?FunctionArgument = null,
        options: ?[]const ?FunctionOption = null,
        output_type: ?type.Type = null,
        phase: AggregationPhase = @enumFromInt(0),
        invocation: AggregateFunction.AggregationInvocation = @enumFromInt(0),
        lower_bound: ?Expression.WindowFunction.Bound = null,
        upper_bound: ?Expression.WindowFunction.Bound = null,
        bounds_type: Expression.WindowFunction.BoundsType = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const WindowRelFunction) usize {
            var res: usize = 0;
            if (self.function_reference != 0) { res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRel.WindowRelFunctionWire.FUNCTION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.function_reference); }
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRel.WindowRelFunctionWire.ARGUMENTS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.options) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRel.WindowRelFunctionWire.OPTIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRel.WindowRelFunctionWire.OUTPUT_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (@intFromEnum(self.phase) != 0) { res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRel.WindowRelFunctionWire.PHASE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.phase)); }
            if (@intFromEnum(self.invocation) != 0) { res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRel.WindowRelFunctionWire.INVOCATION_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.invocation)); }
            if (self.lower_bound) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRel.WindowRelFunctionWire.LOWER_BOUND_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.upper_bound) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRel.WindowRelFunctionWire.UPPER_BOUND_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (@intFromEnum(self.bounds_type) != 0) { res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRel.WindowRelFunctionWire.BOUNDS_TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.bounds_type)); }
            return res;
        }

        pub fn encode(self: *const WindowRelFunction, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const WindowRelFunction, target: *gremlin.Writer) void {
            if (self.function_reference != 0) { target.appendUint32(ConsistentPartitionWindowRel.WindowRelFunctionWire.FUNCTION_REFERENCE_WIRE, self.function_reference); }
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(ConsistentPartitionWindowRel.WindowRelFunctionWire.ARGUMENTS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(ConsistentPartitionWindowRel.WindowRelFunctionWire.ARGUMENTS_WIRE, 0);
                    }
                }
            }
            if (self.options) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(ConsistentPartitionWindowRel.WindowRelFunctionWire.OPTIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(ConsistentPartitionWindowRel.WindowRelFunctionWire.OPTIONS_WIRE, 0);
                    }
                }
            }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ConsistentPartitionWindowRel.WindowRelFunctionWire.OUTPUT_TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (@intFromEnum(self.phase) != 0) { target.appendInt32(ConsistentPartitionWindowRel.WindowRelFunctionWire.PHASE_WIRE, @intFromEnum(self.phase)); }
            if (@intFromEnum(self.invocation) != 0) { target.appendInt32(ConsistentPartitionWindowRel.WindowRelFunctionWire.INVOCATION_WIRE, @intFromEnum(self.invocation)); }
            if (self.lower_bound) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ConsistentPartitionWindowRel.WindowRelFunctionWire.LOWER_BOUND_WIRE, size);
                v.encodeTo(target);
            }
            if (self.upper_bound) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ConsistentPartitionWindowRel.WindowRelFunctionWire.UPPER_BOUND_WIRE, size);
                v.encodeTo(target);
            }
            if (@intFromEnum(self.bounds_type) != 0) { target.appendInt32(ConsistentPartitionWindowRel.WindowRelFunctionWire.BOUNDS_TYPE_WIRE, @intFromEnum(self.bounds_type)); }
        }
    };
    
    pub const WindowRelFunctionReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _function_reference: u32 = 0,
        _arguments_bufs: ?std.ArrayList([]const u8) = null,
        _options_bufs: ?std.ArrayList([]const u8) = null,
        _output_type_buf: ?[]const u8 = null,
        _phase: AggregationPhase = @enumFromInt(0),
        _invocation: AggregateFunction.AggregationInvocation = @enumFromInt(0),
        _lower_bound_buf: ?[]const u8 = null,
        _upper_bound_buf: ?[]const u8 = null,
        _bounds_type: Expression.WindowFunction.BoundsType = @enumFromInt(0),

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!WindowRelFunctionReader {
            var buf = gremlin.Reader.init(src);
            var res = WindowRelFunctionReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ConsistentPartitionWindowRel.WindowRelFunctionWire.FUNCTION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._function_reference = result.value;
                    },
                    ConsistentPartitionWindowRel.WindowRelFunctionWire.ARGUMENTS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._arguments_bufs == null) {
                            res._arguments_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._arguments_bufs.?.append(result.value);
                    },
                    ConsistentPartitionWindowRel.WindowRelFunctionWire.OPTIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._options_bufs == null) {
                            res._options_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._options_bufs.?.append(result.value);
                    },
                    ConsistentPartitionWindowRel.WindowRelFunctionWire.OUTPUT_TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._output_type_buf = result.value;
                    },
                    ConsistentPartitionWindowRel.WindowRelFunctionWire.PHASE_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._phase = @enumFromInt(result.value);
                    },
                    ConsistentPartitionWindowRel.WindowRelFunctionWire.INVOCATION_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._invocation = @enumFromInt(result.value);
                    },
                    ConsistentPartitionWindowRel.WindowRelFunctionWire.LOWER_BOUND_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._lower_bound_buf = result.value;
                    },
                    ConsistentPartitionWindowRel.WindowRelFunctionWire.UPPER_BOUND_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._upper_bound_buf = result.value;
                    },
                    ConsistentPartitionWindowRel.WindowRelFunctionWire.BOUNDS_TYPE_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._bounds_type = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const WindowRelFunctionReader) void {
            if (self._arguments_bufs) |arr| {
                arr.deinit();
            }
            if (self._options_bufs) |arr| {
                arr.deinit();
            }
        }
        pub inline fn getFunctionReference(self: *const WindowRelFunctionReader) u32 { return self._function_reference; }
        pub fn getArguments(self: *const WindowRelFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionArgumentReader {
            if (self._arguments_bufs) |bufs| {
                var result = try std.ArrayList(FunctionArgumentReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionArgumentReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionArgumentReader{};
        }
        pub fn getOptions(self: *const WindowRelFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionOptionReader {
            if (self._options_bufs) |bufs| {
                var result = try std.ArrayList(FunctionOptionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionOptionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionOptionReader{};
        }
        pub fn getOutputType(self: *const WindowRelFunctionReader, allocator: std.mem.Allocator) gremlin.Error!type.TypeReader {
            if (self._output_type_buf) |buf| {
                return try type.TypeReader.init(allocator, buf);
            }
            return try type.TypeReader.init(allocator, &[_]u8{});
        }
        pub inline fn getPhase(self: *const WindowRelFunctionReader) AggregationPhase { return self._phase; }
        pub inline fn getInvocation(self: *const WindowRelFunctionReader) AggregateFunction.AggregationInvocation { return self._invocation; }
        pub fn getLowerBound(self: *const WindowRelFunctionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.WindowFunction.BoundReader {
            if (self._lower_bound_buf) |buf| {
                return try Expression.WindowFunction.BoundReader.init(allocator, buf);
            }
            return try Expression.WindowFunction.BoundReader.init(allocator, &[_]u8{});
        }
        pub fn getUpperBound(self: *const WindowRelFunctionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.WindowFunction.BoundReader {
            if (self._upper_bound_buf) |buf| {
                return try Expression.WindowFunction.BoundReader.init(allocator, buf);
            }
            return try Expression.WindowFunction.BoundReader.init(allocator, &[_]u8{});
        }
        pub inline fn getBoundsType(self: *const WindowRelFunctionReader) Expression.WindowFunction.BoundsType { return self._bounds_type; }
    };
    
    // fields
    common: ?RelCommon = null,
    input: ?Rel = null,
    window_functions: ?[]const ?ConsistentPartitionWindowRel.WindowRelFunction = null,
    partition_expressions: ?[]const ?Expression = null,
    sorts: ?[]const ?SortField = null,
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const ConsistentPartitionWindowRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRelWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.window_functions) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRelWire.WINDOW_FUNCTIONS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.partition_expressions) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRelWire.PARTITION_EXPRESSIONS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.sorts) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRelWire.SORTS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ConsistentPartitionWindowRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const ConsistentPartitionWindowRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ConsistentPartitionWindowRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ConsistentPartitionWindowRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ConsistentPartitionWindowRelWire.INPUT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.window_functions) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ConsistentPartitionWindowRelWire.WINDOW_FUNCTIONS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(ConsistentPartitionWindowRelWire.WINDOW_FUNCTIONS_WIRE, 0);
                }
            }
        }
        if (self.partition_expressions) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ConsistentPartitionWindowRelWire.PARTITION_EXPRESSIONS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(ConsistentPartitionWindowRelWire.PARTITION_EXPRESSIONS_WIRE, 0);
                }
            }
        }
        if (self.sorts) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ConsistentPartitionWindowRelWire.SORTS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(ConsistentPartitionWindowRelWire.SORTS_WIRE, 0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ConsistentPartitionWindowRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ConsistentPartitionWindowRelReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _common_buf: ?[]const u8 = null,
    _input_buf: ?[]const u8 = null,
    _window_functions_bufs: ?std.ArrayList([]const u8) = null,
    _partition_expressions_bufs: ?std.ArrayList([]const u8) = null,
    _sorts_bufs: ?std.ArrayList([]const u8) = null,
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ConsistentPartitionWindowRelReader {
        var buf = gremlin.Reader.init(src);
        var res = ConsistentPartitionWindowRelReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ConsistentPartitionWindowRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                ConsistentPartitionWindowRelWire.INPUT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._input_buf = result.value;
                },
                ConsistentPartitionWindowRelWire.WINDOW_FUNCTIONS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._window_functions_bufs == null) {
                        res._window_functions_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._window_functions_bufs.?.append(result.value);
                },
                ConsistentPartitionWindowRelWire.PARTITION_EXPRESSIONS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._partition_expressions_bufs == null) {
                        res._partition_expressions_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._partition_expressions_bufs.?.append(result.value);
                },
                ConsistentPartitionWindowRelWire.SORTS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._sorts_bufs == null) {
                        res._sorts_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._sorts_bufs.?.append(result.value);
                },
                ConsistentPartitionWindowRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const ConsistentPartitionWindowRelReader) void {
        if (self._window_functions_bufs) |arr| {
            arr.deinit();
        }
        if (self._partition_expressions_bufs) |arr| {
            arr.deinit();
        }
        if (self._sorts_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getCommon(self: *const ConsistentPartitionWindowRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getInput(self: *const ConsistentPartitionWindowRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._input_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getWindowFunctions(self: *const ConsistentPartitionWindowRelReader, allocator: std.mem.Allocator) gremlin.Error![]ConsistentPartitionWindowRel.WindowRelFunctionReader {
        if (self._window_functions_bufs) |bufs| {
            var result = try std.ArrayList(ConsistentPartitionWindowRel.WindowRelFunctionReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try ConsistentPartitionWindowRel.WindowRelFunctionReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]ConsistentPartitionWindowRel.WindowRelFunctionReader{};
    }
    pub fn getPartitionExpressions(self: *const ConsistentPartitionWindowRelReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
        if (self._partition_expressions_bufs) |bufs| {
            var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try ExpressionReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]ExpressionReader{};
    }
    pub fn getSorts(self: *const ConsistentPartitionWindowRelReader, allocator: std.mem.Allocator) gremlin.Error![]SortFieldReader {
        if (self._sorts_bufs) |bufs| {
            var result = try std.ArrayList(SortFieldReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try SortFieldReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]SortFieldReader{};
    }
    pub fn getAdvancedExtension(self: *const ConsistentPartitionWindowRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const SortRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const INPUT_WIRE: gremlin.ProtoWireNumber = 2;
    const SORTS_WIRE: gremlin.ProtoWireNumber = 3;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const SortRel = struct {
    // fields
    common: ?RelCommon = null,
    input: ?Rel = null,
    sorts: ?[]const ?SortField = null,
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const SortRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(SortRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(SortRelWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.sorts) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(SortRelWire.SORTS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(SortRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const SortRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const SortRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(SortRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(SortRelWire.INPUT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.sorts) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(SortRelWire.SORTS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(SortRelWire.SORTS_WIRE, 0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(SortRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const SortRelReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _common_buf: ?[]const u8 = null,
    _input_buf: ?[]const u8 = null,
    _sorts_bufs: ?std.ArrayList([]const u8) = null,
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!SortRelReader {
        var buf = gremlin.Reader.init(src);
        var res = SortRelReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                SortRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                SortRelWire.INPUT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._input_buf = result.value;
                },
                SortRelWire.SORTS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._sorts_bufs == null) {
                        res._sorts_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._sorts_bufs.?.append(result.value);
                },
                SortRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const SortRelReader) void {
        if (self._sorts_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getCommon(self: *const SortRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getInput(self: *const SortRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._input_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getSorts(self: *const SortRelReader, allocator: std.mem.Allocator) gremlin.Error![]SortFieldReader {
        if (self._sorts_bufs) |bufs| {
            var result = try std.ArrayList(SortFieldReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try SortFieldReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]SortFieldReader{};
    }
    pub fn getAdvancedExtension(self: *const SortRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const FilterRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const INPUT_WIRE: gremlin.ProtoWireNumber = 2;
    const CONDITION_WIRE: gremlin.ProtoWireNumber = 3;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const FilterRel = struct {
    // fields
    common: ?RelCommon = null,
    input: ?Rel = null,
    condition: ?Expression = null,
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const FilterRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(FilterRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(FilterRelWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.condition) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(FilterRelWire.CONDITION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(FilterRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const FilterRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const FilterRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(FilterRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(FilterRelWire.INPUT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.condition) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(FilterRelWire.CONDITION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(FilterRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const FilterRelReader = struct {
    _common_buf: ?[]const u8 = null,
    _input_buf: ?[]const u8 = null,
    _condition_buf: ?[]const u8 = null,
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!FilterRelReader {
        var buf = gremlin.Reader.init(src);
        var res = FilterRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                FilterRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                FilterRelWire.INPUT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._input_buf = result.value;
                },
                FilterRelWire.CONDITION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._condition_buf = result.value;
                },
                FilterRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const FilterRelReader) void { }
    
    pub fn getCommon(self: *const FilterRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getInput(self: *const FilterRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._input_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getCondition(self: *const FilterRelReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._condition_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
    pub fn getAdvancedExtension(self: *const FilterRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const SetRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const INPUTS_WIRE: gremlin.ProtoWireNumber = 2;
    const OP_WIRE: gremlin.ProtoWireNumber = 3;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const SetRel = struct {
    // nested enums
    pub const SetOp = enum(i32) {
        SET_OP_UNSPECIFIED = 0,
        SET_OP_MINUS_PRIMARY = 1,
        SET_OP_MINUS_PRIMARY_ALL = 7,
        SET_OP_MINUS_MULTISET = 2,
        SET_OP_INTERSECTION_PRIMARY = 3,
        SET_OP_INTERSECTION_MULTISET = 4,
        SET_OP_INTERSECTION_MULTISET_ALL = 8,
        SET_OP_UNION_DISTINCT = 5,
        SET_OP_UNION_ALL = 6,
    };
    
    // fields
    common: ?RelCommon = null,
    inputs: ?[]const ?Rel = null,
    op: SetRel.SetOp = @enumFromInt(0),
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const SetRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(SetRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.inputs) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(SetRelWire.INPUTS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (@intFromEnum(self.op) != 0) { res += gremlin.sizes.sizeWireNumber(SetRelWire.OP_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.op)); }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(SetRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const SetRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const SetRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(SetRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.inputs) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(SetRelWire.INPUTS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(SetRelWire.INPUTS_WIRE, 0);
                }
            }
        }
        if (@intFromEnum(self.op) != 0) { target.appendInt32(SetRelWire.OP_WIRE, @intFromEnum(self.op)); }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(SetRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const SetRelReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _common_buf: ?[]const u8 = null,
    _inputs_bufs: ?std.ArrayList([]const u8) = null,
    _op: SetRel.SetOp = @enumFromInt(0),
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!SetRelReader {
        var buf = gremlin.Reader.init(src);
        var res = SetRelReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                SetRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                SetRelWire.INPUTS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._inputs_bufs == null) {
                        res._inputs_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._inputs_bufs.?.append(result.value);
                },
                SetRelWire.OP_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._op = @enumFromInt(result.value);
                },
                SetRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const SetRelReader) void {
        if (self._inputs_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getCommon(self: *const SetRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getInputs(self: *const SetRelReader, allocator: std.mem.Allocator) gremlin.Error![]RelReader {
        if (self._inputs_bufs) |bufs| {
            var result = try std.ArrayList(RelReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try RelReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]RelReader{};
    }
    pub inline fn getOp(self: *const SetRelReader) SetRel.SetOp { return self._op; }
    pub fn getAdvancedExtension(self: *const SetRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const ExtensionSingleRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const INPUT_WIRE: gremlin.ProtoWireNumber = 2;
    const DETAIL_WIRE: gremlin.ProtoWireNumber = 3;
};

pub const ExtensionSingleRel = struct {
    // fields
    common: ?RelCommon = null,
    input: ?Rel = null,
    detail: ?any.Any = null,

    pub fn calcProtobufSize(self: *const ExtensionSingleRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExtensionSingleRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExtensionSingleRelWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.detail) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExtensionSingleRelWire.DETAIL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const ExtensionSingleRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ExtensionSingleRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExtensionSingleRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExtensionSingleRelWire.INPUT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.detail) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExtensionSingleRelWire.DETAIL_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ExtensionSingleRelReader = struct {
    _common_buf: ?[]const u8 = null,
    _input_buf: ?[]const u8 = null,
    _detail_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExtensionSingleRelReader {
        var buf = gremlin.Reader.init(src);
        var res = ExtensionSingleRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ExtensionSingleRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                ExtensionSingleRelWire.INPUT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._input_buf = result.value;
                },
                ExtensionSingleRelWire.DETAIL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._detail_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const ExtensionSingleRelReader) void { }
    
    pub fn getCommon(self: *const ExtensionSingleRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getInput(self: *const ExtensionSingleRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._input_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getDetail(self: *const ExtensionSingleRelReader, allocator: std.mem.Allocator) gremlin.Error!any.AnyReader {
        if (self._detail_buf) |buf| {
            return try any.AnyReader.init(allocator, buf);
        }
        return try any.AnyReader.init(allocator, &[_]u8{});
    }
};

const ExtensionLeafRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const DETAIL_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const ExtensionLeafRel = struct {
    // fields
    common: ?RelCommon = null,
    detail: ?any.Any = null,

    pub fn calcProtobufSize(self: *const ExtensionLeafRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExtensionLeafRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.detail) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExtensionLeafRelWire.DETAIL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const ExtensionLeafRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ExtensionLeafRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExtensionLeafRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.detail) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExtensionLeafRelWire.DETAIL_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ExtensionLeafRelReader = struct {
    _common_buf: ?[]const u8 = null,
    _detail_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExtensionLeafRelReader {
        var buf = gremlin.Reader.init(src);
        var res = ExtensionLeafRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ExtensionLeafRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                ExtensionLeafRelWire.DETAIL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._detail_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const ExtensionLeafRelReader) void { }
    
    pub fn getCommon(self: *const ExtensionLeafRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getDetail(self: *const ExtensionLeafRelReader, allocator: std.mem.Allocator) gremlin.Error!any.AnyReader {
        if (self._detail_buf) |buf| {
            return try any.AnyReader.init(allocator, buf);
        }
        return try any.AnyReader.init(allocator, &[_]u8{});
    }
};

const ExtensionMultiRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const INPUTS_WIRE: gremlin.ProtoWireNumber = 2;
    const DETAIL_WIRE: gremlin.ProtoWireNumber = 3;
};

pub const ExtensionMultiRel = struct {
    // fields
    common: ?RelCommon = null,
    inputs: ?[]const ?Rel = null,
    detail: ?any.Any = null,

    pub fn calcProtobufSize(self: *const ExtensionMultiRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExtensionMultiRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.inputs) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(ExtensionMultiRelWire.INPUTS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.detail) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExtensionMultiRelWire.DETAIL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const ExtensionMultiRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ExtensionMultiRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExtensionMultiRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.inputs) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ExtensionMultiRelWire.INPUTS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(ExtensionMultiRelWire.INPUTS_WIRE, 0);
                }
            }
        }
        if (self.detail) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExtensionMultiRelWire.DETAIL_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ExtensionMultiRelReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _common_buf: ?[]const u8 = null,
    _inputs_bufs: ?std.ArrayList([]const u8) = null,
    _detail_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ExtensionMultiRelReader {
        var buf = gremlin.Reader.init(src);
        var res = ExtensionMultiRelReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ExtensionMultiRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                ExtensionMultiRelWire.INPUTS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._inputs_bufs == null) {
                        res._inputs_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._inputs_bufs.?.append(result.value);
                },
                ExtensionMultiRelWire.DETAIL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._detail_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const ExtensionMultiRelReader) void {
        if (self._inputs_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getCommon(self: *const ExtensionMultiRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getInputs(self: *const ExtensionMultiRelReader, allocator: std.mem.Allocator) gremlin.Error![]RelReader {
        if (self._inputs_bufs) |bufs| {
            var result = try std.ArrayList(RelReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try RelReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]RelReader{};
    }
    pub fn getDetail(self: *const ExtensionMultiRelReader, allocator: std.mem.Allocator) gremlin.Error!any.AnyReader {
        if (self._detail_buf) |buf| {
            return try any.AnyReader.init(allocator, buf);
        }
        return try any.AnyReader.init(allocator, &[_]u8{});
    }
};

const ExchangeRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const INPUT_WIRE: gremlin.ProtoWireNumber = 2;
    const PARTITION_COUNT_WIRE: gremlin.ProtoWireNumber = 3;
    const TARGETS_WIRE: gremlin.ProtoWireNumber = 4;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
    const SCATTER_BY_FIELDS_WIRE: gremlin.ProtoWireNumber = 5;
    const SINGLE_TARGET_WIRE: gremlin.ProtoWireNumber = 6;
    const MULTI_TARGET_WIRE: gremlin.ProtoWireNumber = 7;
    const ROUND_ROBIN_WIRE: gremlin.ProtoWireNumber = 8;
    const BROADCAST_WIRE: gremlin.ProtoWireNumber = 9;
};

pub const ExchangeRel = struct {
    // nested structs
    const ScatterFieldsWire = struct {
        const FIELDS_WIRE: gremlin.ProtoWireNumber = 1;
    };
    
    pub const ScatterFields = struct {
        // fields
        fields: ?[]const ?Expression.FieldReference = null,

        pub fn calcProtobufSize(self: *const ScatterFields) usize {
            var res: usize = 0;
            if (self.fields) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(ExchangeRel.ScatterFieldsWire.FIELDS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            return res;
        }

        pub fn encode(self: *const ScatterFields, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ScatterFields, target: *gremlin.Writer) void {
            if (self.fields) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(ExchangeRel.ScatterFieldsWire.FIELDS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(ExchangeRel.ScatterFieldsWire.FIELDS_WIRE, 0);
                    }
                }
            }
        }
    };
    
    pub const ScatterFieldsReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _fields_bufs: ?std.ArrayList([]const u8) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ScatterFieldsReader {
            var buf = gremlin.Reader.init(src);
            var res = ScatterFieldsReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ExchangeRel.ScatterFieldsWire.FIELDS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._fields_bufs == null) {
                            res._fields_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._fields_bufs.?.append(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const ScatterFieldsReader) void {
            if (self._fields_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getFields(self: *const ScatterFieldsReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.FieldReferenceReader {
            if (self._fields_bufs) |bufs| {
                var result = try std.ArrayList(Expression.FieldReferenceReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try Expression.FieldReferenceReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]Expression.FieldReferenceReader{};
        }
    };
    
    const SingleBucketExpressionWire = struct {
        const EXPRESSION_WIRE: gremlin.ProtoWireNumber = 1;
    };
    
    pub const SingleBucketExpression = struct {
        // fields
        expression: ?Expression = null,

        pub fn calcProtobufSize(self: *const SingleBucketExpression) usize {
            var res: usize = 0;
            if (self.expression) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ExchangeRel.SingleBucketExpressionWire.EXPRESSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const SingleBucketExpression, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const SingleBucketExpression, target: *gremlin.Writer) void {
            if (self.expression) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ExchangeRel.SingleBucketExpressionWire.EXPRESSION_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const SingleBucketExpressionReader = struct {
        _expression_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!SingleBucketExpressionReader {
            var buf = gremlin.Reader.init(src);
            var res = SingleBucketExpressionReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ExchangeRel.SingleBucketExpressionWire.EXPRESSION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._expression_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const SingleBucketExpressionReader) void { }
        
        pub fn getExpression(self: *const SingleBucketExpressionReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
            if (self._expression_buf) |buf| {
                return try ExpressionReader.init(allocator, buf);
            }
            return try ExpressionReader.init(allocator, &[_]u8{});
        }
    };
    
    const MultiBucketExpressionWire = struct {
        const EXPRESSION_WIRE: gremlin.ProtoWireNumber = 1;
        const CONSTRAINED_TO_COUNT_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const MultiBucketExpression = struct {
        // fields
        expression: ?Expression = null,
        constrained_to_count: bool = false,

        pub fn calcProtobufSize(self: *const MultiBucketExpression) usize {
            var res: usize = 0;
            if (self.expression) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ExchangeRel.MultiBucketExpressionWire.EXPRESSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.constrained_to_count != false) { res += gremlin.sizes.sizeWireNumber(ExchangeRel.MultiBucketExpressionWire.CONSTRAINED_TO_COUNT_WIRE) + gremlin.sizes.sizeBool(self.constrained_to_count); }
            return res;
        }

        pub fn encode(self: *const MultiBucketExpression, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const MultiBucketExpression, target: *gremlin.Writer) void {
            if (self.expression) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ExchangeRel.MultiBucketExpressionWire.EXPRESSION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.constrained_to_count != false) { target.appendBool(ExchangeRel.MultiBucketExpressionWire.CONSTRAINED_TO_COUNT_WIRE, self.constrained_to_count); }
        }
    };
    
    pub const MultiBucketExpressionReader = struct {
        _expression_buf: ?[]const u8 = null,
        _constrained_to_count: bool = false,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!MultiBucketExpressionReader {
            var buf = gremlin.Reader.init(src);
            var res = MultiBucketExpressionReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ExchangeRel.MultiBucketExpressionWire.EXPRESSION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._expression_buf = result.value;
                    },
                    ExchangeRel.MultiBucketExpressionWire.CONSTRAINED_TO_COUNT_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._constrained_to_count = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const MultiBucketExpressionReader) void { }
        
        pub fn getExpression(self: *const MultiBucketExpressionReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
            if (self._expression_buf) |buf| {
                return try ExpressionReader.init(allocator, buf);
            }
            return try ExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getConstrainedToCount(self: *const MultiBucketExpressionReader) bool { return self._constrained_to_count; }
    };
    
    pub const Broadcast = struct {

        pub fn calcProtobufSize(_: *const Broadcast) usize { return 0; }
        

        pub fn encode(self: *const Broadcast, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(_: *const Broadcast, _: *gremlin.Writer) void {}
        
    };
    
    pub const BroadcastReader = struct {

        pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!BroadcastReader {
            return BroadcastReader{};
        }
        pub fn deinit(_: *const BroadcastReader) void { }
        
    };
    
    const RoundRobinWire = struct {
        const EXACT_WIRE: gremlin.ProtoWireNumber = 1;
    };
    
    pub const RoundRobin = struct {
        // fields
        exact: bool = false,

        pub fn calcProtobufSize(self: *const RoundRobin) usize {
            var res: usize = 0;
            if (self.exact != false) { res += gremlin.sizes.sizeWireNumber(ExchangeRel.RoundRobinWire.EXACT_WIRE) + gremlin.sizes.sizeBool(self.exact); }
            return res;
        }

        pub fn encode(self: *const RoundRobin, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const RoundRobin, target: *gremlin.Writer) void {
            if (self.exact != false) { target.appendBool(ExchangeRel.RoundRobinWire.EXACT_WIRE, self.exact); }
        }
    };
    
    pub const RoundRobinReader = struct {
        _exact: bool = false,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!RoundRobinReader {
            var buf = gremlin.Reader.init(src);
            var res = RoundRobinReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ExchangeRel.RoundRobinWire.EXACT_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._exact = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const RoundRobinReader) void { }
        
        pub inline fn getExact(self: *const RoundRobinReader) bool { return self._exact; }
    };
    
    const ExchangeTargetWire = struct {
        const PARTITION_ID_WIRE: gremlin.ProtoWireNumber = 1;
        const URI_WIRE: gremlin.ProtoWireNumber = 2;
        const EXTENDED_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExchangeTarget = struct {
        // fields
        partition_id: ?[]const i32 = null,
        uri: ?[]const u8 = null,
        extended: ?any.Any = null,

        pub fn calcProtobufSize(self: *const ExchangeTarget) usize {
            var res: usize = 0;
            if (self.partition_id) |arr| {
                if (arr.len == 0) {
                } else if (arr.len == 1) {
                    res += gremlin.sizes.sizeWireNumber(ExchangeRel.ExchangeTargetWire.PARTITION_ID_WIRE) + gremlin.sizes.sizeI32(arr[0]);
                } else {
                    var packed_size: usize = 0;
                    for (arr) |v| {
                        packed_size += gremlin.sizes.sizeI32(v);
                    }
                    res += gremlin.sizes.sizeWireNumber(ExchangeRel.ExchangeTargetWire.PARTITION_ID_WIRE) + gremlin.sizes.sizeUsize(packed_size) + packed_size;
                }
            }
            if (self.uri) |v| { res += gremlin.sizes.sizeWireNumber(ExchangeRel.ExchangeTargetWire.URI_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.extended) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ExchangeRel.ExchangeTargetWire.EXTENDED_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const ExchangeTarget, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExchangeTarget, target: *gremlin.Writer) void {
            if (self.partition_id) |arr| {
                if (arr.len == 0) {
                } else if (arr.len == 1) {
                    target.appendInt32(ExchangeRel.ExchangeTargetWire.PARTITION_ID_WIRE, arr[0]);
                } else {
                    var packed_size: usize = 0;
                    for (arr) |v| {
                        packed_size += gremlin.sizes.sizeI32(v);
                    }
                    target.appendBytesTag(ExchangeRel.ExchangeTargetWire.PARTITION_ID_WIRE, packed_size);
                    for (arr) |v| {
                        target.appendInt32WithoutTag(v);
                    }
                }
            }
            if (self.uri) |v| { target.appendBytes(ExchangeRel.ExchangeTargetWire.URI_WIRE, v); }
            if (self.extended) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ExchangeRel.ExchangeTargetWire.EXTENDED_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const ExchangeTargetReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _partition_id_offsets: ?std.ArrayList(usize) = null,
        _partition_id_wires: ?std.ArrayList(gremlin.ProtoWireType) = null,
        _uri: ?[]const u8 = null,
        _extended_buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ExchangeTargetReader {
            var buf = gremlin.Reader.init(src);
            var res = ExchangeTargetReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ExchangeRel.ExchangeTargetWire.PARTITION_ID_WIRE => {
                        if (res._partition_id_offsets == null) {
                            res._partition_id_offsets = std.ArrayList(usize).init(allocator);
                            res._partition_id_wires = std.ArrayList(gremlin.ProtoWireType).init(allocator);
                        }
                        try res._partition_id_offsets.?.append(offset);
                        try res._partition_id_wires.?.append(tag.wire);
                        if (tag.wire == gremlin.ProtoWireType.bytes) {
                            const length_result = try buf.readVarInt(offset);
                            offset += length_result.size + length_result.value;
                        } else {
                            const result = try buf.readInt32(offset);
                            offset += result.size;
                        }
                    },
                    ExchangeRel.ExchangeTargetWire.URI_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._uri = result.value;
                    },
                    ExchangeRel.ExchangeTargetWire.EXTENDED_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._extended_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const ExchangeTargetReader) void {
            if (self._partition_id_offsets) |arr| {
                arr.deinit();
            }
            if (self._partition_id_wires) |arr| {
                arr.deinit();
            }
        }
        pub fn getPartitionId(self: *const ExchangeTargetReader, allocator: std.mem.Allocator) gremlin.Error![]i32 {
            if (self._partition_id_offsets) |offsets| {
                if (offsets.items.len == 0) return &[_]i32{};
        
                var result = std.ArrayList(i32).init(allocator);
                errdefer result.deinit();
        
                for (offsets.items, self._partition_id_wires.?.items) |start_offset, wire_type| {
                    if (wire_type == .bytes) {
                        const length_result = try self.buf.readVarInt(start_offset);
                        var offset = start_offset + length_result.size;
                        const end_offset = offset + length_result.value;
        
                        while (offset < end_offset) {
                            const value_result = try self.buf.readInt32(offset);
                            try result.append(value_result.value);
                            offset += value_result.size;
                        }
                    } else {
                        const value_result = try self.buf.readInt32(start_offset);
                        try result.append(value_result.value);
                    }
                }
                return result.toOwnedSlice();
            }
            return &[_]i32{};
        }
        pub inline fn getUri(self: *const ExchangeTargetReader) []const u8 { return self._uri orelse &[_]u8{}; }
        pub fn getExtended(self: *const ExchangeTargetReader, allocator: std.mem.Allocator) gremlin.Error!any.AnyReader {
            if (self._extended_buf) |buf| {
                return try any.AnyReader.init(allocator, buf);
            }
            return try any.AnyReader.init(allocator, &[_]u8{});
        }
    };
    
    // fields
    common: ?RelCommon = null,
    input: ?Rel = null,
    partition_count: i32 = 0,
    targets: ?[]const ?ExchangeRel.ExchangeTarget = null,
    advanced_extension: ?extensions.AdvancedExtension = null,
    scatter_by_fields: ?ExchangeRel.ScatterFields = null,
    single_target: ?ExchangeRel.SingleBucketExpression = null,
    multi_target: ?ExchangeRel.MultiBucketExpression = null,
    round_robin: ?ExchangeRel.RoundRobin = null,
    broadcast: ?ExchangeRel.Broadcast = null,

    pub fn calcProtobufSize(self: *const ExchangeRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExchangeRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExchangeRelWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.partition_count != 0) { res += gremlin.sizes.sizeWireNumber(ExchangeRelWire.PARTITION_COUNT_WIRE) + gremlin.sizes.sizeI32(self.partition_count); }
        if (self.targets) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(ExchangeRelWire.TARGETS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExchangeRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.scatter_by_fields) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExchangeRelWire.SCATTER_BY_FIELDS_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.single_target) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExchangeRelWire.SINGLE_TARGET_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.multi_target) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExchangeRelWire.MULTI_TARGET_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.round_robin) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExchangeRelWire.ROUND_ROBIN_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.broadcast) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExchangeRelWire.BROADCAST_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const ExchangeRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ExchangeRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExchangeRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExchangeRelWire.INPUT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.partition_count != 0) { target.appendInt32(ExchangeRelWire.PARTITION_COUNT_WIRE, self.partition_count); }
        if (self.targets) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ExchangeRelWire.TARGETS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(ExchangeRelWire.TARGETS_WIRE, 0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExchangeRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.scatter_by_fields) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExchangeRelWire.SCATTER_BY_FIELDS_WIRE, size);
            v.encodeTo(target);
        }
        if (self.single_target) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExchangeRelWire.SINGLE_TARGET_WIRE, size);
            v.encodeTo(target);
        }
        if (self.multi_target) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExchangeRelWire.MULTI_TARGET_WIRE, size);
            v.encodeTo(target);
        }
        if (self.round_robin) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExchangeRelWire.ROUND_ROBIN_WIRE, size);
            v.encodeTo(target);
        }
        if (self.broadcast) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExchangeRelWire.BROADCAST_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ExchangeRelReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _common_buf: ?[]const u8 = null,
    _input_buf: ?[]const u8 = null,
    _partition_count: i32 = 0,
    _targets_bufs: ?std.ArrayList([]const u8) = null,
    _advanced_extension_buf: ?[]const u8 = null,
    _scatter_by_fields_buf: ?[]const u8 = null,
    _single_target_buf: ?[]const u8 = null,
    _multi_target_buf: ?[]const u8 = null,
    _round_robin_buf: ?[]const u8 = null,
    _broadcast_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ExchangeRelReader {
        var buf = gremlin.Reader.init(src);
        var res = ExchangeRelReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ExchangeRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                ExchangeRelWire.INPUT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._input_buf = result.value;
                },
                ExchangeRelWire.PARTITION_COUNT_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._partition_count = result.value;
                },
                ExchangeRelWire.TARGETS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._targets_bufs == null) {
                        res._targets_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._targets_bufs.?.append(result.value);
                },
                ExchangeRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                ExchangeRelWire.SCATTER_BY_FIELDS_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._scatter_by_fields_buf = result.value;
                },
                ExchangeRelWire.SINGLE_TARGET_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._single_target_buf = result.value;
                },
                ExchangeRelWire.MULTI_TARGET_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._multi_target_buf = result.value;
                },
                ExchangeRelWire.ROUND_ROBIN_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._round_robin_buf = result.value;
                },
                ExchangeRelWire.BROADCAST_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._broadcast_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const ExchangeRelReader) void {
        if (self._targets_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getCommon(self: *const ExchangeRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getInput(self: *const ExchangeRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._input_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub inline fn getPartitionCount(self: *const ExchangeRelReader) i32 { return self._partition_count; }
    pub fn getTargets(self: *const ExchangeRelReader, allocator: std.mem.Allocator) gremlin.Error![]ExchangeRel.ExchangeTargetReader {
        if (self._targets_bufs) |bufs| {
            var result = try std.ArrayList(ExchangeRel.ExchangeTargetReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try ExchangeRel.ExchangeTargetReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]ExchangeRel.ExchangeTargetReader{};
    }
    pub fn getAdvancedExtension(self: *const ExchangeRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
    pub fn getScatterByFields(self: *const ExchangeRelReader, allocator: std.mem.Allocator) gremlin.Error!ExchangeRel.ScatterFieldsReader {
        if (self._scatter_by_fields_buf) |buf| {
            return try ExchangeRel.ScatterFieldsReader.init(allocator, buf);
        }
        return try ExchangeRel.ScatterFieldsReader.init(allocator, &[_]u8{});
    }
    pub fn getSingleTarget(self: *const ExchangeRelReader, allocator: std.mem.Allocator) gremlin.Error!ExchangeRel.SingleBucketExpressionReader {
        if (self._single_target_buf) |buf| {
            return try ExchangeRel.SingleBucketExpressionReader.init(allocator, buf);
        }
        return try ExchangeRel.SingleBucketExpressionReader.init(allocator, &[_]u8{});
    }
    pub fn getMultiTarget(self: *const ExchangeRelReader, allocator: std.mem.Allocator) gremlin.Error!ExchangeRel.MultiBucketExpressionReader {
        if (self._multi_target_buf) |buf| {
            return try ExchangeRel.MultiBucketExpressionReader.init(allocator, buf);
        }
        return try ExchangeRel.MultiBucketExpressionReader.init(allocator, &[_]u8{});
    }
    pub fn getRoundRobin(self: *const ExchangeRelReader, allocator: std.mem.Allocator) gremlin.Error!ExchangeRel.RoundRobinReader {
        if (self._round_robin_buf) |buf| {
            return try ExchangeRel.RoundRobinReader.init(allocator, buf);
        }
        return try ExchangeRel.RoundRobinReader.init(allocator, &[_]u8{});
    }
    pub fn getBroadcast(self: *const ExchangeRelReader, allocator: std.mem.Allocator) gremlin.Error!ExchangeRel.BroadcastReader {
        if (self._broadcast_buf) |buf| {
            return try ExchangeRel.BroadcastReader.init(allocator, buf);
        }
        return try ExchangeRel.BroadcastReader.init(allocator, &[_]u8{});
    }
};

const ExpandRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const INPUT_WIRE: gremlin.ProtoWireNumber = 2;
    const FIELDS_WIRE: gremlin.ProtoWireNumber = 4;
};

pub const ExpandRel = struct {
    // nested structs
    const ExpandFieldWire = struct {
        const SWITCHING_FIELD_WIRE: gremlin.ProtoWireNumber = 2;
        const CONSISTENT_FIELD_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ExpandField = struct {
        // fields
        switching_field: ?ExpandRel.SwitchingField = null,
        consistent_field: ?Expression = null,

        pub fn calcProtobufSize(self: *const ExpandField) usize {
            var res: usize = 0;
            if (self.switching_field) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ExpandRel.ExpandFieldWire.SWITCHING_FIELD_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.consistent_field) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(ExpandRel.ExpandFieldWire.CONSISTENT_FIELD_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const ExpandField, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ExpandField, target: *gremlin.Writer) void {
            if (self.switching_field) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ExpandRel.ExpandFieldWire.SWITCHING_FIELD_WIRE, size);
                v.encodeTo(target);
            }
            if (self.consistent_field) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(ExpandRel.ExpandFieldWire.CONSISTENT_FIELD_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const ExpandFieldReader = struct {
        _switching_field_buf: ?[]const u8 = null,
        _consistent_field_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpandFieldReader {
            var buf = gremlin.Reader.init(src);
            var res = ExpandFieldReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ExpandRel.ExpandFieldWire.SWITCHING_FIELD_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._switching_field_buf = result.value;
                    },
                    ExpandRel.ExpandFieldWire.CONSISTENT_FIELD_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._consistent_field_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ExpandFieldReader) void { }
        
        pub fn getSwitchingField(self: *const ExpandFieldReader, allocator: std.mem.Allocator) gremlin.Error!ExpandRel.SwitchingFieldReader {
            if (self._switching_field_buf) |buf| {
                return try ExpandRel.SwitchingFieldReader.init(allocator, buf);
            }
            return try ExpandRel.SwitchingFieldReader.init(allocator, &[_]u8{});
        }
        pub fn getConsistentField(self: *const ExpandFieldReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
            if (self._consistent_field_buf) |buf| {
                return try ExpressionReader.init(allocator, buf);
            }
            return try ExpressionReader.init(allocator, &[_]u8{});
        }
    };
    
    const SwitchingFieldWire = struct {
        const DUPLICATES_WIRE: gremlin.ProtoWireNumber = 1;
    };
    
    pub const SwitchingField = struct {
        // fields
        duplicates: ?[]const ?Expression = null,

        pub fn calcProtobufSize(self: *const SwitchingField) usize {
            var res: usize = 0;
            if (self.duplicates) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(ExpandRel.SwitchingFieldWire.DUPLICATES_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            return res;
        }

        pub fn encode(self: *const SwitchingField, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const SwitchingField, target: *gremlin.Writer) void {
            if (self.duplicates) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(ExpandRel.SwitchingFieldWire.DUPLICATES_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(ExpandRel.SwitchingFieldWire.DUPLICATES_WIRE, 0);
                    }
                }
            }
        }
    };
    
    pub const SwitchingFieldReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _duplicates_bufs: ?std.ArrayList([]const u8) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!SwitchingFieldReader {
            var buf = gremlin.Reader.init(src);
            var res = SwitchingFieldReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ExpandRel.SwitchingFieldWire.DUPLICATES_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._duplicates_bufs == null) {
                            res._duplicates_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._duplicates_bufs.?.append(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const SwitchingFieldReader) void {
            if (self._duplicates_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getDuplicates(self: *const SwitchingFieldReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
            if (self._duplicates_bufs) |bufs| {
                var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try ExpressionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]ExpressionReader{};
        }
    };
    
    // fields
    common: ?RelCommon = null,
    input: ?Rel = null,
    fields: ?[]const ?ExpandRel.ExpandField = null,

    pub fn calcProtobufSize(self: *const ExpandRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpandRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpandRelWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fields) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(ExpandRelWire.FIELDS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        return res;
    }

    pub fn encode(self: *const ExpandRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ExpandRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpandRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpandRelWire.INPUT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fields) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(ExpandRelWire.FIELDS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(ExpandRelWire.FIELDS_WIRE, 0);
                }
            }
        }
    }
};

pub const ExpandRelReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _common_buf: ?[]const u8 = null,
    _input_buf: ?[]const u8 = null,
    _fields_bufs: ?std.ArrayList([]const u8) = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ExpandRelReader {
        var buf = gremlin.Reader.init(src);
        var res = ExpandRelReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ExpandRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                ExpandRelWire.INPUT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._input_buf = result.value;
                },
                ExpandRelWire.FIELDS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._fields_bufs == null) {
                        res._fields_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._fields_bufs.?.append(result.value);
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const ExpandRelReader) void {
        if (self._fields_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getCommon(self: *const ExpandRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getInput(self: *const ExpandRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._input_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getFields(self: *const ExpandRelReader, allocator: std.mem.Allocator) gremlin.Error![]ExpandRel.ExpandFieldReader {
        if (self._fields_bufs) |bufs| {
            var result = try std.ArrayList(ExpandRel.ExpandFieldReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try ExpandRel.ExpandFieldReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]ExpandRel.ExpandFieldReader{};
    }
};

const RelRootWire = struct {
    const INPUT_WIRE: gremlin.ProtoWireNumber = 1;
    const NAMES_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const RelRoot = struct {
    // fields
    input: ?Rel = null,
    names: ?[]const ?[]const u8 = null,

    pub fn calcProtobufSize(self: *const RelRoot) usize {
        var res: usize = 0;
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelRootWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.names) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(RelRootWire.NAMES_WIRE);
                if (maybe_v) |v| {
                    res += gremlin.sizes.sizeUsize(v.len) + v.len;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        return res;
    }

    pub fn encode(self: *const RelRoot, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const RelRoot, target: *gremlin.Writer) void {
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelRootWire.INPUT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.names) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    target.appendBytes(RelRootWire.NAMES_WIRE, v);
                } else {
                    target.appendBytesTag(RelRootWire.NAMES_WIRE, 0);
                }
            }
        }
    }
};

pub const RelRootReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _input_buf: ?[]const u8 = null,
    _names: ?std.ArrayList([]const u8) = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!RelRootReader {
        var buf = gremlin.Reader.init(src);
        var res = RelRootReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                RelRootWire.INPUT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._input_buf = result.value;
                },
                RelRootWire.NAMES_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._names == null) {
                        res._names = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._names.?.append(result.value);
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const RelRootReader) void {
        if (self._names) |arr| {
            arr.deinit();
        }
    }
    pub fn getInput(self: *const RelRootReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._input_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getNames(self: *const RelRootReader) []const []const u8 {
        if (self._names) |arr| {
            return arr.items;
        }
        return &[_][]u8{};
    }
};

const RelWire = struct {
    const READ_WIRE: gremlin.ProtoWireNumber = 1;
    const FILTER_WIRE: gremlin.ProtoWireNumber = 2;
    const FETCH_WIRE: gremlin.ProtoWireNumber = 3;
    const AGGREGATE_WIRE: gremlin.ProtoWireNumber = 4;
    const SORT_WIRE: gremlin.ProtoWireNumber = 5;
    const JOIN_WIRE: gremlin.ProtoWireNumber = 6;
    const PROJECT_WIRE: gremlin.ProtoWireNumber = 7;
    const SET_WIRE: gremlin.ProtoWireNumber = 8;
    const EXTENSION_SINGLE_WIRE: gremlin.ProtoWireNumber = 9;
    const EXTENSION_MULTI_WIRE: gremlin.ProtoWireNumber = 10;
    const EXTENSION_LEAF_WIRE: gremlin.ProtoWireNumber = 11;
    const CROSS_WIRE: gremlin.ProtoWireNumber = 12;
    const REFERENCE_WIRE: gremlin.ProtoWireNumber = 21;
    const WRITE_WIRE: gremlin.ProtoWireNumber = 19;
    const DDL_WIRE: gremlin.ProtoWireNumber = 20;
    const UPDATE_WIRE: gremlin.ProtoWireNumber = 22;
    const HASH_JOIN_WIRE: gremlin.ProtoWireNumber = 13;
    const MERGE_JOIN_WIRE: gremlin.ProtoWireNumber = 14;
    const NESTED_LOOP_JOIN_WIRE: gremlin.ProtoWireNumber = 18;
    const WINDOW_WIRE: gremlin.ProtoWireNumber = 17;
    const EXCHANGE_WIRE: gremlin.ProtoWireNumber = 15;
    const EXPAND_WIRE: gremlin.ProtoWireNumber = 16;
};

pub const Rel = struct {
    // fields
    read: ?ReadRel = null,
    filter: ?FilterRel = null,
    fetch: ?FetchRel = null,
    aggregate: ?AggregateRel = null,
    sort: ?SortRel = null,
    join: ?JoinRel = null,
    project: ?ProjectRel = null,
    set: ?SetRel = null,
    extension_single: ?ExtensionSingleRel = null,
    extension_multi: ?ExtensionMultiRel = null,
    extension_leaf: ?ExtensionLeafRel = null,
    cross: ?CrossRel = null,
    reference: ?ReferenceRel = null,
    write: ?WriteRel = null,
    ddl: ?DdlRel = null,
    update: ?UpdateRel = null,
    hash_join: ?HashJoinRel = null,
    merge_join: ?MergeJoinRel = null,
    nested_loop_join: ?NestedLoopJoinRel = null,
    window: ?ConsistentPartitionWindowRel = null,
    exchange: ?ExchangeRel = null,
    expand: ?ExpandRel = null,

    pub fn calcProtobufSize(self: *const Rel) usize {
        var res: usize = 0;
        if (self.read) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.READ_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.filter) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.FILTER_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.fetch) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.FETCH_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.aggregate) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.AGGREGATE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.sort) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.SORT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.join) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.JOIN_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.project) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.PROJECT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.set) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.SET_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.extension_single) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.EXTENSION_SINGLE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.extension_multi) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.EXTENSION_MULTI_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.extension_leaf) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.EXTENSION_LEAF_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.cross) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.CROSS_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.reference) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.REFERENCE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.write) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.WRITE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.ddl) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.DDL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.update) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.UPDATE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.hash_join) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.HASH_JOIN_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.merge_join) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.MERGE_JOIN_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.nested_loop_join) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.NESTED_LOOP_JOIN_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.window) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.WINDOW_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.exchange) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.EXCHANGE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.expand) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(RelWire.EXPAND_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const Rel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const Rel, target: *gremlin.Writer) void {
        if (self.read) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.READ_WIRE, size);
            v.encodeTo(target);
        }
        if (self.filter) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.FILTER_WIRE, size);
            v.encodeTo(target);
        }
        if (self.fetch) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.FETCH_WIRE, size);
            v.encodeTo(target);
        }
        if (self.aggregate) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.AGGREGATE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.sort) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.SORT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.join) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.JOIN_WIRE, size);
            v.encodeTo(target);
        }
        if (self.project) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.PROJECT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.set) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.SET_WIRE, size);
            v.encodeTo(target);
        }
        if (self.extension_single) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.EXTENSION_SINGLE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.extension_multi) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.EXTENSION_MULTI_WIRE, size);
            v.encodeTo(target);
        }
        if (self.extension_leaf) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.EXTENSION_LEAF_WIRE, size);
            v.encodeTo(target);
        }
        if (self.cross) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.CROSS_WIRE, size);
            v.encodeTo(target);
        }
        if (self.reference) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.REFERENCE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.write) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.WRITE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.ddl) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.DDL_WIRE, size);
            v.encodeTo(target);
        }
        if (self.update) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.UPDATE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.hash_join) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.HASH_JOIN_WIRE, size);
            v.encodeTo(target);
        }
        if (self.merge_join) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.MERGE_JOIN_WIRE, size);
            v.encodeTo(target);
        }
        if (self.nested_loop_join) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.NESTED_LOOP_JOIN_WIRE, size);
            v.encodeTo(target);
        }
        if (self.window) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.WINDOW_WIRE, size);
            v.encodeTo(target);
        }
        if (self.exchange) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.EXCHANGE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.expand) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(RelWire.EXPAND_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const RelReader = struct {
    _read_buf: ?[]const u8 = null,
    _filter_buf: ?[]const u8 = null,
    _fetch_buf: ?[]const u8 = null,
    _aggregate_buf: ?[]const u8 = null,
    _sort_buf: ?[]const u8 = null,
    _join_buf: ?[]const u8 = null,
    _project_buf: ?[]const u8 = null,
    _set_buf: ?[]const u8 = null,
    _extension_single_buf: ?[]const u8 = null,
    _extension_multi_buf: ?[]const u8 = null,
    _extension_leaf_buf: ?[]const u8 = null,
    _cross_buf: ?[]const u8 = null,
    _reference_buf: ?[]const u8 = null,
    _write_buf: ?[]const u8 = null,
    _ddl_buf: ?[]const u8 = null,
    _update_buf: ?[]const u8 = null,
    _hash_join_buf: ?[]const u8 = null,
    _merge_join_buf: ?[]const u8 = null,
    _nested_loop_join_buf: ?[]const u8 = null,
    _window_buf: ?[]const u8 = null,
    _exchange_buf: ?[]const u8 = null,
    _expand_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!RelReader {
        var buf = gremlin.Reader.init(src);
        var res = RelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                RelWire.READ_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._read_buf = result.value;
                },
                RelWire.FILTER_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._filter_buf = result.value;
                },
                RelWire.FETCH_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._fetch_buf = result.value;
                },
                RelWire.AGGREGATE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._aggregate_buf = result.value;
                },
                RelWire.SORT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._sort_buf = result.value;
                },
                RelWire.JOIN_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._join_buf = result.value;
                },
                RelWire.PROJECT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._project_buf = result.value;
                },
                RelWire.SET_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._set_buf = result.value;
                },
                RelWire.EXTENSION_SINGLE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._extension_single_buf = result.value;
                },
                RelWire.EXTENSION_MULTI_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._extension_multi_buf = result.value;
                },
                RelWire.EXTENSION_LEAF_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._extension_leaf_buf = result.value;
                },
                RelWire.CROSS_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._cross_buf = result.value;
                },
                RelWire.REFERENCE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._reference_buf = result.value;
                },
                RelWire.WRITE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._write_buf = result.value;
                },
                RelWire.DDL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._ddl_buf = result.value;
                },
                RelWire.UPDATE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._update_buf = result.value;
                },
                RelWire.HASH_JOIN_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._hash_join_buf = result.value;
                },
                RelWire.MERGE_JOIN_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._merge_join_buf = result.value;
                },
                RelWire.NESTED_LOOP_JOIN_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._nested_loop_join_buf = result.value;
                },
                RelWire.WINDOW_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._window_buf = result.value;
                },
                RelWire.EXCHANGE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._exchange_buf = result.value;
                },
                RelWire.EXPAND_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._expand_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const RelReader) void { }
    
    pub fn getRead(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!ReadRelReader {
        if (self._read_buf) |buf| {
            return try ReadRelReader.init(allocator, buf);
        }
        return try ReadRelReader.init(allocator, &[_]u8{});
    }
    pub fn getFilter(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!FilterRelReader {
        if (self._filter_buf) |buf| {
            return try FilterRelReader.init(allocator, buf);
        }
        return try FilterRelReader.init(allocator, &[_]u8{});
    }
    pub fn getFetch(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!FetchRelReader {
        if (self._fetch_buf) |buf| {
            return try FetchRelReader.init(allocator, buf);
        }
        return try FetchRelReader.init(allocator, &[_]u8{});
    }
    pub fn getAggregate(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!AggregateRelReader {
        if (self._aggregate_buf) |buf| {
            return try AggregateRelReader.init(allocator, buf);
        }
        return try AggregateRelReader.init(allocator, &[_]u8{});
    }
    pub fn getSort(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!SortRelReader {
        if (self._sort_buf) |buf| {
            return try SortRelReader.init(allocator, buf);
        }
        return try SortRelReader.init(allocator, &[_]u8{});
    }
    pub fn getJoin(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!JoinRelReader {
        if (self._join_buf) |buf| {
            return try JoinRelReader.init(allocator, buf);
        }
        return try JoinRelReader.init(allocator, &[_]u8{});
    }
    pub fn getProject(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!ProjectRelReader {
        if (self._project_buf) |buf| {
            return try ProjectRelReader.init(allocator, buf);
        }
        return try ProjectRelReader.init(allocator, &[_]u8{});
    }
    pub fn getSet(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!SetRelReader {
        if (self._set_buf) |buf| {
            return try SetRelReader.init(allocator, buf);
        }
        return try SetRelReader.init(allocator, &[_]u8{});
    }
    pub fn getExtensionSingle(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!ExtensionSingleRelReader {
        if (self._extension_single_buf) |buf| {
            return try ExtensionSingleRelReader.init(allocator, buf);
        }
        return try ExtensionSingleRelReader.init(allocator, &[_]u8{});
    }
    pub fn getExtensionMulti(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!ExtensionMultiRelReader {
        if (self._extension_multi_buf) |buf| {
            return try ExtensionMultiRelReader.init(allocator, buf);
        }
        return try ExtensionMultiRelReader.init(allocator, &[_]u8{});
    }
    pub fn getExtensionLeaf(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!ExtensionLeafRelReader {
        if (self._extension_leaf_buf) |buf| {
            return try ExtensionLeafRelReader.init(allocator, buf);
        }
        return try ExtensionLeafRelReader.init(allocator, &[_]u8{});
    }
    pub fn getCross(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!CrossRelReader {
        if (self._cross_buf) |buf| {
            return try CrossRelReader.init(allocator, buf);
        }
        return try CrossRelReader.init(allocator, &[_]u8{});
    }
    pub fn getReference(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!ReferenceRelReader {
        if (self._reference_buf) |buf| {
            return try ReferenceRelReader.init(allocator, buf);
        }
        return try ReferenceRelReader.init(allocator, &[_]u8{});
    }
    pub fn getWrite(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!WriteRelReader {
        if (self._write_buf) |buf| {
            return try WriteRelReader.init(allocator, buf);
        }
        return try WriteRelReader.init(allocator, &[_]u8{});
    }
    pub fn getDdl(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!DdlRelReader {
        if (self._ddl_buf) |buf| {
            return try DdlRelReader.init(allocator, buf);
        }
        return try DdlRelReader.init(allocator, &[_]u8{});
    }
    pub fn getUpdate(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!UpdateRelReader {
        if (self._update_buf) |buf| {
            return try UpdateRelReader.init(allocator, buf);
        }
        return try UpdateRelReader.init(allocator, &[_]u8{});
    }
    pub fn getHashJoin(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!HashJoinRelReader {
        if (self._hash_join_buf) |buf| {
            return try HashJoinRelReader.init(allocator, buf);
        }
        return try HashJoinRelReader.init(allocator, &[_]u8{});
    }
    pub fn getMergeJoin(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!MergeJoinRelReader {
        if (self._merge_join_buf) |buf| {
            return try MergeJoinRelReader.init(allocator, buf);
        }
        return try MergeJoinRelReader.init(allocator, &[_]u8{});
    }
    pub fn getNestedLoopJoin(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!NestedLoopJoinRelReader {
        if (self._nested_loop_join_buf) |buf| {
            return try NestedLoopJoinRelReader.init(allocator, buf);
        }
        return try NestedLoopJoinRelReader.init(allocator, &[_]u8{});
    }
    pub fn getWindow(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!ConsistentPartitionWindowRelReader {
        if (self._window_buf) |buf| {
            return try ConsistentPartitionWindowRelReader.init(allocator, buf);
        }
        return try ConsistentPartitionWindowRelReader.init(allocator, &[_]u8{});
    }
    pub fn getExchange(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!ExchangeRelReader {
        if (self._exchange_buf) |buf| {
            return try ExchangeRelReader.init(allocator, buf);
        }
        return try ExchangeRelReader.init(allocator, &[_]u8{});
    }
    pub fn getExpand(self: *const RelReader, allocator: std.mem.Allocator) gremlin.Error!ExpandRelReader {
        if (self._expand_buf) |buf| {
            return try ExpandRelReader.init(allocator, buf);
        }
        return try ExpandRelReader.init(allocator, &[_]u8{});
    }
};

const NamedObjectWriteWire = struct {
    const NAMES_WIRE: gremlin.ProtoWireNumber = 1;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const NamedObjectWrite = struct {
    // fields
    names: ?[]const ?[]const u8 = null,
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const NamedObjectWrite) usize {
        var res: usize = 0;
        if (self.names) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(NamedObjectWriteWire.NAMES_WIRE);
                if (maybe_v) |v| {
                    res += gremlin.sizes.sizeUsize(v.len) + v.len;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(NamedObjectWriteWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const NamedObjectWrite, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const NamedObjectWrite, target: *gremlin.Writer) void {
        if (self.names) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    target.appendBytes(NamedObjectWriteWire.NAMES_WIRE, v);
                } else {
                    target.appendBytesTag(NamedObjectWriteWire.NAMES_WIRE, 0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(NamedObjectWriteWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const NamedObjectWriteReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _names: ?std.ArrayList([]const u8) = null,
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!NamedObjectWriteReader {
        var buf = gremlin.Reader.init(src);
        var res = NamedObjectWriteReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                NamedObjectWriteWire.NAMES_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._names == null) {
                        res._names = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._names.?.append(result.value);
                },
                NamedObjectWriteWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const NamedObjectWriteReader) void {
        if (self._names) |arr| {
            arr.deinit();
        }
    }
    pub fn getNames(self: *const NamedObjectWriteReader) []const []const u8 {
        if (self._names) |arr| {
            return arr.items;
        }
        return &[_][]u8{};
    }
    pub fn getAdvancedExtension(self: *const NamedObjectWriteReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const ExtensionObjectWire = struct {
    const DETAIL_WIRE: gremlin.ProtoWireNumber = 1;
};

pub const ExtensionObject = struct {
    // fields
    detail: ?any.Any = null,

    pub fn calcProtobufSize(self: *const ExtensionObject) usize {
        var res: usize = 0;
        if (self.detail) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExtensionObjectWire.DETAIL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const ExtensionObject, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ExtensionObject, target: *gremlin.Writer) void {
        if (self.detail) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExtensionObjectWire.DETAIL_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ExtensionObjectReader = struct {
    _detail_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExtensionObjectReader {
        var buf = gremlin.Reader.init(src);
        var res = ExtensionObjectReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ExtensionObjectWire.DETAIL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._detail_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const ExtensionObjectReader) void { }
    
    pub fn getDetail(self: *const ExtensionObjectReader, allocator: std.mem.Allocator) gremlin.Error!any.AnyReader {
        if (self._detail_buf) |buf| {
            return try any.AnyReader.init(allocator, buf);
        }
        return try any.AnyReader.init(allocator, &[_]u8{});
    }
};

const DdlRelWire = struct {
    const TABLE_SCHEMA_WIRE: gremlin.ProtoWireNumber = 3;
    const TABLE_DEFAULTS_WIRE: gremlin.ProtoWireNumber = 4;
    const OBJECT_WIRE: gremlin.ProtoWireNumber = 5;
    const OP_WIRE: gremlin.ProtoWireNumber = 6;
    const VIEW_DEFINITION_WIRE: gremlin.ProtoWireNumber = 7;
    const COMMON_WIRE: gremlin.ProtoWireNumber = 8;
    const NAMED_OBJECT_WIRE: gremlin.ProtoWireNumber = 1;
    const EXTENSION_OBJECT_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const DdlRel = struct {
    // nested enums
    pub const DdlObject = enum(i32) {
        DDL_OBJECT_UNSPECIFIED = 0,
        DDL_OBJECT_TABLE = 1,
        DDL_OBJECT_VIEW = 2,
    };
    
    pub const DdlOp = enum(i32) {
        DDL_OP_UNSPECIFIED = 0,
        DDL_OP_CREATE = 1,
        DDL_OP_CREATE_OR_REPLACE = 2,
        DDL_OP_ALTER = 3,
        DDL_OP_DROP = 4,
        DDL_OP_DROP_IF_EXIST = 5,
    };
    
    // fields
    table_schema: ?type.NamedStruct = null,
    table_defaults: ?Expression.Literal.Struct = null,
    object: DdlRel.DdlObject = @enumFromInt(0),
    op: DdlRel.DdlOp = @enumFromInt(0),
    view_definition: ?Rel = null,
    common: ?RelCommon = null,
    named_object: ?NamedObjectWrite = null,
    extension_object: ?ExtensionObject = null,

    pub fn calcProtobufSize(self: *const DdlRel) usize {
        var res: usize = 0;
        if (self.table_schema) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DdlRelWire.TABLE_SCHEMA_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.table_defaults) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DdlRelWire.TABLE_DEFAULTS_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (@intFromEnum(self.object) != 0) { res += gremlin.sizes.sizeWireNumber(DdlRelWire.OBJECT_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.object)); }
        if (@intFromEnum(self.op) != 0) { res += gremlin.sizes.sizeWireNumber(DdlRelWire.OP_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.op)); }
        if (self.view_definition) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DdlRelWire.VIEW_DEFINITION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DdlRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.named_object) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DdlRelWire.NAMED_OBJECT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.extension_object) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(DdlRelWire.EXTENSION_OBJECT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const DdlRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const DdlRel, target: *gremlin.Writer) void {
        if (self.table_schema) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DdlRelWire.TABLE_SCHEMA_WIRE, size);
            v.encodeTo(target);
        }
        if (self.table_defaults) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DdlRelWire.TABLE_DEFAULTS_WIRE, size);
            v.encodeTo(target);
        }
        if (@intFromEnum(self.object) != 0) { target.appendInt32(DdlRelWire.OBJECT_WIRE, @intFromEnum(self.object)); }
        if (@intFromEnum(self.op) != 0) { target.appendInt32(DdlRelWire.OP_WIRE, @intFromEnum(self.op)); }
        if (self.view_definition) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DdlRelWire.VIEW_DEFINITION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DdlRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.named_object) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DdlRelWire.NAMED_OBJECT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.extension_object) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(DdlRelWire.EXTENSION_OBJECT_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const DdlRelReader = struct {
    _table_schema_buf: ?[]const u8 = null,
    _table_defaults_buf: ?[]const u8 = null,
    _object: DdlRel.DdlObject = @enumFromInt(0),
    _op: DdlRel.DdlOp = @enumFromInt(0),
    _view_definition_buf: ?[]const u8 = null,
    _common_buf: ?[]const u8 = null,
    _named_object_buf: ?[]const u8 = null,
    _extension_object_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!DdlRelReader {
        var buf = gremlin.Reader.init(src);
        var res = DdlRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                DdlRelWire.TABLE_SCHEMA_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._table_schema_buf = result.value;
                },
                DdlRelWire.TABLE_DEFAULTS_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._table_defaults_buf = result.value;
                },
                DdlRelWire.OBJECT_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._object = @enumFromInt(result.value);
                },
                DdlRelWire.OP_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._op = @enumFromInt(result.value);
                },
                DdlRelWire.VIEW_DEFINITION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._view_definition_buf = result.value;
                },
                DdlRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                DdlRelWire.NAMED_OBJECT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._named_object_buf = result.value;
                },
                DdlRelWire.EXTENSION_OBJECT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._extension_object_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const DdlRelReader) void { }
    
    pub fn getTableSchema(self: *const DdlRelReader, allocator: std.mem.Allocator) gremlin.Error!type.NamedStructReader {
        if (self._table_schema_buf) |buf| {
            return try type.NamedStructReader.init(allocator, buf);
        }
        return try type.NamedStructReader.init(allocator, &[_]u8{});
    }
    pub fn getTableDefaults(self: *const DdlRelReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.StructReader {
        if (self._table_defaults_buf) |buf| {
            return try Expression.Literal.StructReader.init(allocator, buf);
        }
        return try Expression.Literal.StructReader.init(allocator, &[_]u8{});
    }
    pub inline fn getObject(self: *const DdlRelReader) DdlRel.DdlObject { return self._object; }
    pub inline fn getOp(self: *const DdlRelReader) DdlRel.DdlOp { return self._op; }
    pub fn getViewDefinition(self: *const DdlRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._view_definition_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getCommon(self: *const DdlRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getNamedObject(self: *const DdlRelReader, allocator: std.mem.Allocator) gremlin.Error!NamedObjectWriteReader {
        if (self._named_object_buf) |buf| {
            return try NamedObjectWriteReader.init(allocator, buf);
        }
        return try NamedObjectWriteReader.init(allocator, &[_]u8{});
    }
    pub fn getExtensionObject(self: *const DdlRelReader, allocator: std.mem.Allocator) gremlin.Error!ExtensionObjectReader {
        if (self._extension_object_buf) |buf| {
            return try ExtensionObjectReader.init(allocator, buf);
        }
        return try ExtensionObjectReader.init(allocator, &[_]u8{});
    }
};

const WriteRelWire = struct {
    const TABLE_SCHEMA_WIRE: gremlin.ProtoWireNumber = 3;
    const OP_WIRE: gremlin.ProtoWireNumber = 4;
    const INPUT_WIRE: gremlin.ProtoWireNumber = 5;
    const CREATE_MODE_WIRE: gremlin.ProtoWireNumber = 8;
    const OUTPUT_WIRE: gremlin.ProtoWireNumber = 6;
    const COMMON_WIRE: gremlin.ProtoWireNumber = 7;
    const NAMED_TABLE_WIRE: gremlin.ProtoWireNumber = 1;
    const EXTENSION_TABLE_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const WriteRel = struct {
    // nested enums
    pub const WriteOp = enum(i32) {
        WRITE_OP_UNSPECIFIED = 0,
        WRITE_OP_INSERT = 1,
        WRITE_OP_DELETE = 2,
        WRITE_OP_UPDATE = 3,
        WRITE_OP_CTAS = 4,
    };
    
    pub const CreateMode = enum(i32) {
        CREATE_MODE_UNSPECIFIED = 0,
        CREATE_MODE_APPEND_IF_EXISTS = 1,
        CREATE_MODE_REPLACE_IF_EXISTS = 2,
        CREATE_MODE_IGNORE_IF_EXISTS = 3,
        CREATE_MODE_ERROR_IF_EXISTS = 4,
    };
    
    pub const OutputMode = enum(i32) {
        OUTPUT_MODE_UNSPECIFIED = 0,
        OUTPUT_MODE_NO_OUTPUT = 1,
        OUTPUT_MODE_MODIFIED_RECORDS = 2,
    };
    
    // fields
    table_schema: ?type.NamedStruct = null,
    op: WriteRel.WriteOp = @enumFromInt(0),
    input: ?Rel = null,
    create_mode: WriteRel.CreateMode = @enumFromInt(0),
    output: WriteRel.OutputMode = @enumFromInt(0),
    common: ?RelCommon = null,
    named_table: ?NamedObjectWrite = null,
    extension_table: ?ExtensionObject = null,

    pub fn calcProtobufSize(self: *const WriteRel) usize {
        var res: usize = 0;
        if (self.table_schema) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(WriteRelWire.TABLE_SCHEMA_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (@intFromEnum(self.op) != 0) { res += gremlin.sizes.sizeWireNumber(WriteRelWire.OP_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.op)); }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(WriteRelWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (@intFromEnum(self.create_mode) != 0) { res += gremlin.sizes.sizeWireNumber(WriteRelWire.CREATE_MODE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.create_mode)); }
        if (@intFromEnum(self.output) != 0) { res += gremlin.sizes.sizeWireNumber(WriteRelWire.OUTPUT_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.output)); }
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(WriteRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.named_table) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(WriteRelWire.NAMED_TABLE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.extension_table) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(WriteRelWire.EXTENSION_TABLE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const WriteRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const WriteRel, target: *gremlin.Writer) void {
        if (self.table_schema) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(WriteRelWire.TABLE_SCHEMA_WIRE, size);
            v.encodeTo(target);
        }
        if (@intFromEnum(self.op) != 0) { target.appendInt32(WriteRelWire.OP_WIRE, @intFromEnum(self.op)); }
        if (self.input) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(WriteRelWire.INPUT_WIRE, size);
            v.encodeTo(target);
        }
        if (@intFromEnum(self.create_mode) != 0) { target.appendInt32(WriteRelWire.CREATE_MODE_WIRE, @intFromEnum(self.create_mode)); }
        if (@intFromEnum(self.output) != 0) { target.appendInt32(WriteRelWire.OUTPUT_WIRE, @intFromEnum(self.output)); }
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(WriteRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.named_table) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(WriteRelWire.NAMED_TABLE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.extension_table) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(WriteRelWire.EXTENSION_TABLE_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const WriteRelReader = struct {
    _table_schema_buf: ?[]const u8 = null,
    _op: WriteRel.WriteOp = @enumFromInt(0),
    _input_buf: ?[]const u8 = null,
    _create_mode: WriteRel.CreateMode = @enumFromInt(0),
    _output: WriteRel.OutputMode = @enumFromInt(0),
    _common_buf: ?[]const u8 = null,
    _named_table_buf: ?[]const u8 = null,
    _extension_table_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!WriteRelReader {
        var buf = gremlin.Reader.init(src);
        var res = WriteRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                WriteRelWire.TABLE_SCHEMA_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._table_schema_buf = result.value;
                },
                WriteRelWire.OP_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._op = @enumFromInt(result.value);
                },
                WriteRelWire.INPUT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._input_buf = result.value;
                },
                WriteRelWire.CREATE_MODE_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._create_mode = @enumFromInt(result.value);
                },
                WriteRelWire.OUTPUT_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._output = @enumFromInt(result.value);
                },
                WriteRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                WriteRelWire.NAMED_TABLE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._named_table_buf = result.value;
                },
                WriteRelWire.EXTENSION_TABLE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._extension_table_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const WriteRelReader) void { }
    
    pub fn getTableSchema(self: *const WriteRelReader, allocator: std.mem.Allocator) gremlin.Error!type.NamedStructReader {
        if (self._table_schema_buf) |buf| {
            return try type.NamedStructReader.init(allocator, buf);
        }
        return try type.NamedStructReader.init(allocator, &[_]u8{});
    }
    pub inline fn getOp(self: *const WriteRelReader) WriteRel.WriteOp { return self._op; }
    pub fn getInput(self: *const WriteRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._input_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub inline fn getCreateMode(self: *const WriteRelReader) WriteRel.CreateMode { return self._create_mode; }
    pub inline fn getOutput(self: *const WriteRelReader) WriteRel.OutputMode { return self._output; }
    pub fn getCommon(self: *const WriteRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getNamedTable(self: *const WriteRelReader, allocator: std.mem.Allocator) gremlin.Error!NamedObjectWriteReader {
        if (self._named_table_buf) |buf| {
            return try NamedObjectWriteReader.init(allocator, buf);
        }
        return try NamedObjectWriteReader.init(allocator, &[_]u8{});
    }
    pub fn getExtensionTable(self: *const WriteRelReader, allocator: std.mem.Allocator) gremlin.Error!ExtensionObjectReader {
        if (self._extension_table_buf) |buf| {
            return try ExtensionObjectReader.init(allocator, buf);
        }
        return try ExtensionObjectReader.init(allocator, &[_]u8{});
    }
};

const UpdateRelWire = struct {
    const TABLE_SCHEMA_WIRE: gremlin.ProtoWireNumber = 2;
    const CONDITION_WIRE: gremlin.ProtoWireNumber = 3;
    const TRANSFORMATIONS_WIRE: gremlin.ProtoWireNumber = 4;
    const NAMED_TABLE_WIRE: gremlin.ProtoWireNumber = 1;
};

pub const UpdateRel = struct {
    // nested structs
    const TransformExpressionWire = struct {
        const TRANSFORMATION_WIRE: gremlin.ProtoWireNumber = 1;
        const COLUMN_TARGET_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const TransformExpression = struct {
        // fields
        transformation: ?Expression = null,
        column_target: i32 = 0,

        pub fn calcProtobufSize(self: *const TransformExpression) usize {
            var res: usize = 0;
            if (self.transformation) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(UpdateRel.TransformExpressionWire.TRANSFORMATION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.column_target != 0) { res += gremlin.sizes.sizeWireNumber(UpdateRel.TransformExpressionWire.COLUMN_TARGET_WIRE) + gremlin.sizes.sizeI32(self.column_target); }
            return res;
        }

        pub fn encode(self: *const TransformExpression, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const TransformExpression, target: *gremlin.Writer) void {
            if (self.transformation) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(UpdateRel.TransformExpressionWire.TRANSFORMATION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.column_target != 0) { target.appendInt32(UpdateRel.TransformExpressionWire.COLUMN_TARGET_WIRE, self.column_target); }
        }
    };
    
    pub const TransformExpressionReader = struct {
        _transformation_buf: ?[]const u8 = null,
        _column_target: i32 = 0,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!TransformExpressionReader {
            var buf = gremlin.Reader.init(src);
            var res = TransformExpressionReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    UpdateRel.TransformExpressionWire.TRANSFORMATION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._transformation_buf = result.value;
                    },
                    UpdateRel.TransformExpressionWire.COLUMN_TARGET_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._column_target = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const TransformExpressionReader) void { }
        
        pub fn getTransformation(self: *const TransformExpressionReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
            if (self._transformation_buf) |buf| {
                return try ExpressionReader.init(allocator, buf);
            }
            return try ExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getColumnTarget(self: *const TransformExpressionReader) i32 { return self._column_target; }
    };
    
    // fields
    table_schema: ?type.NamedStruct = null,
    condition: ?Expression = null,
    transformations: ?[]const ?UpdateRel.TransformExpression = null,
    named_table: ?NamedTable = null,

    pub fn calcProtobufSize(self: *const UpdateRel) usize {
        var res: usize = 0;
        if (self.table_schema) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(UpdateRelWire.TABLE_SCHEMA_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.condition) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(UpdateRelWire.CONDITION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.transformations) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(UpdateRelWire.TRANSFORMATIONS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.named_table) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(UpdateRelWire.NAMED_TABLE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const UpdateRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const UpdateRel, target: *gremlin.Writer) void {
        if (self.table_schema) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(UpdateRelWire.TABLE_SCHEMA_WIRE, size);
            v.encodeTo(target);
        }
        if (self.condition) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(UpdateRelWire.CONDITION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.transformations) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(UpdateRelWire.TRANSFORMATIONS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(UpdateRelWire.TRANSFORMATIONS_WIRE, 0);
                }
            }
        }
        if (self.named_table) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(UpdateRelWire.NAMED_TABLE_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const UpdateRelReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _table_schema_buf: ?[]const u8 = null,
    _condition_buf: ?[]const u8 = null,
    _transformations_bufs: ?std.ArrayList([]const u8) = null,
    _named_table_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!UpdateRelReader {
        var buf = gremlin.Reader.init(src);
        var res = UpdateRelReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                UpdateRelWire.TABLE_SCHEMA_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._table_schema_buf = result.value;
                },
                UpdateRelWire.CONDITION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._condition_buf = result.value;
                },
                UpdateRelWire.TRANSFORMATIONS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._transformations_bufs == null) {
                        res._transformations_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._transformations_bufs.?.append(result.value);
                },
                UpdateRelWire.NAMED_TABLE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._named_table_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const UpdateRelReader) void {
        if (self._transformations_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getTableSchema(self: *const UpdateRelReader, allocator: std.mem.Allocator) gremlin.Error!type.NamedStructReader {
        if (self._table_schema_buf) |buf| {
            return try type.NamedStructReader.init(allocator, buf);
        }
        return try type.NamedStructReader.init(allocator, &[_]u8{});
    }
    pub fn getCondition(self: *const UpdateRelReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._condition_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
    pub fn getTransformations(self: *const UpdateRelReader, allocator: std.mem.Allocator) gremlin.Error![]UpdateRel.TransformExpressionReader {
        if (self._transformations_bufs) |bufs| {
            var result = try std.ArrayList(UpdateRel.TransformExpressionReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try UpdateRel.TransformExpressionReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]UpdateRel.TransformExpressionReader{};
    }
    pub fn getNamedTable(self: *const UpdateRelReader, allocator: std.mem.Allocator) gremlin.Error!NamedTableReader {
        if (self._named_table_buf) |buf| {
            return try NamedTableReader.init(allocator, buf);
        }
        return try NamedTableReader.init(allocator, &[_]u8{});
    }
};

const NamedTableWire = struct {
    const NAMES_WIRE: gremlin.ProtoWireNumber = 1;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const NamedTable = struct {
    // fields
    names: ?[]const ?[]const u8 = null,
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const NamedTable) usize {
        var res: usize = 0;
        if (self.names) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(NamedTableWire.NAMES_WIRE);
                if (maybe_v) |v| {
                    res += gremlin.sizes.sizeUsize(v.len) + v.len;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(NamedTableWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const NamedTable, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const NamedTable, target: *gremlin.Writer) void {
        if (self.names) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    target.appendBytes(NamedTableWire.NAMES_WIRE, v);
                } else {
                    target.appendBytesTag(NamedTableWire.NAMES_WIRE, 0);
                }
            }
        }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(NamedTableWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const NamedTableReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _names: ?std.ArrayList([]const u8) = null,
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!NamedTableReader {
        var buf = gremlin.Reader.init(src);
        var res = NamedTableReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                NamedTableWire.NAMES_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._names == null) {
                        res._names = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._names.?.append(result.value);
                },
                NamedTableWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const NamedTableReader) void {
        if (self._names) |arr| {
            arr.deinit();
        }
    }
    pub fn getNames(self: *const NamedTableReader) []const []const u8 {
        if (self._names) |arr| {
            return arr.items;
        }
        return &[_][]u8{};
    }
    pub fn getAdvancedExtension(self: *const NamedTableReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const ComparisonJoinKeyWire = struct {
    const LEFT_WIRE: gremlin.ProtoWireNumber = 1;
    const RIGHT_WIRE: gremlin.ProtoWireNumber = 2;
    const COMPARISON_WIRE: gremlin.ProtoWireNumber = 3;
};

pub const ComparisonJoinKey = struct {
    // nested enums
    pub const SimpleComparisonType = enum(i32) {
        SIMPLE_COMPARISON_TYPE_UNSPECIFIED = 0,
        SIMPLE_COMPARISON_TYPE_EQ = 1,
        SIMPLE_COMPARISON_TYPE_IS_NOT_DISTINCT_FROM = 2,
        SIMPLE_COMPARISON_TYPE_MIGHT_EQUAL = 3,
    };
    
    // nested structs
    const ComparisonTypeWire = struct {
        const SIMPLE_WIRE: gremlin.ProtoWireNumber = 1;
        const CUSTOM_FUNCTION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const ComparisonType = struct {
        // fields
        simple: ComparisonJoinKey.SimpleComparisonType = @enumFromInt(0),
        custom_function_reference: u32 = 0,

        pub fn calcProtobufSize(self: *const ComparisonType) usize {
            var res: usize = 0;
            if (@intFromEnum(self.simple) != 0) { res += gremlin.sizes.sizeWireNumber(ComparisonJoinKey.ComparisonTypeWire.SIMPLE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.simple)); }
            if (self.custom_function_reference != 0) { res += gremlin.sizes.sizeWireNumber(ComparisonJoinKey.ComparisonTypeWire.CUSTOM_FUNCTION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.custom_function_reference); }
            return res;
        }

        pub fn encode(self: *const ComparisonType, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ComparisonType, target: *gremlin.Writer) void {
            if (@intFromEnum(self.simple) != 0) { target.appendInt32(ComparisonJoinKey.ComparisonTypeWire.SIMPLE_WIRE, @intFromEnum(self.simple)); }
            if (self.custom_function_reference != 0) { target.appendUint32(ComparisonJoinKey.ComparisonTypeWire.CUSTOM_FUNCTION_REFERENCE_WIRE, self.custom_function_reference); }
        }
    };
    
    pub const ComparisonTypeReader = struct {
        _simple: ComparisonJoinKey.SimpleComparisonType = @enumFromInt(0),
        _custom_function_reference: u32 = 0,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ComparisonTypeReader {
            var buf = gremlin.Reader.init(src);
            var res = ComparisonTypeReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    ComparisonJoinKey.ComparisonTypeWire.SIMPLE_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._simple = @enumFromInt(result.value);
                    },
                    ComparisonJoinKey.ComparisonTypeWire.CUSTOM_FUNCTION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._custom_function_reference = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ComparisonTypeReader) void { }
        
        pub inline fn getSimple(self: *const ComparisonTypeReader) ComparisonJoinKey.SimpleComparisonType { return self._simple; }
        pub inline fn getCustomFunctionReference(self: *const ComparisonTypeReader) u32 { return self._custom_function_reference; }
    };
    
    // fields
    left: ?Expression.FieldReference = null,
    right: ?Expression.FieldReference = null,
    comparison: ?ComparisonJoinKey.ComparisonType = null,

    pub fn calcProtobufSize(self: *const ComparisonJoinKey) usize {
        var res: usize = 0;
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ComparisonJoinKeyWire.LEFT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ComparisonJoinKeyWire.RIGHT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.comparison) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ComparisonJoinKeyWire.COMPARISON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const ComparisonJoinKey, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ComparisonJoinKey, target: *gremlin.Writer) void {
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ComparisonJoinKeyWire.LEFT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ComparisonJoinKeyWire.RIGHT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.comparison) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ComparisonJoinKeyWire.COMPARISON_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ComparisonJoinKeyReader = struct {
    _left_buf: ?[]const u8 = null,
    _right_buf: ?[]const u8 = null,
    _comparison_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ComparisonJoinKeyReader {
        var buf = gremlin.Reader.init(src);
        var res = ComparisonJoinKeyReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ComparisonJoinKeyWire.LEFT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._left_buf = result.value;
                },
                ComparisonJoinKeyWire.RIGHT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._right_buf = result.value;
                },
                ComparisonJoinKeyWire.COMPARISON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._comparison_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const ComparisonJoinKeyReader) void { }
    
    pub fn getLeft(self: *const ComparisonJoinKeyReader, allocator: std.mem.Allocator) gremlin.Error!Expression.FieldReferenceReader {
        if (self._left_buf) |buf| {
            return try Expression.FieldReferenceReader.init(allocator, buf);
        }
        return try Expression.FieldReferenceReader.init(allocator, &[_]u8{});
    }
    pub fn getRight(self: *const ComparisonJoinKeyReader, allocator: std.mem.Allocator) gremlin.Error!Expression.FieldReferenceReader {
        if (self._right_buf) |buf| {
            return try Expression.FieldReferenceReader.init(allocator, buf);
        }
        return try Expression.FieldReferenceReader.init(allocator, &[_]u8{});
    }
    pub fn getComparison(self: *const ComparisonJoinKeyReader, allocator: std.mem.Allocator) gremlin.Error!ComparisonJoinKey.ComparisonTypeReader {
        if (self._comparison_buf) |buf| {
            return try ComparisonJoinKey.ComparisonTypeReader.init(allocator, buf);
        }
        return try ComparisonJoinKey.ComparisonTypeReader.init(allocator, &[_]u8{});
    }
};

const HashJoinRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const LEFT_WIRE: gremlin.ProtoWireNumber = 2;
    const RIGHT_WIRE: gremlin.ProtoWireNumber = 3;
    const LEFT_KEYS_WIRE: gremlin.ProtoWireNumber = 4;
    const RIGHT_KEYS_WIRE: gremlin.ProtoWireNumber = 5;
    const KEYS_WIRE: gremlin.ProtoWireNumber = 8;
    const POST_JOIN_FILTER_WIRE: gremlin.ProtoWireNumber = 6;
    const TYPE_WIRE: gremlin.ProtoWireNumber = 7;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const HashJoinRel = struct {
    // nested enums
    pub const JoinType = enum(i32) {
        JOIN_TYPE_UNSPECIFIED = 0,
        JOIN_TYPE_INNER = 1,
        JOIN_TYPE_OUTER = 2,
        JOIN_TYPE_LEFT = 3,
        JOIN_TYPE_RIGHT = 4,
        JOIN_TYPE_LEFT_SEMI = 5,
        JOIN_TYPE_RIGHT_SEMI = 6,
        JOIN_TYPE_LEFT_ANTI = 7,
        JOIN_TYPE_RIGHT_ANTI = 8,
        JOIN_TYPE_LEFT_SINGLE = 9,
        JOIN_TYPE_RIGHT_SINGLE = 10,
        JOIN_TYPE_LEFT_MARK = 11,
        JOIN_TYPE_RIGHT_MARK = 12,
    };
    
    // fields
    common: ?RelCommon = null,
    left: ?Rel = null,
    right: ?Rel = null,
    left_keys: ?[]const ?Expression.FieldReference = null,
    right_keys: ?[]const ?Expression.FieldReference = null,
    keys: ?[]const ?ComparisonJoinKey = null,
    post_join_filter: ?Expression = null,
    type: HashJoinRel.JoinType = @enumFromInt(0),
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const HashJoinRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(HashJoinRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(HashJoinRelWire.LEFT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(HashJoinRelWire.RIGHT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.left_keys) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(HashJoinRelWire.LEFT_KEYS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.right_keys) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(HashJoinRelWire.RIGHT_KEYS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.keys) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(HashJoinRelWire.KEYS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.post_join_filter) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(HashJoinRelWire.POST_JOIN_FILTER_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (@intFromEnum(self.type) != 0) { res += gremlin.sizes.sizeWireNumber(HashJoinRelWire.TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.type)); }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(HashJoinRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const HashJoinRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const HashJoinRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(HashJoinRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(HashJoinRelWire.LEFT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(HashJoinRelWire.RIGHT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.left_keys) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(HashJoinRelWire.LEFT_KEYS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(HashJoinRelWire.LEFT_KEYS_WIRE, 0);
                }
            }
        }
        if (self.right_keys) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(HashJoinRelWire.RIGHT_KEYS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(HashJoinRelWire.RIGHT_KEYS_WIRE, 0);
                }
            }
        }
        if (self.keys) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(HashJoinRelWire.KEYS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(HashJoinRelWire.KEYS_WIRE, 0);
                }
            }
        }
        if (self.post_join_filter) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(HashJoinRelWire.POST_JOIN_FILTER_WIRE, size);
            v.encodeTo(target);
        }
        if (@intFromEnum(self.type) != 0) { target.appendInt32(HashJoinRelWire.TYPE_WIRE, @intFromEnum(self.type)); }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(HashJoinRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const HashJoinRelReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _common_buf: ?[]const u8 = null,
    _left_buf: ?[]const u8 = null,
    _right_buf: ?[]const u8 = null,
    _left_keys_bufs: ?std.ArrayList([]const u8) = null,
    _right_keys_bufs: ?std.ArrayList([]const u8) = null,
    _keys_bufs: ?std.ArrayList([]const u8) = null,
    _post_join_filter_buf: ?[]const u8 = null,
    _type: HashJoinRel.JoinType = @enumFromInt(0),
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!HashJoinRelReader {
        var buf = gremlin.Reader.init(src);
        var res = HashJoinRelReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                HashJoinRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                HashJoinRelWire.LEFT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._left_buf = result.value;
                },
                HashJoinRelWire.RIGHT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._right_buf = result.value;
                },
                HashJoinRelWire.LEFT_KEYS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._left_keys_bufs == null) {
                        res._left_keys_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._left_keys_bufs.?.append(result.value);
                },
                HashJoinRelWire.RIGHT_KEYS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._right_keys_bufs == null) {
                        res._right_keys_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._right_keys_bufs.?.append(result.value);
                },
                HashJoinRelWire.KEYS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._keys_bufs == null) {
                        res._keys_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._keys_bufs.?.append(result.value);
                },
                HashJoinRelWire.POST_JOIN_FILTER_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._post_join_filter_buf = result.value;
                },
                HashJoinRelWire.TYPE_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._type = @enumFromInt(result.value);
                },
                HashJoinRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const HashJoinRelReader) void {
        if (self._left_keys_bufs) |arr| {
            arr.deinit();
        }
        if (self._right_keys_bufs) |arr| {
            arr.deinit();
        }
        if (self._keys_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getCommon(self: *const HashJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getLeft(self: *const HashJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._left_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getRight(self: *const HashJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._right_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getLeftKeys(self: *const HashJoinRelReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.FieldReferenceReader {
        if (self._left_keys_bufs) |bufs| {
            var result = try std.ArrayList(Expression.FieldReferenceReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try Expression.FieldReferenceReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]Expression.FieldReferenceReader{};
    }
    pub fn getRightKeys(self: *const HashJoinRelReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.FieldReferenceReader {
        if (self._right_keys_bufs) |bufs| {
            var result = try std.ArrayList(Expression.FieldReferenceReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try Expression.FieldReferenceReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]Expression.FieldReferenceReader{};
    }
    pub fn getKeys(self: *const HashJoinRelReader, allocator: std.mem.Allocator) gremlin.Error![]ComparisonJoinKeyReader {
        if (self._keys_bufs) |bufs| {
            var result = try std.ArrayList(ComparisonJoinKeyReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try ComparisonJoinKeyReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]ComparisonJoinKeyReader{};
    }
    pub fn getPostJoinFilter(self: *const HashJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._post_join_filter_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
    pub inline fn getType(self: *const HashJoinRelReader) HashJoinRel.JoinType { return self._type; }
    pub fn getAdvancedExtension(self: *const HashJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const MergeJoinRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const LEFT_WIRE: gremlin.ProtoWireNumber = 2;
    const RIGHT_WIRE: gremlin.ProtoWireNumber = 3;
    const LEFT_KEYS_WIRE: gremlin.ProtoWireNumber = 4;
    const RIGHT_KEYS_WIRE: gremlin.ProtoWireNumber = 5;
    const KEYS_WIRE: gremlin.ProtoWireNumber = 8;
    const POST_JOIN_FILTER_WIRE: gremlin.ProtoWireNumber = 6;
    const TYPE_WIRE: gremlin.ProtoWireNumber = 7;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const MergeJoinRel = struct {
    // nested enums
    pub const JoinType = enum(i32) {
        JOIN_TYPE_UNSPECIFIED = 0,
        JOIN_TYPE_INNER = 1,
        JOIN_TYPE_OUTER = 2,
        JOIN_TYPE_LEFT = 3,
        JOIN_TYPE_RIGHT = 4,
        JOIN_TYPE_LEFT_SEMI = 5,
        JOIN_TYPE_RIGHT_SEMI = 6,
        JOIN_TYPE_LEFT_ANTI = 7,
        JOIN_TYPE_RIGHT_ANTI = 8,
        JOIN_TYPE_LEFT_SINGLE = 9,
        JOIN_TYPE_RIGHT_SINGLE = 10,
        JOIN_TYPE_LEFT_MARK = 11,
        JOIN_TYPE_RIGHT_MARK = 12,
    };
    
    // fields
    common: ?RelCommon = null,
    left: ?Rel = null,
    right: ?Rel = null,
    left_keys: ?[]const ?Expression.FieldReference = null,
    right_keys: ?[]const ?Expression.FieldReference = null,
    keys: ?[]const ?ComparisonJoinKey = null,
    post_join_filter: ?Expression = null,
    type: MergeJoinRel.JoinType = @enumFromInt(0),
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const MergeJoinRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(MergeJoinRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(MergeJoinRelWire.LEFT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(MergeJoinRelWire.RIGHT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.left_keys) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(MergeJoinRelWire.LEFT_KEYS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.right_keys) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(MergeJoinRelWire.RIGHT_KEYS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.keys) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(MergeJoinRelWire.KEYS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.post_join_filter) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(MergeJoinRelWire.POST_JOIN_FILTER_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (@intFromEnum(self.type) != 0) { res += gremlin.sizes.sizeWireNumber(MergeJoinRelWire.TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.type)); }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(MergeJoinRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const MergeJoinRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const MergeJoinRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(MergeJoinRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(MergeJoinRelWire.LEFT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(MergeJoinRelWire.RIGHT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.left_keys) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(MergeJoinRelWire.LEFT_KEYS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(MergeJoinRelWire.LEFT_KEYS_WIRE, 0);
                }
            }
        }
        if (self.right_keys) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(MergeJoinRelWire.RIGHT_KEYS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(MergeJoinRelWire.RIGHT_KEYS_WIRE, 0);
                }
            }
        }
        if (self.keys) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(MergeJoinRelWire.KEYS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(MergeJoinRelWire.KEYS_WIRE, 0);
                }
            }
        }
        if (self.post_join_filter) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(MergeJoinRelWire.POST_JOIN_FILTER_WIRE, size);
            v.encodeTo(target);
        }
        if (@intFromEnum(self.type) != 0) { target.appendInt32(MergeJoinRelWire.TYPE_WIRE, @intFromEnum(self.type)); }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(MergeJoinRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const MergeJoinRelReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _common_buf: ?[]const u8 = null,
    _left_buf: ?[]const u8 = null,
    _right_buf: ?[]const u8 = null,
    _left_keys_bufs: ?std.ArrayList([]const u8) = null,
    _right_keys_bufs: ?std.ArrayList([]const u8) = null,
    _keys_bufs: ?std.ArrayList([]const u8) = null,
    _post_join_filter_buf: ?[]const u8 = null,
    _type: MergeJoinRel.JoinType = @enumFromInt(0),
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!MergeJoinRelReader {
        var buf = gremlin.Reader.init(src);
        var res = MergeJoinRelReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                MergeJoinRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                MergeJoinRelWire.LEFT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._left_buf = result.value;
                },
                MergeJoinRelWire.RIGHT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._right_buf = result.value;
                },
                MergeJoinRelWire.LEFT_KEYS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._left_keys_bufs == null) {
                        res._left_keys_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._left_keys_bufs.?.append(result.value);
                },
                MergeJoinRelWire.RIGHT_KEYS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._right_keys_bufs == null) {
                        res._right_keys_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._right_keys_bufs.?.append(result.value);
                },
                MergeJoinRelWire.KEYS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._keys_bufs == null) {
                        res._keys_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._keys_bufs.?.append(result.value);
                },
                MergeJoinRelWire.POST_JOIN_FILTER_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._post_join_filter_buf = result.value;
                },
                MergeJoinRelWire.TYPE_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._type = @enumFromInt(result.value);
                },
                MergeJoinRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const MergeJoinRelReader) void {
        if (self._left_keys_bufs) |arr| {
            arr.deinit();
        }
        if (self._right_keys_bufs) |arr| {
            arr.deinit();
        }
        if (self._keys_bufs) |arr| {
            arr.deinit();
        }
    }
    pub fn getCommon(self: *const MergeJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getLeft(self: *const MergeJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._left_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getRight(self: *const MergeJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._right_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getLeftKeys(self: *const MergeJoinRelReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.FieldReferenceReader {
        if (self._left_keys_bufs) |bufs| {
            var result = try std.ArrayList(Expression.FieldReferenceReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try Expression.FieldReferenceReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]Expression.FieldReferenceReader{};
    }
    pub fn getRightKeys(self: *const MergeJoinRelReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.FieldReferenceReader {
        if (self._right_keys_bufs) |bufs| {
            var result = try std.ArrayList(Expression.FieldReferenceReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try Expression.FieldReferenceReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]Expression.FieldReferenceReader{};
    }
    pub fn getKeys(self: *const MergeJoinRelReader, allocator: std.mem.Allocator) gremlin.Error![]ComparisonJoinKeyReader {
        if (self._keys_bufs) |bufs| {
            var result = try std.ArrayList(ComparisonJoinKeyReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try ComparisonJoinKeyReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]ComparisonJoinKeyReader{};
    }
    pub fn getPostJoinFilter(self: *const MergeJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._post_join_filter_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
    pub inline fn getType(self: *const MergeJoinRelReader) MergeJoinRel.JoinType { return self._type; }
    pub fn getAdvancedExtension(self: *const MergeJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const NestedLoopJoinRelWire = struct {
    const COMMON_WIRE: gremlin.ProtoWireNumber = 1;
    const LEFT_WIRE: gremlin.ProtoWireNumber = 2;
    const RIGHT_WIRE: gremlin.ProtoWireNumber = 3;
    const EXPRESSION_WIRE: gremlin.ProtoWireNumber = 4;
    const TYPE_WIRE: gremlin.ProtoWireNumber = 5;
    const ADVANCED_EXTENSION_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const NestedLoopJoinRel = struct {
    // nested enums
    pub const JoinType = enum(i32) {
        JOIN_TYPE_UNSPECIFIED = 0,
        JOIN_TYPE_INNER = 1,
        JOIN_TYPE_OUTER = 2,
        JOIN_TYPE_LEFT = 3,
        JOIN_TYPE_RIGHT = 4,
        JOIN_TYPE_LEFT_SEMI = 5,
        JOIN_TYPE_RIGHT_SEMI = 6,
        JOIN_TYPE_LEFT_ANTI = 7,
        JOIN_TYPE_RIGHT_ANTI = 8,
        JOIN_TYPE_LEFT_SINGLE = 9,
        JOIN_TYPE_RIGHT_SINGLE = 10,
        JOIN_TYPE_LEFT_MARK = 11,
        JOIN_TYPE_RIGHT_MARK = 12,
    };
    
    // fields
    common: ?RelCommon = null,
    left: ?Rel = null,
    right: ?Rel = null,
    expression: ?Expression = null,
    type: NestedLoopJoinRel.JoinType = @enumFromInt(0),
    advanced_extension: ?extensions.AdvancedExtension = null,

    pub fn calcProtobufSize(self: *const NestedLoopJoinRel) usize {
        var res: usize = 0;
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(NestedLoopJoinRelWire.COMMON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(NestedLoopJoinRelWire.LEFT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(NestedLoopJoinRelWire.RIGHT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.expression) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(NestedLoopJoinRelWire.EXPRESSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (@intFromEnum(self.type) != 0) { res += gremlin.sizes.sizeWireNumber(NestedLoopJoinRelWire.TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.type)); }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(NestedLoopJoinRelWire.ADVANCED_EXTENSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const NestedLoopJoinRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const NestedLoopJoinRel, target: *gremlin.Writer) void {
        if (self.common) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(NestedLoopJoinRelWire.COMMON_WIRE, size);
            v.encodeTo(target);
        }
        if (self.left) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(NestedLoopJoinRelWire.LEFT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.right) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(NestedLoopJoinRelWire.RIGHT_WIRE, size);
            v.encodeTo(target);
        }
        if (self.expression) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(NestedLoopJoinRelWire.EXPRESSION_WIRE, size);
            v.encodeTo(target);
        }
        if (@intFromEnum(self.type) != 0) { target.appendInt32(NestedLoopJoinRelWire.TYPE_WIRE, @intFromEnum(self.type)); }
        if (self.advanced_extension) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(NestedLoopJoinRelWire.ADVANCED_EXTENSION_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const NestedLoopJoinRelReader = struct {
    _common_buf: ?[]const u8 = null,
    _left_buf: ?[]const u8 = null,
    _right_buf: ?[]const u8 = null,
    _expression_buf: ?[]const u8 = null,
    _type: NestedLoopJoinRel.JoinType = @enumFromInt(0),
    _advanced_extension_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!NestedLoopJoinRelReader {
        var buf = gremlin.Reader.init(src);
        var res = NestedLoopJoinRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                NestedLoopJoinRelWire.COMMON_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._common_buf = result.value;
                },
                NestedLoopJoinRelWire.LEFT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._left_buf = result.value;
                },
                NestedLoopJoinRelWire.RIGHT_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._right_buf = result.value;
                },
                NestedLoopJoinRelWire.EXPRESSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._expression_buf = result.value;
                },
                NestedLoopJoinRelWire.TYPE_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._type = @enumFromInt(result.value);
                },
                NestedLoopJoinRelWire.ADVANCED_EXTENSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._advanced_extension_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const NestedLoopJoinRelReader) void { }
    
    pub fn getCommon(self: *const NestedLoopJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelCommonReader {
        if (self._common_buf) |buf| {
            return try RelCommonReader.init(allocator, buf);
        }
        return try RelCommonReader.init(allocator, &[_]u8{});
    }
    pub fn getLeft(self: *const NestedLoopJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._left_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getRight(self: *const NestedLoopJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
        if (self._right_buf) |buf| {
            return try RelReader.init(allocator, buf);
        }
        return try RelReader.init(allocator, &[_]u8{});
    }
    pub fn getExpression(self: *const NestedLoopJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._expression_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
    pub inline fn getType(self: *const NestedLoopJoinRelReader) NestedLoopJoinRel.JoinType { return self._type; }
    pub fn getAdvancedExtension(self: *const NestedLoopJoinRelReader, allocator: std.mem.Allocator) gremlin.Error!extensions.AdvancedExtensionReader {
        if (self._advanced_extension_buf) |buf| {
            return try extensions.AdvancedExtensionReader.init(allocator, buf);
        }
        return try extensions.AdvancedExtensionReader.init(allocator, &[_]u8{});
    }
};

const FunctionArgumentWire = struct {
    const ENUM_WIRE: gremlin.ProtoWireNumber = 1;
    const TYPE_WIRE: gremlin.ProtoWireNumber = 2;
    const VALUE_WIRE: gremlin.ProtoWireNumber = 3;
};

pub const FunctionArgument = struct {
    // fields
    enum_: ?[]const u8 = null,
    type: ?type.Type = null,
    value: ?Expression = null,

    pub fn calcProtobufSize(self: *const FunctionArgument) usize {
        var res: usize = 0;
        if (self.enum_) |v| { res += gremlin.sizes.sizeWireNumber(FunctionArgumentWire.ENUM_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
        if (self.type) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(FunctionArgumentWire.TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.value) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(FunctionArgumentWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const FunctionArgument, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const FunctionArgument, target: *gremlin.Writer) void {
        if (self.enum_) |v| { target.appendBytes(FunctionArgumentWire.ENUM_WIRE, v); }
        if (self.type) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(FunctionArgumentWire.TYPE_WIRE, size);
            v.encodeTo(target);
        }
        if (self.value) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(FunctionArgumentWire.VALUE_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const FunctionArgumentReader = struct {
    _enum_: ?[]const u8 = null,
    _type_buf: ?[]const u8 = null,
    _value_buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!FunctionArgumentReader {
        var buf = gremlin.Reader.init(src);
        var res = FunctionArgumentReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                FunctionArgumentWire.ENUM_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._enum_ = result.value;
                },
                FunctionArgumentWire.TYPE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._type_buf = result.value;
                },
                FunctionArgumentWire.VALUE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._value_buf = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const FunctionArgumentReader) void { }
    
    pub inline fn getEnum(self: *const FunctionArgumentReader) []const u8 { return self._enum_ orelse &[_]u8{}; }
    pub fn getType(self: *const FunctionArgumentReader, allocator: std.mem.Allocator) gremlin.Error!type.TypeReader {
        if (self._type_buf) |buf| {
            return try type.TypeReader.init(allocator, buf);
        }
        return try type.TypeReader.init(allocator, &[_]u8{});
    }
    pub fn getValue(self: *const FunctionArgumentReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._value_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
};

const FunctionOptionWire = struct {
    const NAME_WIRE: gremlin.ProtoWireNumber = 1;
    const PREFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const FunctionOption = struct {
    // fields
    name: ?[]const u8 = null,
    preference: ?[]const ?[]const u8 = null,

    pub fn calcProtobufSize(self: *const FunctionOption) usize {
        var res: usize = 0;
        if (self.name) |v| { res += gremlin.sizes.sizeWireNumber(FunctionOptionWire.NAME_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
        if (self.preference) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(FunctionOptionWire.PREFERENCE_WIRE);
                if (maybe_v) |v| {
                    res += gremlin.sizes.sizeUsize(v.len) + v.len;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        return res;
    }

    pub fn encode(self: *const FunctionOption, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const FunctionOption, target: *gremlin.Writer) void {
        if (self.name) |v| { target.appendBytes(FunctionOptionWire.NAME_WIRE, v); }
        if (self.preference) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    target.appendBytes(FunctionOptionWire.PREFERENCE_WIRE, v);
                } else {
                    target.appendBytesTag(FunctionOptionWire.PREFERENCE_WIRE, 0);
                }
            }
        }
    }
};

pub const FunctionOptionReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _name: ?[]const u8 = null,
    _preference: ?std.ArrayList([]const u8) = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!FunctionOptionReader {
        var buf = gremlin.Reader.init(src);
        var res = FunctionOptionReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                FunctionOptionWire.NAME_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._name = result.value;
                },
                FunctionOptionWire.PREFERENCE_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._preference == null) {
                        res._preference = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._preference.?.append(result.value);
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const FunctionOptionReader) void {
        if (self._preference) |arr| {
            arr.deinit();
        }
    }
    pub inline fn getName(self: *const FunctionOptionReader) []const u8 { return self._name orelse &[_]u8{}; }
    pub fn getPreference(self: *const FunctionOptionReader) []const []const u8 {
        if (self._preference) |arr| {
            return arr.items;
        }
        return &[_][]u8{};
    }
};

const ExpressionWire = struct {
    const LITERAL_WIRE: gremlin.ProtoWireNumber = 1;
    const SELECTION_WIRE: gremlin.ProtoWireNumber = 2;
    const SCALAR_FUNCTION_WIRE: gremlin.ProtoWireNumber = 3;
    const WINDOW_FUNCTION_WIRE: gremlin.ProtoWireNumber = 5;
    const IF_THEN_WIRE: gremlin.ProtoWireNumber = 6;
    const SWITCH_EXPRESSION_WIRE: gremlin.ProtoWireNumber = 7;
    const SINGULAR_OR_LIST_WIRE: gremlin.ProtoWireNumber = 8;
    const MULTI_OR_LIST_WIRE: gremlin.ProtoWireNumber = 9;
    const CAST_WIRE: gremlin.ProtoWireNumber = 11;
    const SUBQUERY_WIRE: gremlin.ProtoWireNumber = 12;
    const NESTED_WIRE: gremlin.ProtoWireNumber = 13;
    const ENUM_WIRE: gremlin.ProtoWireNumber = 10;
};

pub const Expression = struct {
    // nested structs
    const EnumWire = struct {
        const SPECIFIED_WIRE: gremlin.ProtoWireNumber = 1;
        const UNSPECIFIED_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const Enum = struct {
        // nested structs
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
        
        // fields
        specified: ?[]const u8 = null,
        unspecified: ?Expression.Enum.Empty = null,

        pub fn calcProtobufSize(self: *const Enum) usize {
            var res: usize = 0;
            if (self.specified) |v| { res += gremlin.sizes.sizeWireNumber(Expression.EnumWire.SPECIFIED_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.unspecified) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.EnumWire.UNSPECIFIED_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const Enum, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Enum, target: *gremlin.Writer) void {
            if (self.specified) |v| { target.appendBytes(Expression.EnumWire.SPECIFIED_WIRE, v); }
            if (self.unspecified) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.EnumWire.UNSPECIFIED_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const EnumReader = struct {
        _specified: ?[]const u8 = null,
        _unspecified_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!EnumReader {
            var buf = gremlin.Reader.init(src);
            var res = EnumReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.EnumWire.SPECIFIED_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._specified = result.value;
                    },
                    Expression.EnumWire.UNSPECIFIED_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._unspecified_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const EnumReader) void { }
        
        pub inline fn getSpecified(self: *const EnumReader) []const u8 { return self._specified orelse &[_]u8{}; }
        pub fn getUnspecified(self: *const EnumReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Enum.EmptyReader {
            if (self._unspecified_buf) |buf| {
                return try Expression.Enum.EmptyReader.init(allocator, buf);
            }
            return try Expression.Enum.EmptyReader.init(allocator, &[_]u8{});
        }
    };
    
    const LiteralWire = struct {
        const NULLABLE_WIRE: gremlin.ProtoWireNumber = 50;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 51;
        const BOOLEAN_WIRE: gremlin.ProtoWireNumber = 1;
        const I8_WIRE: gremlin.ProtoWireNumber = 2;
        const I16_WIRE: gremlin.ProtoWireNumber = 3;
        const I32_WIRE: gremlin.ProtoWireNumber = 5;
        const I64_WIRE: gremlin.ProtoWireNumber = 7;
        const FP32_WIRE: gremlin.ProtoWireNumber = 10;
        const FP64_WIRE: gremlin.ProtoWireNumber = 11;
        const STRING_WIRE: gremlin.ProtoWireNumber = 12;
        const BINARY_WIRE: gremlin.ProtoWireNumber = 13;
        const TIMESTAMP_WIRE: gremlin.ProtoWireNumber = 14;
        const DATE_WIRE: gremlin.ProtoWireNumber = 16;
        const TIME_WIRE: gremlin.ProtoWireNumber = 17;
        const INTERVAL_YEAR_TO_MONTH_WIRE: gremlin.ProtoWireNumber = 19;
        const INTERVAL_DAY_TO_SECOND_WIRE: gremlin.ProtoWireNumber = 20;
        const INTERVAL_COMPOUND_WIRE: gremlin.ProtoWireNumber = 36;
        const FIXED_CHAR_WIRE: gremlin.ProtoWireNumber = 21;
        const VAR_CHAR_WIRE: gremlin.ProtoWireNumber = 22;
        const FIXED_BINARY_WIRE: gremlin.ProtoWireNumber = 23;
        const DECIMAL_WIRE: gremlin.ProtoWireNumber = 24;
        const PRECISION_TIMESTAMP_WIRE: gremlin.ProtoWireNumber = 34;
        const PRECISION_TIMESTAMP_TZ_WIRE: gremlin.ProtoWireNumber = 35;
        const STRUCT_WIRE: gremlin.ProtoWireNumber = 25;
        const MAP_WIRE: gremlin.ProtoWireNumber = 26;
        const TIMESTAMP_TZ_WIRE: gremlin.ProtoWireNumber = 27;
        const UUID_WIRE: gremlin.ProtoWireNumber = 28;
        const NULL_WIRE: gremlin.ProtoWireNumber = 29;
        const LIST_WIRE: gremlin.ProtoWireNumber = 30;
        const EMPTY_LIST_WIRE: gremlin.ProtoWireNumber = 31;
        const EMPTY_MAP_WIRE: gremlin.ProtoWireNumber = 32;
        const USER_DEFINED_WIRE: gremlin.ProtoWireNumber = 33;
    };
    
    pub const Literal = struct {
        // nested structs
        const VarCharWire = struct {
            const VALUE_WIRE: gremlin.ProtoWireNumber = 1;
            const LENGTH_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const VarChar = struct {
            // fields
            value: ?[]const u8 = null,
            length: u32 = 0,

            pub fn calcProtobufSize(self: *const VarChar) usize {
                var res: usize = 0;
                if (self.value) |v| { res += gremlin.sizes.sizeWireNumber(Expression.Literal.VarCharWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                if (self.length != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.VarCharWire.LENGTH_WIRE) + gremlin.sizes.sizeU32(self.length); }
                return res;
            }

            pub fn encode(self: *const VarChar, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const VarChar, target: *gremlin.Writer) void {
                if (self.value) |v| { target.appendBytes(Expression.Literal.VarCharWire.VALUE_WIRE, v); }
                if (self.length != 0) { target.appendUint32(Expression.Literal.VarCharWire.LENGTH_WIRE, self.length); }
            }
        };
        
        pub const VarCharReader = struct {
            _value: ?[]const u8 = null,
            _length: u32 = 0,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!VarCharReader {
                var buf = gremlin.Reader.init(src);
                var res = VarCharReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Literal.VarCharWire.VALUE_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._value = result.value;
                        },
                        Expression.Literal.VarCharWire.LENGTH_WIRE => {
                          const result = try buf.readUInt32(offset);
                          offset += result.size;
                          res._length = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const VarCharReader) void { }
            
            pub inline fn getValue(self: *const VarCharReader) []const u8 { return self._value orelse &[_]u8{}; }
            pub inline fn getLength(self: *const VarCharReader) u32 { return self._length; }
        };
        
        const DecimalWire = struct {
            const VALUE_WIRE: gremlin.ProtoWireNumber = 1;
            const PRECISION_WIRE: gremlin.ProtoWireNumber = 2;
            const SCALE_WIRE: gremlin.ProtoWireNumber = 3;
        };
        
        pub const Decimal = struct {
            // fields
            value: ?[]const u8 = null,
            precision: i32 = 0,
            scale: i32 = 0,

            pub fn calcProtobufSize(self: *const Decimal) usize {
                var res: usize = 0;
                if (self.value) |v| { res += gremlin.sizes.sizeWireNumber(Expression.Literal.DecimalWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                if (self.precision != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.DecimalWire.PRECISION_WIRE) + gremlin.sizes.sizeI32(self.precision); }
                if (self.scale != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.DecimalWire.SCALE_WIRE) + gremlin.sizes.sizeI32(self.scale); }
                return res;
            }

            pub fn encode(self: *const Decimal, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const Decimal, target: *gremlin.Writer) void {
                if (self.value) |v| { target.appendBytes(Expression.Literal.DecimalWire.VALUE_WIRE, v); }
                if (self.precision != 0) { target.appendInt32(Expression.Literal.DecimalWire.PRECISION_WIRE, self.precision); }
                if (self.scale != 0) { target.appendInt32(Expression.Literal.DecimalWire.SCALE_WIRE, self.scale); }
            }
        };
        
        pub const DecimalReader = struct {
            _value: ?[]const u8 = null,
            _precision: i32 = 0,
            _scale: i32 = 0,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!DecimalReader {
                var buf = gremlin.Reader.init(src);
                var res = DecimalReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Literal.DecimalWire.VALUE_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._value = result.value;
                        },
                        Expression.Literal.DecimalWire.PRECISION_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._precision = result.value;
                        },
                        Expression.Literal.DecimalWire.SCALE_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._scale = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const DecimalReader) void { }
            
            pub inline fn getValue(self: *const DecimalReader) []const u8 { return self._value orelse &[_]u8{}; }
            pub inline fn getPrecision(self: *const DecimalReader) i32 { return self._precision; }
            pub inline fn getScale(self: *const DecimalReader) i32 { return self._scale; }
        };
        
        const PrecisionTimestampWire = struct {
            const PRECISION_WIRE: gremlin.ProtoWireNumber = 1;
            const VALUE_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const PrecisionTimestamp = struct {
            // fields
            precision: i32 = 0,
            value: i64 = 0,

            pub fn calcProtobufSize(self: *const PrecisionTimestamp) usize {
                var res: usize = 0;
                if (self.precision != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.PrecisionTimestampWire.PRECISION_WIRE) + gremlin.sizes.sizeI32(self.precision); }
                if (self.value != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.PrecisionTimestampWire.VALUE_WIRE) + gremlin.sizes.sizeI64(self.value); }
                return res;
            }

            pub fn encode(self: *const PrecisionTimestamp, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const PrecisionTimestamp, target: *gremlin.Writer) void {
                if (self.precision != 0) { target.appendInt32(Expression.Literal.PrecisionTimestampWire.PRECISION_WIRE, self.precision); }
                if (self.value != 0) { target.appendInt64(Expression.Literal.PrecisionTimestampWire.VALUE_WIRE, self.value); }
            }
        };
        
        pub const PrecisionTimestampReader = struct {
            _precision: i32 = 0,
            _value: i64 = 0,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!PrecisionTimestampReader {
                var buf = gremlin.Reader.init(src);
                var res = PrecisionTimestampReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Literal.PrecisionTimestampWire.PRECISION_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._precision = result.value;
                        },
                        Expression.Literal.PrecisionTimestampWire.VALUE_WIRE => {
                          const result = try buf.readInt64(offset);
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
            pub fn deinit(_: *const PrecisionTimestampReader) void { }
            
            pub inline fn getPrecision(self: *const PrecisionTimestampReader) i32 { return self._precision; }
            pub inline fn getValue(self: *const PrecisionTimestampReader) i64 { return self._value; }
        };
        
        const MapWire = struct {
            const KEY_VALUES_WIRE: gremlin.ProtoWireNumber = 1;
        };
        
        pub const Map = struct {
            // nested structs
            const KeyValueWire = struct {
                const KEY_WIRE: gremlin.ProtoWireNumber = 1;
                const VALUE_WIRE: gremlin.ProtoWireNumber = 2;
            };
            
            pub const KeyValue = struct {
                // fields
                key: ?Expression.Literal = null,
                value: ?Expression.Literal = null,

                pub fn calcProtobufSize(self: *const KeyValue) usize {
                    var res: usize = 0;
                    if (self.key) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeWireNumber(Expression.Literal.Map.KeyValueWire.KEY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                    }
                    if (self.value) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeWireNumber(Expression.Literal.Map.KeyValueWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                    }
                    return res;
                }

                pub fn encode(self: *const KeyValue, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(self: *const KeyValue, target: *gremlin.Writer) void {
                    if (self.key) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.Literal.Map.KeyValueWire.KEY_WIRE, size);
                        v.encodeTo(target);
                    }
                    if (self.value) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.Literal.Map.KeyValueWire.VALUE_WIRE, size);
                        v.encodeTo(target);
                    }
                }
            };
            
            pub const KeyValueReader = struct {
                _key_buf: ?[]const u8 = null,
                _value_buf: ?[]const u8 = null,

                pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!KeyValueReader {
                    var buf = gremlin.Reader.init(src);
                    var res = KeyValueReader{};
                    if (buf.buf.len == 0) {
                        return res;
                    }
                    var offset: usize = 0;
                    while (buf.hasNext(offset, 0)) {
                        const tag = try buf.readTagAt(offset);
                        offset += tag.size;
                        switch (tag.number) {
                            Expression.Literal.Map.KeyValueWire.KEY_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._key_buf = result.value;
                            },
                            Expression.Literal.Map.KeyValueWire.VALUE_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._value_buf = result.value;
                            },
                            else => {
                                offset = try buf.skipData(offset, tag.wire);
                            }
                        }
                    }
                    return res;
                }
                pub fn deinit(_: *const KeyValueReader) void { }
                
                pub fn getKey(self: *const KeyValueReader, allocator: std.mem.Allocator) gremlin.Error!Expression.LiteralReader {
                    if (self._key_buf) |buf| {
                        return try Expression.LiteralReader.init(allocator, buf);
                    }
                    return try Expression.LiteralReader.init(allocator, &[_]u8{});
                }
                pub fn getValue(self: *const KeyValueReader, allocator: std.mem.Allocator) gremlin.Error!Expression.LiteralReader {
                    if (self._value_buf) |buf| {
                        return try Expression.LiteralReader.init(allocator, buf);
                    }
                    return try Expression.LiteralReader.init(allocator, &[_]u8{});
                }
            };
            
            // fields
            key_values: ?[]const ?Expression.Literal.Map.KeyValue = null,

            pub fn calcProtobufSize(self: *const Map) usize {
                var res: usize = 0;
                if (self.key_values) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.Literal.MapWire.KEY_VALUES_WIRE);
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            res += gremlin.sizes.sizeUsize(size) + size;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                return res;
            }

            pub fn encode(self: *const Map, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const Map, target: *gremlin.Writer) void {
                if (self.key_values) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            target.appendBytesTag(Expression.Literal.MapWire.KEY_VALUES_WIRE, size);
                            v.encodeTo(target);
                        } else {
                            target.appendBytesTag(Expression.Literal.MapWire.KEY_VALUES_WIRE, 0);
                        }
                    }
                }
            }
        };
        
        pub const MapReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _key_values_bufs: ?std.ArrayList([]const u8) = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!MapReader {
                var buf = gremlin.Reader.init(src);
                var res = MapReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Literal.MapWire.KEY_VALUES_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._key_values_bufs == null) {
                                res._key_values_bufs = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._key_values_bufs.?.append(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const MapReader) void {
                if (self._key_values_bufs) |arr| {
                    arr.deinit();
                }
            }
            pub fn getKeyValues(self: *const MapReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.Literal.Map.KeyValueReader {
                if (self._key_values_bufs) |bufs| {
                    var result = try std.ArrayList(Expression.Literal.Map.KeyValueReader).initCapacity(allocator, bufs.items.len);
                    for (bufs.items) |buf| {
                        try result.append(try Expression.Literal.Map.KeyValueReader.init(allocator, buf));
                    }
                    return result.toOwnedSlice();
                }
                return &[_]Expression.Literal.Map.KeyValueReader{};
            }
        };
        
        const IntervalYearToMonthWire = struct {
            const YEARS_WIRE: gremlin.ProtoWireNumber = 1;
            const MONTHS_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const IntervalYearToMonth = struct {
            // fields
            years: i32 = 0,
            months: i32 = 0,

            pub fn calcProtobufSize(self: *const IntervalYearToMonth) usize {
                var res: usize = 0;
                if (self.years != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.IntervalYearToMonthWire.YEARS_WIRE) + gremlin.sizes.sizeI32(self.years); }
                if (self.months != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.IntervalYearToMonthWire.MONTHS_WIRE) + gremlin.sizes.sizeI32(self.months); }
                return res;
            }

            pub fn encode(self: *const IntervalYearToMonth, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const IntervalYearToMonth, target: *gremlin.Writer) void {
                if (self.years != 0) { target.appendInt32(Expression.Literal.IntervalYearToMonthWire.YEARS_WIRE, self.years); }
                if (self.months != 0) { target.appendInt32(Expression.Literal.IntervalYearToMonthWire.MONTHS_WIRE, self.months); }
            }
        };
        
        pub const IntervalYearToMonthReader = struct {
            _years: i32 = 0,
            _months: i32 = 0,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!IntervalYearToMonthReader {
                var buf = gremlin.Reader.init(src);
                var res = IntervalYearToMonthReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Literal.IntervalYearToMonthWire.YEARS_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._years = result.value;
                        },
                        Expression.Literal.IntervalYearToMonthWire.MONTHS_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._months = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const IntervalYearToMonthReader) void { }
            
            pub inline fn getYears(self: *const IntervalYearToMonthReader) i32 { return self._years; }
            pub inline fn getMonths(self: *const IntervalYearToMonthReader) i32 { return self._months; }
        };
        
        const IntervalDayToSecondWire = struct {
            const DAYS_WIRE: gremlin.ProtoWireNumber = 1;
            const SECONDS_WIRE: gremlin.ProtoWireNumber = 2;
            const SUBSECONDS_WIRE: gremlin.ProtoWireNumber = 5;
            const MICROSECONDS_WIRE: gremlin.ProtoWireNumber = 3;
            const PRECISION_WIRE: gremlin.ProtoWireNumber = 4;
        };
        
        pub const IntervalDayToSecond = struct {
            // fields
            days: i32 = 0,
            seconds: i32 = 0,
            subseconds: i64 = 0,
            microseconds: i32 = 0,
            precision: i32 = 0,

            pub fn calcProtobufSize(self: *const IntervalDayToSecond) usize {
                var res: usize = 0;
                if (self.days != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.IntervalDayToSecondWire.DAYS_WIRE) + gremlin.sizes.sizeI32(self.days); }
                if (self.seconds != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.IntervalDayToSecondWire.SECONDS_WIRE) + gremlin.sizes.sizeI32(self.seconds); }
                if (self.subseconds != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.IntervalDayToSecondWire.SUBSECONDS_WIRE) + gremlin.sizes.sizeI64(self.subseconds); }
                if (self.microseconds != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.IntervalDayToSecondWire.MICROSECONDS_WIRE) + gremlin.sizes.sizeI32(self.microseconds); }
                if (self.precision != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.IntervalDayToSecondWire.PRECISION_WIRE) + gremlin.sizes.sizeI32(self.precision); }
                return res;
            }

            pub fn encode(self: *const IntervalDayToSecond, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const IntervalDayToSecond, target: *gremlin.Writer) void {
                if (self.days != 0) { target.appendInt32(Expression.Literal.IntervalDayToSecondWire.DAYS_WIRE, self.days); }
                if (self.seconds != 0) { target.appendInt32(Expression.Literal.IntervalDayToSecondWire.SECONDS_WIRE, self.seconds); }
                if (self.subseconds != 0) { target.appendInt64(Expression.Literal.IntervalDayToSecondWire.SUBSECONDS_WIRE, self.subseconds); }
                if (self.microseconds != 0) { target.appendInt32(Expression.Literal.IntervalDayToSecondWire.MICROSECONDS_WIRE, self.microseconds); }
                if (self.precision != 0) { target.appendInt32(Expression.Literal.IntervalDayToSecondWire.PRECISION_WIRE, self.precision); }
            }
        };
        
        pub const IntervalDayToSecondReader = struct {
            _days: i32 = 0,
            _seconds: i32 = 0,
            _subseconds: i64 = 0,
            _microseconds: i32 = 0,
            _precision: i32 = 0,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!IntervalDayToSecondReader {
                var buf = gremlin.Reader.init(src);
                var res = IntervalDayToSecondReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Literal.IntervalDayToSecondWire.DAYS_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._days = result.value;
                        },
                        Expression.Literal.IntervalDayToSecondWire.SECONDS_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._seconds = result.value;
                        },
                        Expression.Literal.IntervalDayToSecondWire.SUBSECONDS_WIRE => {
                          const result = try buf.readInt64(offset);
                          offset += result.size;
                          res._subseconds = result.value;
                        },
                        Expression.Literal.IntervalDayToSecondWire.MICROSECONDS_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._microseconds = result.value;
                        },
                        Expression.Literal.IntervalDayToSecondWire.PRECISION_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._precision = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const IntervalDayToSecondReader) void { }
            
            pub inline fn getDays(self: *const IntervalDayToSecondReader) i32 { return self._days; }
            pub inline fn getSeconds(self: *const IntervalDayToSecondReader) i32 { return self._seconds; }
            pub inline fn getSubseconds(self: *const IntervalDayToSecondReader) i64 { return self._subseconds; }
            pub inline fn getMicroseconds(self: *const IntervalDayToSecondReader) i32 { return self._microseconds; }
            pub inline fn getPrecision(self: *const IntervalDayToSecondReader) i32 { return self._precision; }
        };
        
        const IntervalCompoundWire = struct {
            const INTERVAL_YEAR_TO_MONTH_WIRE: gremlin.ProtoWireNumber = 1;
            const INTERVAL_DAY_TO_SECOND_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const IntervalCompound = struct {
            // fields
            interval_year_to_month: ?Expression.Literal.IntervalYearToMonth = null,
            interval_day_to_second: ?Expression.Literal.IntervalDayToSecond = null,

            pub fn calcProtobufSize(self: *const IntervalCompound) usize {
                var res: usize = 0;
                if (self.interval_year_to_month) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.Literal.IntervalCompoundWire.INTERVAL_YEAR_TO_MONTH_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.interval_day_to_second) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.Literal.IntervalCompoundWire.INTERVAL_DAY_TO_SECOND_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const IntervalCompound, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const IntervalCompound, target: *gremlin.Writer) void {
                if (self.interval_year_to_month) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.Literal.IntervalCompoundWire.INTERVAL_YEAR_TO_MONTH_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.interval_day_to_second) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.Literal.IntervalCompoundWire.INTERVAL_DAY_TO_SECOND_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const IntervalCompoundReader = struct {
            _interval_year_to_month_buf: ?[]const u8 = null,
            _interval_day_to_second_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!IntervalCompoundReader {
                var buf = gremlin.Reader.init(src);
                var res = IntervalCompoundReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Literal.IntervalCompoundWire.INTERVAL_YEAR_TO_MONTH_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._interval_year_to_month_buf = result.value;
                        },
                        Expression.Literal.IntervalCompoundWire.INTERVAL_DAY_TO_SECOND_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._interval_day_to_second_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const IntervalCompoundReader) void { }
            
            pub fn getIntervalYearToMonth(self: *const IntervalCompoundReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.IntervalYearToMonthReader {
                if (self._interval_year_to_month_buf) |buf| {
                    return try Expression.Literal.IntervalYearToMonthReader.init(allocator, buf);
                }
                return try Expression.Literal.IntervalYearToMonthReader.init(allocator, &[_]u8{});
            }
            pub fn getIntervalDayToSecond(self: *const IntervalCompoundReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.IntervalDayToSecondReader {
                if (self._interval_day_to_second_buf) |buf| {
                    return try Expression.Literal.IntervalDayToSecondReader.init(allocator, buf);
                }
                return try Expression.Literal.IntervalDayToSecondReader.init(allocator, &[_]u8{});
            }
        };
        
        const StructWire = struct {
            const FIELDS_WIRE: gremlin.ProtoWireNumber = 1;
        };
        
        pub const Struct = struct {
            // fields
            fields: ?[]const ?Expression.Literal = null,

            pub fn calcProtobufSize(self: *const Struct) usize {
                var res: usize = 0;
                if (self.fields) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.Literal.StructWire.FIELDS_WIRE);
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            res += gremlin.sizes.sizeUsize(size) + size;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                return res;
            }

            pub fn encode(self: *const Struct, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const Struct, target: *gremlin.Writer) void {
                if (self.fields) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            target.appendBytesTag(Expression.Literal.StructWire.FIELDS_WIRE, size);
                            v.encodeTo(target);
                        } else {
                            target.appendBytesTag(Expression.Literal.StructWire.FIELDS_WIRE, 0);
                        }
                    }
                }
            }
        };
        
        pub const StructReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _fields_bufs: ?std.ArrayList([]const u8) = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!StructReader {
                var buf = gremlin.Reader.init(src);
                var res = StructReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Literal.StructWire.FIELDS_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._fields_bufs == null) {
                                res._fields_bufs = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._fields_bufs.?.append(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const StructReader) void {
                if (self._fields_bufs) |arr| {
                    arr.deinit();
                }
            }
            pub fn getFields(self: *const StructReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.LiteralReader {
                if (self._fields_bufs) |bufs| {
                    var result = try std.ArrayList(Expression.LiteralReader).initCapacity(allocator, bufs.items.len);
                    for (bufs.items) |buf| {
                        try result.append(try Expression.LiteralReader.init(allocator, buf));
                    }
                    return result.toOwnedSlice();
                }
                return &[_]Expression.LiteralReader{};
            }
        };
        
        const ListWire = struct {
            const VALUES_WIRE: gremlin.ProtoWireNumber = 1;
        };
        
        pub const List = struct {
            // fields
            values: ?[]const ?Expression.Literal = null,

            pub fn calcProtobufSize(self: *const List) usize {
                var res: usize = 0;
                if (self.values) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.Literal.ListWire.VALUES_WIRE);
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            res += gremlin.sizes.sizeUsize(size) + size;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                return res;
            }

            pub fn encode(self: *const List, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const List, target: *gremlin.Writer) void {
                if (self.values) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            target.appendBytesTag(Expression.Literal.ListWire.VALUES_WIRE, size);
                            v.encodeTo(target);
                        } else {
                            target.appendBytesTag(Expression.Literal.ListWire.VALUES_WIRE, 0);
                        }
                    }
                }
            }
        };
        
        pub const ListReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _values_bufs: ?std.ArrayList([]const u8) = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ListReader {
                var buf = gremlin.Reader.init(src);
                var res = ListReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Literal.ListWire.VALUES_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._values_bufs == null) {
                                res._values_bufs = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._values_bufs.?.append(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const ListReader) void {
                if (self._values_bufs) |arr| {
                    arr.deinit();
                }
            }
            pub fn getValues(self: *const ListReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.LiteralReader {
                if (self._values_bufs) |bufs| {
                    var result = try std.ArrayList(Expression.LiteralReader).initCapacity(allocator, bufs.items.len);
                    for (bufs.items) |buf| {
                        try result.append(try Expression.LiteralReader.init(allocator, buf));
                    }
                    return result.toOwnedSlice();
                }
                return &[_]Expression.LiteralReader{};
            }
        };
        
        const UserDefinedWire = struct {
            const TYPE_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
            const TYPE_PARAMETERS_WIRE: gremlin.ProtoWireNumber = 3;
            const VALUE_WIRE: gremlin.ProtoWireNumber = 2;
            const STRUCT_WIRE: gremlin.ProtoWireNumber = 4;
        };
        
        pub const UserDefined = struct {
            // fields
            type_reference: u32 = 0,
            type_parameters: ?[]const ?type.Type.Parameter = null,
            value: ?any.Any = null,
            struct_: ?Expression.Literal.Struct = null,

            pub fn calcProtobufSize(self: *const UserDefined) usize {
                var res: usize = 0;
                if (self.type_reference != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Literal.UserDefinedWire.TYPE_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_reference); }
                if (self.type_parameters) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.Literal.UserDefinedWire.TYPE_PARAMETERS_WIRE);
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            res += gremlin.sizes.sizeUsize(size) + size;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                if (self.value) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.Literal.UserDefinedWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.struct_) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.Literal.UserDefinedWire.STRUCT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const UserDefined, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const UserDefined, target: *gremlin.Writer) void {
                if (self.type_reference != 0) { target.appendUint32(Expression.Literal.UserDefinedWire.TYPE_REFERENCE_WIRE, self.type_reference); }
                if (self.type_parameters) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            target.appendBytesTag(Expression.Literal.UserDefinedWire.TYPE_PARAMETERS_WIRE, size);
                            v.encodeTo(target);
                        } else {
                            target.appendBytesTag(Expression.Literal.UserDefinedWire.TYPE_PARAMETERS_WIRE, 0);
                        }
                    }
                }
                if (self.value) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.Literal.UserDefinedWire.VALUE_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.struct_) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.Literal.UserDefinedWire.STRUCT_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const UserDefinedReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _type_reference: u32 = 0,
            _type_parameters_bufs: ?std.ArrayList([]const u8) = null,
            _value_buf: ?[]const u8 = null,
            _struct__buf: ?[]const u8 = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!UserDefinedReader {
                var buf = gremlin.Reader.init(src);
                var res = UserDefinedReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Literal.UserDefinedWire.TYPE_REFERENCE_WIRE => {
                          const result = try buf.readUInt32(offset);
                          offset += result.size;
                          res._type_reference = result.value;
                        },
                        Expression.Literal.UserDefinedWire.TYPE_PARAMETERS_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._type_parameters_bufs == null) {
                                res._type_parameters_bufs = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._type_parameters_bufs.?.append(result.value);
                        },
                        Expression.Literal.UserDefinedWire.VALUE_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._value_buf = result.value;
                        },
                        Expression.Literal.UserDefinedWire.STRUCT_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._struct__buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const UserDefinedReader) void {
                if (self._type_parameters_bufs) |arr| {
                    arr.deinit();
                }
            }
            pub inline fn getTypeReference(self: *const UserDefinedReader) u32 { return self._type_reference; }
            pub fn getTypeParameters(self: *const UserDefinedReader, allocator: std.mem.Allocator) gremlin.Error![]type.Type.ParameterReader {
                if (self._type_parameters_bufs) |bufs| {
                    var result = try std.ArrayList(type.Type.ParameterReader).initCapacity(allocator, bufs.items.len);
                    for (bufs.items) |buf| {
                        try result.append(try type.Type.ParameterReader.init(allocator, buf));
                    }
                    return result.toOwnedSlice();
                }
                return &[_]type.Type.ParameterReader{};
            }
            pub fn getValue(self: *const UserDefinedReader, allocator: std.mem.Allocator) gremlin.Error!any.AnyReader {
                if (self._value_buf) |buf| {
                    return try any.AnyReader.init(allocator, buf);
                }
                return try any.AnyReader.init(allocator, &[_]u8{});
            }
            pub fn getStruct(self: *const UserDefinedReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.StructReader {
                if (self._struct__buf) |buf| {
                    return try Expression.Literal.StructReader.init(allocator, buf);
                }
                return try Expression.Literal.StructReader.init(allocator, &[_]u8{});
            }
        };
        
        // fields
        nullable: bool = false,
        type_variation_reference: u32 = 0,
        boolean: bool = false,
        i8: i32 = 0,
        i16: i32 = 0,
        i32: i32 = 0,
        i64: i64 = 0,
        fp32: f32 = 0.0,
        fp64: f64 = 0.0,
        string: ?[]const u8 = null,
        binary: ?[]const u8 = null,
        timestamp: i64 = 0,
        date: i32 = 0,
        time: i64 = 0,
        interval_year_to_month: ?Expression.Literal.IntervalYearToMonth = null,
        interval_day_to_second: ?Expression.Literal.IntervalDayToSecond = null,
        interval_compound: ?Expression.Literal.IntervalCompound = null,
        fixed_char: ?[]const u8 = null,
        var_char: ?Expression.Literal.VarChar = null,
        fixed_binary: ?[]const u8 = null,
        decimal: ?Expression.Literal.Decimal = null,
        precision_timestamp: ?Expression.Literal.PrecisionTimestamp = null,
        precision_timestamp_tz: ?Expression.Literal.PrecisionTimestamp = null,
        struct_: ?Expression.Literal.Struct = null,
        map: ?Expression.Literal.Map = null,
        timestamp_tz: i64 = 0,
        uuid: ?[]const u8 = null,
        null_: ?type.Type = null,
        list: ?Expression.Literal.List = null,
        empty_list: ?type.Type.List = null,
        empty_map: ?type.Type.Map = null,
        user_defined: ?Expression.Literal.UserDefined = null,

        pub fn calcProtobufSize(self: *const Literal) usize {
            var res: usize = 0;
            if (self.nullable != false) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.NULLABLE_WIRE) + gremlin.sizes.sizeBool(self.nullable); }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (self.boolean != false) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.BOOLEAN_WIRE) + gremlin.sizes.sizeBool(self.boolean); }
            if (self.i8 != 0) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.I8_WIRE) + gremlin.sizes.sizeI32(self.i8); }
            if (self.i16 != 0) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.I16_WIRE) + gremlin.sizes.sizeI32(self.i16); }
            if (self.i32 != 0) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.I32_WIRE) + gremlin.sizes.sizeI32(self.i32); }
            if (self.i64 != 0) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.I64_WIRE) + gremlin.sizes.sizeI64(self.i64); }
            if (self.fp32 != 0.0) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.FP32_WIRE) + gremlin.sizes.sizeFloat(self.fp32); }
            if (self.fp64 != 0.0) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.FP64_WIRE) + gremlin.sizes.sizeDouble(self.fp64); }
            if (self.string) |v| { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.STRING_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.binary) |v| { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.BINARY_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.timestamp != 0) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.TIMESTAMP_WIRE) + gremlin.sizes.sizeI64(self.timestamp); }
            if (self.date != 0) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.DATE_WIRE) + gremlin.sizes.sizeI32(self.date); }
            if (self.time != 0) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.TIME_WIRE) + gremlin.sizes.sizeI64(self.time); }
            if (self.interval_year_to_month) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.INTERVAL_YEAR_TO_MONTH_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.interval_day_to_second) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.INTERVAL_DAY_TO_SECOND_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.interval_compound) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.INTERVAL_COMPOUND_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.fixed_char) |v| { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.FIXED_CHAR_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.var_char) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.VAR_CHAR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.fixed_binary) |v| { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.FIXED_BINARY_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.decimal) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.DECIMAL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.precision_timestamp) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.PRECISION_TIMESTAMP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.precision_timestamp_tz) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.PRECISION_TIMESTAMP_TZ_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.struct_) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.STRUCT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.map) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.MAP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.timestamp_tz != 0) { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.TIMESTAMP_TZ_WIRE) + gremlin.sizes.sizeI64(self.timestamp_tz); }
            if (self.uuid) |v| { res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.UUID_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
            if (self.null_) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.NULL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.list) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.LIST_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.empty_list) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.EMPTY_LIST_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.empty_map) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.EMPTY_MAP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.user_defined) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.LiteralWire.USER_DEFINED_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const Literal, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Literal, target: *gremlin.Writer) void {
            if (self.nullable != false) { target.appendBool(Expression.LiteralWire.NULLABLE_WIRE, self.nullable); }
            if (self.type_variation_reference != 0) { target.appendUint32(Expression.LiteralWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (self.boolean != false) { target.appendBool(Expression.LiteralWire.BOOLEAN_WIRE, self.boolean); }
            if (self.i8 != 0) { target.appendInt32(Expression.LiteralWire.I8_WIRE, self.i8); }
            if (self.i16 != 0) { target.appendInt32(Expression.LiteralWire.I16_WIRE, self.i16); }
            if (self.i32 != 0) { target.appendInt32(Expression.LiteralWire.I32_WIRE, self.i32); }
            if (self.i64 != 0) { target.appendInt64(Expression.LiteralWire.I64_WIRE, self.i64); }
            if (self.fp32 != 0.0) { target.appendFloat32(Expression.LiteralWire.FP32_WIRE, self.fp32); }
            if (self.fp64 != 0.0) { target.appendFloat64(Expression.LiteralWire.FP64_WIRE, self.fp64); }
            if (self.string) |v| { target.appendBytes(Expression.LiteralWire.STRING_WIRE, v); }
            if (self.binary) |v| { target.appendBytes(Expression.LiteralWire.BINARY_WIRE, v); }
            if (self.timestamp != 0) { target.appendInt64(Expression.LiteralWire.TIMESTAMP_WIRE, self.timestamp); }
            if (self.date != 0) { target.appendInt32(Expression.LiteralWire.DATE_WIRE, self.date); }
            if (self.time != 0) { target.appendInt64(Expression.LiteralWire.TIME_WIRE, self.time); }
            if (self.interval_year_to_month) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.INTERVAL_YEAR_TO_MONTH_WIRE, size);
                v.encodeTo(target);
            }
            if (self.interval_day_to_second) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.INTERVAL_DAY_TO_SECOND_WIRE, size);
                v.encodeTo(target);
            }
            if (self.interval_compound) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.INTERVAL_COMPOUND_WIRE, size);
                v.encodeTo(target);
            }
            if (self.fixed_char) |v| { target.appendBytes(Expression.LiteralWire.FIXED_CHAR_WIRE, v); }
            if (self.var_char) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.VAR_CHAR_WIRE, size);
                v.encodeTo(target);
            }
            if (self.fixed_binary) |v| { target.appendBytes(Expression.LiteralWire.FIXED_BINARY_WIRE, v); }
            if (self.decimal) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.DECIMAL_WIRE, size);
                v.encodeTo(target);
            }
            if (self.precision_timestamp) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.PRECISION_TIMESTAMP_WIRE, size);
                v.encodeTo(target);
            }
            if (self.precision_timestamp_tz) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.PRECISION_TIMESTAMP_TZ_WIRE, size);
                v.encodeTo(target);
            }
            if (self.struct_) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.STRUCT_WIRE, size);
                v.encodeTo(target);
            }
            if (self.map) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.MAP_WIRE, size);
                v.encodeTo(target);
            }
            if (self.timestamp_tz != 0) { target.appendInt64(Expression.LiteralWire.TIMESTAMP_TZ_WIRE, self.timestamp_tz); }
            if (self.uuid) |v| { target.appendBytes(Expression.LiteralWire.UUID_WIRE, v); }
            if (self.null_) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.NULL_WIRE, size);
                v.encodeTo(target);
            }
            if (self.list) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.LIST_WIRE, size);
                v.encodeTo(target);
            }
            if (self.empty_list) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.EMPTY_LIST_WIRE, size);
                v.encodeTo(target);
            }
            if (self.empty_map) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.EMPTY_MAP_WIRE, size);
                v.encodeTo(target);
            }
            if (self.user_defined) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.LiteralWire.USER_DEFINED_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const LiteralReader = struct {
        _nullable: bool = false,
        _type_variation_reference: u32 = 0,
        _boolean: bool = false,
        _i8: i32 = 0,
        _i16: i32 = 0,
        _i32: i32 = 0,
        _i64: i64 = 0,
        _fp32: f32 = 0.0,
        _fp64: f64 = 0.0,
        _string: ?[]const u8 = null,
        _binary: ?[]const u8 = null,
        _timestamp: i64 = 0,
        _date: i32 = 0,
        _time: i64 = 0,
        _interval_year_to_month_buf: ?[]const u8 = null,
        _interval_day_to_second_buf: ?[]const u8 = null,
        _interval_compound_buf: ?[]const u8 = null,
        _fixed_char: ?[]const u8 = null,
        _var_char_buf: ?[]const u8 = null,
        _fixed_binary: ?[]const u8 = null,
        _decimal_buf: ?[]const u8 = null,
        _precision_timestamp_buf: ?[]const u8 = null,
        _precision_timestamp_tz_buf: ?[]const u8 = null,
        _struct__buf: ?[]const u8 = null,
        _map_buf: ?[]const u8 = null,
        _timestamp_tz: i64 = 0,
        _uuid: ?[]const u8 = null,
        _null__buf: ?[]const u8 = null,
        _list_buf: ?[]const u8 = null,
        _empty_list_buf: ?[]const u8 = null,
        _empty_map_buf: ?[]const u8 = null,
        _user_defined_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!LiteralReader {
            var buf = gremlin.Reader.init(src);
            var res = LiteralReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.LiteralWire.NULLABLE_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._nullable = result.value;
                    },
                    Expression.LiteralWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Expression.LiteralWire.BOOLEAN_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._boolean = result.value;
                    },
                    Expression.LiteralWire.I8_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._i8 = result.value;
                    },
                    Expression.LiteralWire.I16_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._i16 = result.value;
                    },
                    Expression.LiteralWire.I32_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._i32 = result.value;
                    },
                    Expression.LiteralWire.I64_WIRE => {
                      const result = try buf.readInt64(offset);
                      offset += result.size;
                      res._i64 = result.value;
                    },
                    Expression.LiteralWire.FP32_WIRE => {
                      const result = try buf.readFloat32(offset);
                      offset += result.size;
                      res._fp32 = result.value;
                    },
                    Expression.LiteralWire.FP64_WIRE => {
                      const result = try buf.readFloat64(offset);
                      offset += result.size;
                      res._fp64 = result.value;
                    },
                    Expression.LiteralWire.STRING_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._string = result.value;
                    },
                    Expression.LiteralWire.BINARY_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._binary = result.value;
                    },
                    Expression.LiteralWire.TIMESTAMP_WIRE => {
                      const result = try buf.readInt64(offset);
                      offset += result.size;
                      res._timestamp = result.value;
                    },
                    Expression.LiteralWire.DATE_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._date = result.value;
                    },
                    Expression.LiteralWire.TIME_WIRE => {
                      const result = try buf.readInt64(offset);
                      offset += result.size;
                      res._time = result.value;
                    },
                    Expression.LiteralWire.INTERVAL_YEAR_TO_MONTH_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._interval_year_to_month_buf = result.value;
                    },
                    Expression.LiteralWire.INTERVAL_DAY_TO_SECOND_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._interval_day_to_second_buf = result.value;
                    },
                    Expression.LiteralWire.INTERVAL_COMPOUND_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._interval_compound_buf = result.value;
                    },
                    Expression.LiteralWire.FIXED_CHAR_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._fixed_char = result.value;
                    },
                    Expression.LiteralWire.VAR_CHAR_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._var_char_buf = result.value;
                    },
                    Expression.LiteralWire.FIXED_BINARY_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._fixed_binary = result.value;
                    },
                    Expression.LiteralWire.DECIMAL_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._decimal_buf = result.value;
                    },
                    Expression.LiteralWire.PRECISION_TIMESTAMP_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_timestamp_buf = result.value;
                    },
                    Expression.LiteralWire.PRECISION_TIMESTAMP_TZ_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._precision_timestamp_tz_buf = result.value;
                    },
                    Expression.LiteralWire.STRUCT_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._struct__buf = result.value;
                    },
                    Expression.LiteralWire.MAP_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._map_buf = result.value;
                    },
                    Expression.LiteralWire.TIMESTAMP_TZ_WIRE => {
                      const result = try buf.readInt64(offset);
                      offset += result.size;
                      res._timestamp_tz = result.value;
                    },
                    Expression.LiteralWire.UUID_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._uuid = result.value;
                    },
                    Expression.LiteralWire.NULL_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._null__buf = result.value;
                    },
                    Expression.LiteralWire.LIST_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._list_buf = result.value;
                    },
                    Expression.LiteralWire.EMPTY_LIST_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._empty_list_buf = result.value;
                    },
                    Expression.LiteralWire.EMPTY_MAP_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._empty_map_buf = result.value;
                    },
                    Expression.LiteralWire.USER_DEFINED_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._user_defined_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const LiteralReader) void { }
        
        pub inline fn getNullable(self: *const LiteralReader) bool { return self._nullable; }
        pub inline fn getTypeVariationReference(self: *const LiteralReader) u32 { return self._type_variation_reference; }
        pub inline fn getBoolean(self: *const LiteralReader) bool { return self._boolean; }
        pub inline fn getI8(self: *const LiteralReader) i32 { return self._i8; }
        pub inline fn getI16(self: *const LiteralReader) i32 { return self._i16; }
        pub inline fn getI32(self: *const LiteralReader) i32 { return self._i32; }
        pub inline fn getI64(self: *const LiteralReader) i64 { return self._i64; }
        pub inline fn getFp32(self: *const LiteralReader) f32 { return self._fp32; }
        pub inline fn getFp64(self: *const LiteralReader) f64 { return self._fp64; }
        pub inline fn getString(self: *const LiteralReader) []const u8 { return self._string orelse &[_]u8{}; }
        pub inline fn getBinary(self: *const LiteralReader) []const u8 { return self._binary orelse &[_]u8{}; }
        pub inline fn getTimestamp(self: *const LiteralReader) i64 { return self._timestamp; }
        pub inline fn getDate(self: *const LiteralReader) i32 { return self._date; }
        pub inline fn getTime(self: *const LiteralReader) i64 { return self._time; }
        pub fn getIntervalYearToMonth(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.IntervalYearToMonthReader {
            if (self._interval_year_to_month_buf) |buf| {
                return try Expression.Literal.IntervalYearToMonthReader.init(allocator, buf);
            }
            return try Expression.Literal.IntervalYearToMonthReader.init(allocator, &[_]u8{});
        }
        pub fn getIntervalDayToSecond(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.IntervalDayToSecondReader {
            if (self._interval_day_to_second_buf) |buf| {
                return try Expression.Literal.IntervalDayToSecondReader.init(allocator, buf);
            }
            return try Expression.Literal.IntervalDayToSecondReader.init(allocator, &[_]u8{});
        }
        pub fn getIntervalCompound(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.IntervalCompoundReader {
            if (self._interval_compound_buf) |buf| {
                return try Expression.Literal.IntervalCompoundReader.init(allocator, buf);
            }
            return try Expression.Literal.IntervalCompoundReader.init(allocator, &[_]u8{});
        }
        pub inline fn getFixedChar(self: *const LiteralReader) []const u8 { return self._fixed_char orelse &[_]u8{}; }
        pub fn getVarChar(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.VarCharReader {
            if (self._var_char_buf) |buf| {
                return try Expression.Literal.VarCharReader.init(allocator, buf);
            }
            return try Expression.Literal.VarCharReader.init(allocator, &[_]u8{});
        }
        pub inline fn getFixedBinary(self: *const LiteralReader) []const u8 { return self._fixed_binary orelse &[_]u8{}; }
        pub fn getDecimal(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.DecimalReader {
            if (self._decimal_buf) |buf| {
                return try Expression.Literal.DecimalReader.init(allocator, buf);
            }
            return try Expression.Literal.DecimalReader.init(allocator, &[_]u8{});
        }
        pub fn getPrecisionTimestamp(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.PrecisionTimestampReader {
            if (self._precision_timestamp_buf) |buf| {
                return try Expression.Literal.PrecisionTimestampReader.init(allocator, buf);
            }
            return try Expression.Literal.PrecisionTimestampReader.init(allocator, &[_]u8{});
        }
        pub fn getPrecisionTimestampTz(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.PrecisionTimestampReader {
            if (self._precision_timestamp_tz_buf) |buf| {
                return try Expression.Literal.PrecisionTimestampReader.init(allocator, buf);
            }
            return try Expression.Literal.PrecisionTimestampReader.init(allocator, &[_]u8{});
        }
        pub fn getStruct(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.StructReader {
            if (self._struct__buf) |buf| {
                return try Expression.Literal.StructReader.init(allocator, buf);
            }
            return try Expression.Literal.StructReader.init(allocator, &[_]u8{});
        }
        pub fn getMap(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.MapReader {
            if (self._map_buf) |buf| {
                return try Expression.Literal.MapReader.init(allocator, buf);
            }
            return try Expression.Literal.MapReader.init(allocator, &[_]u8{});
        }
        pub inline fn getTimestampTz(self: *const LiteralReader) i64 { return self._timestamp_tz; }
        pub inline fn getUuid(self: *const LiteralReader) []const u8 { return self._uuid orelse &[_]u8{}; }
        pub fn getNull(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!type.TypeReader {
            if (self._null__buf) |buf| {
                return try type.TypeReader.init(allocator, buf);
            }
            return try type.TypeReader.init(allocator, &[_]u8{});
        }
        pub fn getList(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.ListReader {
            if (self._list_buf) |buf| {
                return try Expression.Literal.ListReader.init(allocator, buf);
            }
            return try Expression.Literal.ListReader.init(allocator, &[_]u8{});
        }
        pub fn getEmptyList(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.ListReader {
            if (self._empty_list_buf) |buf| {
                return try type.Type.ListReader.init(allocator, buf);
            }
            return try type.Type.ListReader.init(allocator, &[_]u8{});
        }
        pub fn getEmptyMap(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!type.Type.MapReader {
            if (self._empty_map_buf) |buf| {
                return try type.Type.MapReader.init(allocator, buf);
            }
            return try type.Type.MapReader.init(allocator, &[_]u8{});
        }
        pub fn getUserDefined(self: *const LiteralReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Literal.UserDefinedReader {
            if (self._user_defined_buf) |buf| {
                return try Expression.Literal.UserDefinedReader.init(allocator, buf);
            }
            return try Expression.Literal.UserDefinedReader.init(allocator, &[_]u8{});
        }
    };
    
    const NestedWire = struct {
        const NULLABLE_WIRE: gremlin.ProtoWireNumber = 1;
        const TYPE_VARIATION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
        const STRUCT_WIRE: gremlin.ProtoWireNumber = 3;
        const LIST_WIRE: gremlin.ProtoWireNumber = 4;
        const MAP_WIRE: gremlin.ProtoWireNumber = 5;
    };
    
    pub const Nested = struct {
        // nested structs
        const MapWire = struct {
            const KEY_VALUES_WIRE: gremlin.ProtoWireNumber = 1;
        };
        
        pub const Map = struct {
            // nested structs
            const KeyValueWire = struct {
                const KEY_WIRE: gremlin.ProtoWireNumber = 1;
                const VALUE_WIRE: gremlin.ProtoWireNumber = 2;
            };
            
            pub const KeyValue = struct {
                // fields
                key: ?Expression = null,
                value: ?Expression = null,

                pub fn calcProtobufSize(self: *const KeyValue) usize {
                    var res: usize = 0;
                    if (self.key) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeWireNumber(Expression.Nested.Map.KeyValueWire.KEY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                    }
                    if (self.value) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeWireNumber(Expression.Nested.Map.KeyValueWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                    }
                    return res;
                }

                pub fn encode(self: *const KeyValue, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(self: *const KeyValue, target: *gremlin.Writer) void {
                    if (self.key) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.Nested.Map.KeyValueWire.KEY_WIRE, size);
                        v.encodeTo(target);
                    }
                    if (self.value) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.Nested.Map.KeyValueWire.VALUE_WIRE, size);
                        v.encodeTo(target);
                    }
                }
            };
            
            pub const KeyValueReader = struct {
                _key_buf: ?[]const u8 = null,
                _value_buf: ?[]const u8 = null,

                pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!KeyValueReader {
                    var buf = gremlin.Reader.init(src);
                    var res = KeyValueReader{};
                    if (buf.buf.len == 0) {
                        return res;
                    }
                    var offset: usize = 0;
                    while (buf.hasNext(offset, 0)) {
                        const tag = try buf.readTagAt(offset);
                        offset += tag.size;
                        switch (tag.number) {
                            Expression.Nested.Map.KeyValueWire.KEY_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._key_buf = result.value;
                            },
                            Expression.Nested.Map.KeyValueWire.VALUE_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._value_buf = result.value;
                            },
                            else => {
                                offset = try buf.skipData(offset, tag.wire);
                            }
                        }
                    }
                    return res;
                }
                pub fn deinit(_: *const KeyValueReader) void { }
                
                pub fn getKey(self: *const KeyValueReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
                    if (self._key_buf) |buf| {
                        return try ExpressionReader.init(allocator, buf);
                    }
                    return try ExpressionReader.init(allocator, &[_]u8{});
                }
                pub fn getValue(self: *const KeyValueReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
                    if (self._value_buf) |buf| {
                        return try ExpressionReader.init(allocator, buf);
                    }
                    return try ExpressionReader.init(allocator, &[_]u8{});
                }
            };
            
            // fields
            key_values: ?[]const ?Expression.Nested.Map.KeyValue = null,

            pub fn calcProtobufSize(self: *const Map) usize {
                var res: usize = 0;
                if (self.key_values) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.Nested.MapWire.KEY_VALUES_WIRE);
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            res += gremlin.sizes.sizeUsize(size) + size;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                return res;
            }

            pub fn encode(self: *const Map, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const Map, target: *gremlin.Writer) void {
                if (self.key_values) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            target.appendBytesTag(Expression.Nested.MapWire.KEY_VALUES_WIRE, size);
                            v.encodeTo(target);
                        } else {
                            target.appendBytesTag(Expression.Nested.MapWire.KEY_VALUES_WIRE, 0);
                        }
                    }
                }
            }
        };
        
        pub const MapReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _key_values_bufs: ?std.ArrayList([]const u8) = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!MapReader {
                var buf = gremlin.Reader.init(src);
                var res = MapReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Nested.MapWire.KEY_VALUES_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._key_values_bufs == null) {
                                res._key_values_bufs = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._key_values_bufs.?.append(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const MapReader) void {
                if (self._key_values_bufs) |arr| {
                    arr.deinit();
                }
            }
            pub fn getKeyValues(self: *const MapReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.Nested.Map.KeyValueReader {
                if (self._key_values_bufs) |bufs| {
                    var result = try std.ArrayList(Expression.Nested.Map.KeyValueReader).initCapacity(allocator, bufs.items.len);
                    for (bufs.items) |buf| {
                        try result.append(try Expression.Nested.Map.KeyValueReader.init(allocator, buf));
                    }
                    return result.toOwnedSlice();
                }
                return &[_]Expression.Nested.Map.KeyValueReader{};
            }
        };
        
        const StructWire = struct {
            const FIELDS_WIRE: gremlin.ProtoWireNumber = 1;
        };
        
        pub const Struct = struct {
            // fields
            fields: ?[]const ?Expression = null,

            pub fn calcProtobufSize(self: *const Struct) usize {
                var res: usize = 0;
                if (self.fields) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.Nested.StructWire.FIELDS_WIRE);
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            res += gremlin.sizes.sizeUsize(size) + size;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                return res;
            }

            pub fn encode(self: *const Struct, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const Struct, target: *gremlin.Writer) void {
                if (self.fields) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            target.appendBytesTag(Expression.Nested.StructWire.FIELDS_WIRE, size);
                            v.encodeTo(target);
                        } else {
                            target.appendBytesTag(Expression.Nested.StructWire.FIELDS_WIRE, 0);
                        }
                    }
                }
            }
        };
        
        pub const StructReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _fields_bufs: ?std.ArrayList([]const u8) = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!StructReader {
                var buf = gremlin.Reader.init(src);
                var res = StructReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Nested.StructWire.FIELDS_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._fields_bufs == null) {
                                res._fields_bufs = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._fields_bufs.?.append(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const StructReader) void {
                if (self._fields_bufs) |arr| {
                    arr.deinit();
                }
            }
            pub fn getFields(self: *const StructReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
                if (self._fields_bufs) |bufs| {
                    var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                    for (bufs.items) |buf| {
                        try result.append(try ExpressionReader.init(allocator, buf));
                    }
                    return result.toOwnedSlice();
                }
                return &[_]ExpressionReader{};
            }
        };
        
        const ListWire = struct {
            const VALUES_WIRE: gremlin.ProtoWireNumber = 1;
        };
        
        pub const List = struct {
            // fields
            values: ?[]const ?Expression = null,

            pub fn calcProtobufSize(self: *const List) usize {
                var res: usize = 0;
                if (self.values) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.Nested.ListWire.VALUES_WIRE);
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            res += gremlin.sizes.sizeUsize(size) + size;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                return res;
            }

            pub fn encode(self: *const List, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const List, target: *gremlin.Writer) void {
                if (self.values) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            target.appendBytesTag(Expression.Nested.ListWire.VALUES_WIRE, size);
                            v.encodeTo(target);
                        } else {
                            target.appendBytesTag(Expression.Nested.ListWire.VALUES_WIRE, 0);
                        }
                    }
                }
            }
        };
        
        pub const ListReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _values_bufs: ?std.ArrayList([]const u8) = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ListReader {
                var buf = gremlin.Reader.init(src);
                var res = ListReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Nested.ListWire.VALUES_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._values_bufs == null) {
                                res._values_bufs = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._values_bufs.?.append(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const ListReader) void {
                if (self._values_bufs) |arr| {
                    arr.deinit();
                }
            }
            pub fn getValues(self: *const ListReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
                if (self._values_bufs) |bufs| {
                    var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                    for (bufs.items) |buf| {
                        try result.append(try ExpressionReader.init(allocator, buf));
                    }
                    return result.toOwnedSlice();
                }
                return &[_]ExpressionReader{};
            }
        };
        
        // fields
        nullable: bool = false,
        type_variation_reference: u32 = 0,
        struct_: ?Expression.Nested.Struct = null,
        list: ?Expression.Nested.List = null,
        map: ?Expression.Nested.Map = null,

        pub fn calcProtobufSize(self: *const Nested) usize {
            var res: usize = 0;
            if (self.nullable != false) { res += gremlin.sizes.sizeWireNumber(Expression.NestedWire.NULLABLE_WIRE) + gremlin.sizes.sizeBool(self.nullable); }
            if (self.type_variation_reference != 0) { res += gremlin.sizes.sizeWireNumber(Expression.NestedWire.TYPE_VARIATION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.type_variation_reference); }
            if (self.struct_) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.NestedWire.STRUCT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.list) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.NestedWire.LIST_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.map) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.NestedWire.MAP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const Nested, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Nested, target: *gremlin.Writer) void {
            if (self.nullable != false) { target.appendBool(Expression.NestedWire.NULLABLE_WIRE, self.nullable); }
            if (self.type_variation_reference != 0) { target.appendUint32(Expression.NestedWire.TYPE_VARIATION_REFERENCE_WIRE, self.type_variation_reference); }
            if (self.struct_) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.NestedWire.STRUCT_WIRE, size);
                v.encodeTo(target);
            }
            if (self.list) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.NestedWire.LIST_WIRE, size);
                v.encodeTo(target);
            }
            if (self.map) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.NestedWire.MAP_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const NestedReader = struct {
        _nullable: bool = false,
        _type_variation_reference: u32 = 0,
        _struct__buf: ?[]const u8 = null,
        _list_buf: ?[]const u8 = null,
        _map_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!NestedReader {
            var buf = gremlin.Reader.init(src);
            var res = NestedReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.NestedWire.NULLABLE_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._nullable = result.value;
                    },
                    Expression.NestedWire.TYPE_VARIATION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._type_variation_reference = result.value;
                    },
                    Expression.NestedWire.STRUCT_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._struct__buf = result.value;
                    },
                    Expression.NestedWire.LIST_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._list_buf = result.value;
                    },
                    Expression.NestedWire.MAP_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._map_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const NestedReader) void { }
        
        pub inline fn getNullable(self: *const NestedReader) bool { return self._nullable; }
        pub inline fn getTypeVariationReference(self: *const NestedReader) u32 { return self._type_variation_reference; }
        pub fn getStruct(self: *const NestedReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Nested.StructReader {
            if (self._struct__buf) |buf| {
                return try Expression.Nested.StructReader.init(allocator, buf);
            }
            return try Expression.Nested.StructReader.init(allocator, &[_]u8{});
        }
        pub fn getList(self: *const NestedReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Nested.ListReader {
            if (self._list_buf) |buf| {
                return try Expression.Nested.ListReader.init(allocator, buf);
            }
            return try Expression.Nested.ListReader.init(allocator, &[_]u8{});
        }
        pub fn getMap(self: *const NestedReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Nested.MapReader {
            if (self._map_buf) |buf| {
                return try Expression.Nested.MapReader.init(allocator, buf);
            }
            return try Expression.Nested.MapReader.init(allocator, &[_]u8{});
        }
    };
    
    const ScalarFunctionWire = struct {
        const FUNCTION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const ARGUMENTS_WIRE: gremlin.ProtoWireNumber = 4;
        const OPTIONS_WIRE: gremlin.ProtoWireNumber = 5;
        const OUTPUT_TYPE_WIRE: gremlin.ProtoWireNumber = 3;
        const ARGS_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const ScalarFunction = struct {
        // fields
        function_reference: u32 = 0,
        arguments: ?[]const ?FunctionArgument = null,
        options: ?[]const ?FunctionOption = null,
        output_type: ?type.Type = null,
        args: ?[]const ?Expression = null,

        pub fn calcProtobufSize(self: *const ScalarFunction) usize {
            var res: usize = 0;
            if (self.function_reference != 0) { res += gremlin.sizes.sizeWireNumber(Expression.ScalarFunctionWire.FUNCTION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.function_reference); }
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.ScalarFunctionWire.ARGUMENTS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.options) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.ScalarFunctionWire.OPTIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.ScalarFunctionWire.OUTPUT_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.args) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.ScalarFunctionWire.ARGS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            return res;
        }

        pub fn encode(self: *const ScalarFunction, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ScalarFunction, target: *gremlin.Writer) void {
            if (self.function_reference != 0) { target.appendUint32(Expression.ScalarFunctionWire.FUNCTION_REFERENCE_WIRE, self.function_reference); }
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.ScalarFunctionWire.ARGUMENTS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.ScalarFunctionWire.ARGUMENTS_WIRE, 0);
                    }
                }
            }
            if (self.options) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.ScalarFunctionWire.OPTIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.ScalarFunctionWire.OPTIONS_WIRE, 0);
                    }
                }
            }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.ScalarFunctionWire.OUTPUT_TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.args) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.ScalarFunctionWire.ARGS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.ScalarFunctionWire.ARGS_WIRE, 0);
                    }
                }
            }
        }
    };
    
    pub const ScalarFunctionReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _function_reference: u32 = 0,
        _arguments_bufs: ?std.ArrayList([]const u8) = null,
        _options_bufs: ?std.ArrayList([]const u8) = null,
        _output_type_buf: ?[]const u8 = null,
        _args_bufs: ?std.ArrayList([]const u8) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ScalarFunctionReader {
            var buf = gremlin.Reader.init(src);
            var res = ScalarFunctionReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.ScalarFunctionWire.FUNCTION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._function_reference = result.value;
                    },
                    Expression.ScalarFunctionWire.ARGUMENTS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._arguments_bufs == null) {
                            res._arguments_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._arguments_bufs.?.append(result.value);
                    },
                    Expression.ScalarFunctionWire.OPTIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._options_bufs == null) {
                            res._options_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._options_bufs.?.append(result.value);
                    },
                    Expression.ScalarFunctionWire.OUTPUT_TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._output_type_buf = result.value;
                    },
                    Expression.ScalarFunctionWire.ARGS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._args_bufs == null) {
                            res._args_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._args_bufs.?.append(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const ScalarFunctionReader) void {
            if (self._arguments_bufs) |arr| {
                arr.deinit();
            }
            if (self._options_bufs) |arr| {
                arr.deinit();
            }
            if (self._args_bufs) |arr| {
                arr.deinit();
            }
        }
        pub inline fn getFunctionReference(self: *const ScalarFunctionReader) u32 { return self._function_reference; }
        pub fn getArguments(self: *const ScalarFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionArgumentReader {
            if (self._arguments_bufs) |bufs| {
                var result = try std.ArrayList(FunctionArgumentReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionArgumentReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionArgumentReader{};
        }
        pub fn getOptions(self: *const ScalarFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionOptionReader {
            if (self._options_bufs) |bufs| {
                var result = try std.ArrayList(FunctionOptionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionOptionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionOptionReader{};
        }
        pub fn getOutputType(self: *const ScalarFunctionReader, allocator: std.mem.Allocator) gremlin.Error!type.TypeReader {
            if (self._output_type_buf) |buf| {
                return try type.TypeReader.init(allocator, buf);
            }
            return try type.TypeReader.init(allocator, &[_]u8{});
        }
        pub fn getArgs(self: *const ScalarFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
            if (self._args_bufs) |bufs| {
                var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try ExpressionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]ExpressionReader{};
        }
    };
    
    const WindowFunctionWire = struct {
        const FUNCTION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const ARGUMENTS_WIRE: gremlin.ProtoWireNumber = 9;
        const OPTIONS_WIRE: gremlin.ProtoWireNumber = 11;
        const OUTPUT_TYPE_WIRE: gremlin.ProtoWireNumber = 7;
        const PHASE_WIRE: gremlin.ProtoWireNumber = 6;
        const SORTS_WIRE: gremlin.ProtoWireNumber = 3;
        const INVOCATION_WIRE: gremlin.ProtoWireNumber = 10;
        const PARTITIONS_WIRE: gremlin.ProtoWireNumber = 2;
        const BOUNDS_TYPE_WIRE: gremlin.ProtoWireNumber = 12;
        const LOWER_BOUND_WIRE: gremlin.ProtoWireNumber = 5;
        const UPPER_BOUND_WIRE: gremlin.ProtoWireNumber = 4;
        const ARGS_WIRE: gremlin.ProtoWireNumber = 8;
    };
    
    pub const WindowFunction = struct {
        // nested enums
        pub const BoundsType = enum(i32) {
            BOUNDS_TYPE_UNSPECIFIED = 0,
            BOUNDS_TYPE_ROWS = 1,
            BOUNDS_TYPE_RANGE = 2,
        };
        
        // nested structs
        const BoundWire = struct {
            const PRECEDING_WIRE: gremlin.ProtoWireNumber = 1;
            const FOLLOWING_WIRE: gremlin.ProtoWireNumber = 2;
            const CURRENT_ROW_WIRE: gremlin.ProtoWireNumber = 3;
            const UNBOUNDED_WIRE: gremlin.ProtoWireNumber = 4;
        };
        
        pub const Bound = struct {
            // nested structs
            const PrecedingWire = struct {
                const OFFSET_WIRE: gremlin.ProtoWireNumber = 1;
            };
            
            pub const Preceding = struct {
                // fields
                offset: i64 = 0,

                pub fn calcProtobufSize(self: *const Preceding) usize {
                    var res: usize = 0;
                    if (self.offset != 0) { res += gremlin.sizes.sizeWireNumber(Expression.WindowFunction.Bound.PrecedingWire.OFFSET_WIRE) + gremlin.sizes.sizeI64(self.offset); }
                    return res;
                }

                pub fn encode(self: *const Preceding, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(self: *const Preceding, target: *gremlin.Writer) void {
                    if (self.offset != 0) { target.appendInt64(Expression.WindowFunction.Bound.PrecedingWire.OFFSET_WIRE, self.offset); }
                }
            };
            
            pub const PrecedingReader = struct {
                _offset: i64 = 0,

                pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!PrecedingReader {
                    var buf = gremlin.Reader.init(src);
                    var res = PrecedingReader{};
                    if (buf.buf.len == 0) {
                        return res;
                    }
                    var offset: usize = 0;
                    while (buf.hasNext(offset, 0)) {
                        const tag = try buf.readTagAt(offset);
                        offset += tag.size;
                        switch (tag.number) {
                            Expression.WindowFunction.Bound.PrecedingWire.OFFSET_WIRE => {
                              const result = try buf.readInt64(offset);
                              offset += result.size;
                              res._offset = result.value;
                            },
                            else => {
                                offset = try buf.skipData(offset, tag.wire);
                            }
                        }
                    }
                    return res;
                }
                pub fn deinit(_: *const PrecedingReader) void { }
                
                pub inline fn getOffset(self: *const PrecedingReader) i64 { return self._offset; }
            };
            
            const FollowingWire = struct {
                const OFFSET_WIRE: gremlin.ProtoWireNumber = 1;
            };
            
            pub const Following = struct {
                // fields
                offset: i64 = 0,

                pub fn calcProtobufSize(self: *const Following) usize {
                    var res: usize = 0;
                    if (self.offset != 0) { res += gremlin.sizes.sizeWireNumber(Expression.WindowFunction.Bound.FollowingWire.OFFSET_WIRE) + gremlin.sizes.sizeI64(self.offset); }
                    return res;
                }

                pub fn encode(self: *const Following, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(self: *const Following, target: *gremlin.Writer) void {
                    if (self.offset != 0) { target.appendInt64(Expression.WindowFunction.Bound.FollowingWire.OFFSET_WIRE, self.offset); }
                }
            };
            
            pub const FollowingReader = struct {
                _offset: i64 = 0,

                pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!FollowingReader {
                    var buf = gremlin.Reader.init(src);
                    var res = FollowingReader{};
                    if (buf.buf.len == 0) {
                        return res;
                    }
                    var offset: usize = 0;
                    while (buf.hasNext(offset, 0)) {
                        const tag = try buf.readTagAt(offset);
                        offset += tag.size;
                        switch (tag.number) {
                            Expression.WindowFunction.Bound.FollowingWire.OFFSET_WIRE => {
                              const result = try buf.readInt64(offset);
                              offset += result.size;
                              res._offset = result.value;
                            },
                            else => {
                                offset = try buf.skipData(offset, tag.wire);
                            }
                        }
                    }
                    return res;
                }
                pub fn deinit(_: *const FollowingReader) void { }
                
                pub inline fn getOffset(self: *const FollowingReader) i64 { return self._offset; }
            };
            
            pub const CurrentRow = struct {

                pub fn calcProtobufSize(_: *const CurrentRow) usize { return 0; }
                

                pub fn encode(self: *const CurrentRow, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(_: *const CurrentRow, _: *gremlin.Writer) void {}
                
            };
            
            pub const CurrentRowReader = struct {

                pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!CurrentRowReader {
                    return CurrentRowReader{};
                }
                pub fn deinit(_: *const CurrentRowReader) void { }
                
            };
            
            pub const Unbounded = struct {

                pub fn calcProtobufSize(_: *const Unbounded) usize { return 0; }
                

                pub fn encode(self: *const Unbounded, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(_: *const Unbounded, _: *gremlin.Writer) void {}
                
            };
            
            pub const UnboundedReader = struct {

                pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!UnboundedReader {
                    return UnboundedReader{};
                }
                pub fn deinit(_: *const UnboundedReader) void { }
                
            };
            
            // fields
            preceding: ?Expression.WindowFunction.Bound.Preceding = null,
            following: ?Expression.WindowFunction.Bound.Following = null,
            current_row: ?Expression.WindowFunction.Bound.CurrentRow = null,
            unbounded: ?Expression.WindowFunction.Bound.Unbounded = null,

            pub fn calcProtobufSize(self: *const Bound) usize {
                var res: usize = 0;
                if (self.preceding) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.WindowFunction.BoundWire.PRECEDING_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.following) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.WindowFunction.BoundWire.FOLLOWING_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.current_row) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.WindowFunction.BoundWire.CURRENT_ROW_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.unbounded) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.WindowFunction.BoundWire.UNBOUNDED_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const Bound, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const Bound, target: *gremlin.Writer) void {
                if (self.preceding) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.WindowFunction.BoundWire.PRECEDING_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.following) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.WindowFunction.BoundWire.FOLLOWING_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.current_row) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.WindowFunction.BoundWire.CURRENT_ROW_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.unbounded) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.WindowFunction.BoundWire.UNBOUNDED_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const BoundReader = struct {
            _preceding_buf: ?[]const u8 = null,
            _following_buf: ?[]const u8 = null,
            _current_row_buf: ?[]const u8 = null,
            _unbounded_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!BoundReader {
                var buf = gremlin.Reader.init(src);
                var res = BoundReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.WindowFunction.BoundWire.PRECEDING_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._preceding_buf = result.value;
                        },
                        Expression.WindowFunction.BoundWire.FOLLOWING_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._following_buf = result.value;
                        },
                        Expression.WindowFunction.BoundWire.CURRENT_ROW_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._current_row_buf = result.value;
                        },
                        Expression.WindowFunction.BoundWire.UNBOUNDED_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._unbounded_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const BoundReader) void { }
            
            pub fn getPreceding(self: *const BoundReader, allocator: std.mem.Allocator) gremlin.Error!Expression.WindowFunction.Bound.PrecedingReader {
                if (self._preceding_buf) |buf| {
                    return try Expression.WindowFunction.Bound.PrecedingReader.init(allocator, buf);
                }
                return try Expression.WindowFunction.Bound.PrecedingReader.init(allocator, &[_]u8{});
            }
            pub fn getFollowing(self: *const BoundReader, allocator: std.mem.Allocator) gremlin.Error!Expression.WindowFunction.Bound.FollowingReader {
                if (self._following_buf) |buf| {
                    return try Expression.WindowFunction.Bound.FollowingReader.init(allocator, buf);
                }
                return try Expression.WindowFunction.Bound.FollowingReader.init(allocator, &[_]u8{});
            }
            pub fn getCurrentRow(self: *const BoundReader, allocator: std.mem.Allocator) gremlin.Error!Expression.WindowFunction.Bound.CurrentRowReader {
                if (self._current_row_buf) |buf| {
                    return try Expression.WindowFunction.Bound.CurrentRowReader.init(allocator, buf);
                }
                return try Expression.WindowFunction.Bound.CurrentRowReader.init(allocator, &[_]u8{});
            }
            pub fn getUnbounded(self: *const BoundReader, allocator: std.mem.Allocator) gremlin.Error!Expression.WindowFunction.Bound.UnboundedReader {
                if (self._unbounded_buf) |buf| {
                    return try Expression.WindowFunction.Bound.UnboundedReader.init(allocator, buf);
                }
                return try Expression.WindowFunction.Bound.UnboundedReader.init(allocator, &[_]u8{});
            }
        };
        
        // fields
        function_reference: u32 = 0,
        arguments: ?[]const ?FunctionArgument = null,
        options: ?[]const ?FunctionOption = null,
        output_type: ?type.Type = null,
        phase: AggregationPhase = @enumFromInt(0),
        sorts: ?[]const ?SortField = null,
        invocation: AggregateFunction.AggregationInvocation = @enumFromInt(0),
        partitions: ?[]const ?Expression = null,
        bounds_type: Expression.WindowFunction.BoundsType = @enumFromInt(0),
        lower_bound: ?Expression.WindowFunction.Bound = null,
        upper_bound: ?Expression.WindowFunction.Bound = null,
        args: ?[]const ?Expression = null,

        pub fn calcProtobufSize(self: *const WindowFunction) usize {
            var res: usize = 0;
            if (self.function_reference != 0) { res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.FUNCTION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.function_reference); }
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.ARGUMENTS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.options) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.OPTIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.OUTPUT_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (@intFromEnum(self.phase) != 0) { res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.PHASE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.phase)); }
            if (self.sorts) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.SORTS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (@intFromEnum(self.invocation) != 0) { res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.INVOCATION_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.invocation)); }
            if (self.partitions) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.PARTITIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (@intFromEnum(self.bounds_type) != 0) { res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.BOUNDS_TYPE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.bounds_type)); }
            if (self.lower_bound) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.LOWER_BOUND_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.upper_bound) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.UPPER_BOUND_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.args) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.WindowFunctionWire.ARGS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            return res;
        }

        pub fn encode(self: *const WindowFunction, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const WindowFunction, target: *gremlin.Writer) void {
            if (self.function_reference != 0) { target.appendUint32(Expression.WindowFunctionWire.FUNCTION_REFERENCE_WIRE, self.function_reference); }
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.WindowFunctionWire.ARGUMENTS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.WindowFunctionWire.ARGUMENTS_WIRE, 0);
                    }
                }
            }
            if (self.options) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.WindowFunctionWire.OPTIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.WindowFunctionWire.OPTIONS_WIRE, 0);
                    }
                }
            }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.WindowFunctionWire.OUTPUT_TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (@intFromEnum(self.phase) != 0) { target.appendInt32(Expression.WindowFunctionWire.PHASE_WIRE, @intFromEnum(self.phase)); }
            if (self.sorts) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.WindowFunctionWire.SORTS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.WindowFunctionWire.SORTS_WIRE, 0);
                    }
                }
            }
            if (@intFromEnum(self.invocation) != 0) { target.appendInt32(Expression.WindowFunctionWire.INVOCATION_WIRE, @intFromEnum(self.invocation)); }
            if (self.partitions) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.WindowFunctionWire.PARTITIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.WindowFunctionWire.PARTITIONS_WIRE, 0);
                    }
                }
            }
            if (@intFromEnum(self.bounds_type) != 0) { target.appendInt32(Expression.WindowFunctionWire.BOUNDS_TYPE_WIRE, @intFromEnum(self.bounds_type)); }
            if (self.lower_bound) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.WindowFunctionWire.LOWER_BOUND_WIRE, size);
                v.encodeTo(target);
            }
            if (self.upper_bound) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.WindowFunctionWire.UPPER_BOUND_WIRE, size);
                v.encodeTo(target);
            }
            if (self.args) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.WindowFunctionWire.ARGS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.WindowFunctionWire.ARGS_WIRE, 0);
                    }
                }
            }
        }
    };
    
    pub const WindowFunctionReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _function_reference: u32 = 0,
        _arguments_bufs: ?std.ArrayList([]const u8) = null,
        _options_bufs: ?std.ArrayList([]const u8) = null,
        _output_type_buf: ?[]const u8 = null,
        _phase: AggregationPhase = @enumFromInt(0),
        _sorts_bufs: ?std.ArrayList([]const u8) = null,
        _invocation: AggregateFunction.AggregationInvocation = @enumFromInt(0),
        _partitions_bufs: ?std.ArrayList([]const u8) = null,
        _bounds_type: Expression.WindowFunction.BoundsType = @enumFromInt(0),
        _lower_bound_buf: ?[]const u8 = null,
        _upper_bound_buf: ?[]const u8 = null,
        _args_bufs: ?std.ArrayList([]const u8) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!WindowFunctionReader {
            var buf = gremlin.Reader.init(src);
            var res = WindowFunctionReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.WindowFunctionWire.FUNCTION_REFERENCE_WIRE => {
                      const result = try buf.readUInt32(offset);
                      offset += result.size;
                      res._function_reference = result.value;
                    },
                    Expression.WindowFunctionWire.ARGUMENTS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._arguments_bufs == null) {
                            res._arguments_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._arguments_bufs.?.append(result.value);
                    },
                    Expression.WindowFunctionWire.OPTIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._options_bufs == null) {
                            res._options_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._options_bufs.?.append(result.value);
                    },
                    Expression.WindowFunctionWire.OUTPUT_TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._output_type_buf = result.value;
                    },
                    Expression.WindowFunctionWire.PHASE_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._phase = @enumFromInt(result.value);
                    },
                    Expression.WindowFunctionWire.SORTS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._sorts_bufs == null) {
                            res._sorts_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._sorts_bufs.?.append(result.value);
                    },
                    Expression.WindowFunctionWire.INVOCATION_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._invocation = @enumFromInt(result.value);
                    },
                    Expression.WindowFunctionWire.PARTITIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._partitions_bufs == null) {
                            res._partitions_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._partitions_bufs.?.append(result.value);
                    },
                    Expression.WindowFunctionWire.BOUNDS_TYPE_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._bounds_type = @enumFromInt(result.value);
                    },
                    Expression.WindowFunctionWire.LOWER_BOUND_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._lower_bound_buf = result.value;
                    },
                    Expression.WindowFunctionWire.UPPER_BOUND_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._upper_bound_buf = result.value;
                    },
                    Expression.WindowFunctionWire.ARGS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._args_bufs == null) {
                            res._args_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._args_bufs.?.append(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const WindowFunctionReader) void {
            if (self._arguments_bufs) |arr| {
                arr.deinit();
            }
            if (self._options_bufs) |arr| {
                arr.deinit();
            }
            if (self._sorts_bufs) |arr| {
                arr.deinit();
            }
            if (self._partitions_bufs) |arr| {
                arr.deinit();
            }
            if (self._args_bufs) |arr| {
                arr.deinit();
            }
        }
        pub inline fn getFunctionReference(self: *const WindowFunctionReader) u32 { return self._function_reference; }
        pub fn getArguments(self: *const WindowFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionArgumentReader {
            if (self._arguments_bufs) |bufs| {
                var result = try std.ArrayList(FunctionArgumentReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionArgumentReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionArgumentReader{};
        }
        pub fn getOptions(self: *const WindowFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionOptionReader {
            if (self._options_bufs) |bufs| {
                var result = try std.ArrayList(FunctionOptionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try FunctionOptionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]FunctionOptionReader{};
        }
        pub fn getOutputType(self: *const WindowFunctionReader, allocator: std.mem.Allocator) gremlin.Error!type.TypeReader {
            if (self._output_type_buf) |buf| {
                return try type.TypeReader.init(allocator, buf);
            }
            return try type.TypeReader.init(allocator, &[_]u8{});
        }
        pub inline fn getPhase(self: *const WindowFunctionReader) AggregationPhase { return self._phase; }
        pub fn getSorts(self: *const WindowFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]SortFieldReader {
            if (self._sorts_bufs) |bufs| {
                var result = try std.ArrayList(SortFieldReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try SortFieldReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]SortFieldReader{};
        }
        pub inline fn getInvocation(self: *const WindowFunctionReader) AggregateFunction.AggregationInvocation { return self._invocation; }
        pub fn getPartitions(self: *const WindowFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
            if (self._partitions_bufs) |bufs| {
                var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try ExpressionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]ExpressionReader{};
        }
        pub inline fn getBoundsType(self: *const WindowFunctionReader) Expression.WindowFunction.BoundsType { return self._bounds_type; }
        pub fn getLowerBound(self: *const WindowFunctionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.WindowFunction.BoundReader {
            if (self._lower_bound_buf) |buf| {
                return try Expression.WindowFunction.BoundReader.init(allocator, buf);
            }
            return try Expression.WindowFunction.BoundReader.init(allocator, &[_]u8{});
        }
        pub fn getUpperBound(self: *const WindowFunctionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.WindowFunction.BoundReader {
            if (self._upper_bound_buf) |buf| {
                return try Expression.WindowFunction.BoundReader.init(allocator, buf);
            }
            return try Expression.WindowFunction.BoundReader.init(allocator, &[_]u8{});
        }
        pub fn getArgs(self: *const WindowFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
            if (self._args_bufs) |bufs| {
                var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try ExpressionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]ExpressionReader{};
        }
    };
    
    const IfThenWire = struct {
        const IFS_WIRE: gremlin.ProtoWireNumber = 1;
        const ELSE_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const IfThen = struct {
        // nested structs
        const IfClauseWire = struct {
            const IF_WIRE: gremlin.ProtoWireNumber = 1;
            const THEN_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const IfClause = struct {
            // fields
            if_: ?Expression = null,
            then: ?Expression = null,

            pub fn calcProtobufSize(self: *const IfClause) usize {
                var res: usize = 0;
                if (self.if_) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.IfThen.IfClauseWire.IF_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.then) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.IfThen.IfClauseWire.THEN_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const IfClause, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const IfClause, target: *gremlin.Writer) void {
                if (self.if_) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.IfThen.IfClauseWire.IF_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.then) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.IfThen.IfClauseWire.THEN_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const IfClauseReader = struct {
            _if__buf: ?[]const u8 = null,
            _then_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!IfClauseReader {
                var buf = gremlin.Reader.init(src);
                var res = IfClauseReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.IfThen.IfClauseWire.IF_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._if__buf = result.value;
                        },
                        Expression.IfThen.IfClauseWire.THEN_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._then_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const IfClauseReader) void { }
            
            pub fn getIf(self: *const IfClauseReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
                if (self._if__buf) |buf| {
                    return try ExpressionReader.init(allocator, buf);
                }
                return try ExpressionReader.init(allocator, &[_]u8{});
            }
            pub fn getThen(self: *const IfClauseReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
                if (self._then_buf) |buf| {
                    return try ExpressionReader.init(allocator, buf);
                }
                return try ExpressionReader.init(allocator, &[_]u8{});
            }
        };
        
        // fields
        ifs: ?[]const ?Expression.IfThen.IfClause = null,
        else_: ?Expression = null,

        pub fn calcProtobufSize(self: *const IfThen) usize {
            var res: usize = 0;
            if (self.ifs) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.IfThenWire.IFS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.else_) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.IfThenWire.ELSE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const IfThen, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const IfThen, target: *gremlin.Writer) void {
            if (self.ifs) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.IfThenWire.IFS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.IfThenWire.IFS_WIRE, 0);
                    }
                }
            }
            if (self.else_) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.IfThenWire.ELSE_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const IfThenReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _ifs_bufs: ?std.ArrayList([]const u8) = null,
        _else__buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!IfThenReader {
            var buf = gremlin.Reader.init(src);
            var res = IfThenReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.IfThenWire.IFS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._ifs_bufs == null) {
                            res._ifs_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._ifs_bufs.?.append(result.value);
                    },
                    Expression.IfThenWire.ELSE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._else__buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const IfThenReader) void {
            if (self._ifs_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getIfs(self: *const IfThenReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.IfThen.IfClauseReader {
            if (self._ifs_bufs) |bufs| {
                var result = try std.ArrayList(Expression.IfThen.IfClauseReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try Expression.IfThen.IfClauseReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]Expression.IfThen.IfClauseReader{};
        }
        pub fn getElse(self: *const IfThenReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
            if (self._else__buf) |buf| {
                return try ExpressionReader.init(allocator, buf);
            }
            return try ExpressionReader.init(allocator, &[_]u8{});
        }
    };
    
    const CastWire = struct {
        const TYPE_WIRE: gremlin.ProtoWireNumber = 1;
        const INPUT_WIRE: gremlin.ProtoWireNumber = 2;
        const FAILURE_BEHAVIOR_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const Cast = struct {
        // nested enums
        pub const FailureBehavior = enum(i32) {
            FAILURE_BEHAVIOR_UNSPECIFIED = 0,
            FAILURE_BEHAVIOR_RETURN_NULL = 1,
            FAILURE_BEHAVIOR_THROW_EXCEPTION = 2,
        };
        
        // fields
        type: ?type.Type = null,
        input: ?Expression = null,
        failure_behavior: Expression.Cast.FailureBehavior = @enumFromInt(0),

        pub fn calcProtobufSize(self: *const Cast) usize {
            var res: usize = 0;
            if (self.type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.CastWire.TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.input) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.CastWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (@intFromEnum(self.failure_behavior) != 0) { res += gremlin.sizes.sizeWireNumber(Expression.CastWire.FAILURE_BEHAVIOR_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.failure_behavior)); }
            return res;
        }

        pub fn encode(self: *const Cast, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Cast, target: *gremlin.Writer) void {
            if (self.type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.CastWire.TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.input) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.CastWire.INPUT_WIRE, size);
                v.encodeTo(target);
            }
            if (@intFromEnum(self.failure_behavior) != 0) { target.appendInt32(Expression.CastWire.FAILURE_BEHAVIOR_WIRE, @intFromEnum(self.failure_behavior)); }
        }
    };
    
    pub const CastReader = struct {
        _type_buf: ?[]const u8 = null,
        _input_buf: ?[]const u8 = null,
        _failure_behavior: Expression.Cast.FailureBehavior = @enumFromInt(0),

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!CastReader {
            var buf = gremlin.Reader.init(src);
            var res = CastReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.CastWire.TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._type_buf = result.value;
                    },
                    Expression.CastWire.INPUT_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._input_buf = result.value;
                    },
                    Expression.CastWire.FAILURE_BEHAVIOR_WIRE => {
                      const result = try buf.readInt32(offset);
                      offset += result.size;
                      res._failure_behavior = @enumFromInt(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const CastReader) void { }
        
        pub fn getType(self: *const CastReader, allocator: std.mem.Allocator) gremlin.Error!type.TypeReader {
            if (self._type_buf) |buf| {
                return try type.TypeReader.init(allocator, buf);
            }
            return try type.TypeReader.init(allocator, &[_]u8{});
        }
        pub fn getInput(self: *const CastReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
            if (self._input_buf) |buf| {
                return try ExpressionReader.init(allocator, buf);
            }
            return try ExpressionReader.init(allocator, &[_]u8{});
        }
        pub inline fn getFailureBehavior(self: *const CastReader) Expression.Cast.FailureBehavior { return self._failure_behavior; }
    };
    
    const SwitchExpressionWire = struct {
        const MATCH_WIRE: gremlin.ProtoWireNumber = 3;
        const IFS_WIRE: gremlin.ProtoWireNumber = 1;
        const ELSE_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const SwitchExpression = struct {
        // nested structs
        const IfValueWire = struct {
            const IF_WIRE: gremlin.ProtoWireNumber = 1;
            const THEN_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const IfValue = struct {
            // fields
            if_: ?Expression.Literal = null,
            then: ?Expression = null,

            pub fn calcProtobufSize(self: *const IfValue) usize {
                var res: usize = 0;
                if (self.if_) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.SwitchExpression.IfValueWire.IF_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.then) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.SwitchExpression.IfValueWire.THEN_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const IfValue, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const IfValue, target: *gremlin.Writer) void {
                if (self.if_) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.SwitchExpression.IfValueWire.IF_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.then) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.SwitchExpression.IfValueWire.THEN_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const IfValueReader = struct {
            _if__buf: ?[]const u8 = null,
            _then_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!IfValueReader {
                var buf = gremlin.Reader.init(src);
                var res = IfValueReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.SwitchExpression.IfValueWire.IF_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._if__buf = result.value;
                        },
                        Expression.SwitchExpression.IfValueWire.THEN_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._then_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const IfValueReader) void { }
            
            pub fn getIf(self: *const IfValueReader, allocator: std.mem.Allocator) gremlin.Error!Expression.LiteralReader {
                if (self._if__buf) |buf| {
                    return try Expression.LiteralReader.init(allocator, buf);
                }
                return try Expression.LiteralReader.init(allocator, &[_]u8{});
            }
            pub fn getThen(self: *const IfValueReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
                if (self._then_buf) |buf| {
                    return try ExpressionReader.init(allocator, buf);
                }
                return try ExpressionReader.init(allocator, &[_]u8{});
            }
        };
        
        // fields
        match: ?Expression = null,
        ifs: ?[]const ?Expression.SwitchExpression.IfValue = null,
        else_: ?Expression = null,

        pub fn calcProtobufSize(self: *const SwitchExpression) usize {
            var res: usize = 0;
            if (self.match) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.SwitchExpressionWire.MATCH_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.ifs) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.SwitchExpressionWire.IFS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.else_) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.SwitchExpressionWire.ELSE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const SwitchExpression, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const SwitchExpression, target: *gremlin.Writer) void {
            if (self.match) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.SwitchExpressionWire.MATCH_WIRE, size);
                v.encodeTo(target);
            }
            if (self.ifs) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.SwitchExpressionWire.IFS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.SwitchExpressionWire.IFS_WIRE, 0);
                    }
                }
            }
            if (self.else_) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.SwitchExpressionWire.ELSE_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const SwitchExpressionReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _match_buf: ?[]const u8 = null,
        _ifs_bufs: ?std.ArrayList([]const u8) = null,
        _else__buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!SwitchExpressionReader {
            var buf = gremlin.Reader.init(src);
            var res = SwitchExpressionReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.SwitchExpressionWire.MATCH_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._match_buf = result.value;
                    },
                    Expression.SwitchExpressionWire.IFS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._ifs_bufs == null) {
                            res._ifs_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._ifs_bufs.?.append(result.value);
                    },
                    Expression.SwitchExpressionWire.ELSE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._else__buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const SwitchExpressionReader) void {
            if (self._ifs_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getMatch(self: *const SwitchExpressionReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
            if (self._match_buf) |buf| {
                return try ExpressionReader.init(allocator, buf);
            }
            return try ExpressionReader.init(allocator, &[_]u8{});
        }
        pub fn getIfs(self: *const SwitchExpressionReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.SwitchExpression.IfValueReader {
            if (self._ifs_bufs) |bufs| {
                var result = try std.ArrayList(Expression.SwitchExpression.IfValueReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try Expression.SwitchExpression.IfValueReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]Expression.SwitchExpression.IfValueReader{};
        }
        pub fn getElse(self: *const SwitchExpressionReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
            if (self._else__buf) |buf| {
                return try ExpressionReader.init(allocator, buf);
            }
            return try ExpressionReader.init(allocator, &[_]u8{});
        }
    };
    
    const SingularOrListWire = struct {
        const VALUE_WIRE: gremlin.ProtoWireNumber = 1;
        const OPTIONS_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const SingularOrList = struct {
        // fields
        value: ?Expression = null,
        options: ?[]const ?Expression = null,

        pub fn calcProtobufSize(self: *const SingularOrList) usize {
            var res: usize = 0;
            if (self.value) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.SingularOrListWire.VALUE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.options) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.SingularOrListWire.OPTIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            return res;
        }

        pub fn encode(self: *const SingularOrList, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const SingularOrList, target: *gremlin.Writer) void {
            if (self.value) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.SingularOrListWire.VALUE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.options) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.SingularOrListWire.OPTIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.SingularOrListWire.OPTIONS_WIRE, 0);
                    }
                }
            }
        }
    };
    
    pub const SingularOrListReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _value_buf: ?[]const u8 = null,
        _options_bufs: ?std.ArrayList([]const u8) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!SingularOrListReader {
            var buf = gremlin.Reader.init(src);
            var res = SingularOrListReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.SingularOrListWire.VALUE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._value_buf = result.value;
                    },
                    Expression.SingularOrListWire.OPTIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._options_bufs == null) {
                            res._options_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._options_bufs.?.append(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const SingularOrListReader) void {
            if (self._options_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getValue(self: *const SingularOrListReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
            if (self._value_buf) |buf| {
                return try ExpressionReader.init(allocator, buf);
            }
            return try ExpressionReader.init(allocator, &[_]u8{});
        }
        pub fn getOptions(self: *const SingularOrListReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
            if (self._options_bufs) |bufs| {
                var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try ExpressionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]ExpressionReader{};
        }
    };
    
    const MultiOrListWire = struct {
        const VALUE_WIRE: gremlin.ProtoWireNumber = 1;
        const OPTIONS_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const MultiOrList = struct {
        // nested structs
        const RecordWire = struct {
            const FIELDS_WIRE: gremlin.ProtoWireNumber = 1;
        };
        
        pub const Record = struct {
            // fields
            fields: ?[]const ?Expression = null,

            pub fn calcProtobufSize(self: *const Record) usize {
                var res: usize = 0;
                if (self.fields) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.MultiOrList.RecordWire.FIELDS_WIRE);
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            res += gremlin.sizes.sizeUsize(size) + size;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                return res;
            }

            pub fn encode(self: *const Record, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const Record, target: *gremlin.Writer) void {
                if (self.fields) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            target.appendBytesTag(Expression.MultiOrList.RecordWire.FIELDS_WIRE, size);
                            v.encodeTo(target);
                        } else {
                            target.appendBytesTag(Expression.MultiOrList.RecordWire.FIELDS_WIRE, 0);
                        }
                    }
                }
            }
        };
        
        pub const RecordReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _fields_bufs: ?std.ArrayList([]const u8) = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!RecordReader {
                var buf = gremlin.Reader.init(src);
                var res = RecordReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.MultiOrList.RecordWire.FIELDS_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._fields_bufs == null) {
                                res._fields_bufs = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._fields_bufs.?.append(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const RecordReader) void {
                if (self._fields_bufs) |arr| {
                    arr.deinit();
                }
            }
            pub fn getFields(self: *const RecordReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
                if (self._fields_bufs) |bufs| {
                    var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                    for (bufs.items) |buf| {
                        try result.append(try ExpressionReader.init(allocator, buf));
                    }
                    return result.toOwnedSlice();
                }
                return &[_]ExpressionReader{};
            }
        };
        
        // fields
        value: ?[]const ?Expression = null,
        options: ?[]const ?Expression.MultiOrList.Record = null,

        pub fn calcProtobufSize(self: *const MultiOrList) usize {
            var res: usize = 0;
            if (self.value) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.MultiOrListWire.VALUE_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.options) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.MultiOrListWire.OPTIONS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            return res;
        }

        pub fn encode(self: *const MultiOrList, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const MultiOrList, target: *gremlin.Writer) void {
            if (self.value) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.MultiOrListWire.VALUE_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.MultiOrListWire.VALUE_WIRE, 0);
                    }
                }
            }
            if (self.options) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.MultiOrListWire.OPTIONS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.MultiOrListWire.OPTIONS_WIRE, 0);
                    }
                }
            }
        }
    };
    
    pub const MultiOrListReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _value_bufs: ?std.ArrayList([]const u8) = null,
        _options_bufs: ?std.ArrayList([]const u8) = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!MultiOrListReader {
            var buf = gremlin.Reader.init(src);
            var res = MultiOrListReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.MultiOrListWire.VALUE_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._value_bufs == null) {
                            res._value_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._value_bufs.?.append(result.value);
                    },
                    Expression.MultiOrListWire.OPTIONS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._options_bufs == null) {
                            res._options_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._options_bufs.?.append(result.value);
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const MultiOrListReader) void {
            if (self._value_bufs) |arr| {
                arr.deinit();
            }
            if (self._options_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getValue(self: *const MultiOrListReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
            if (self._value_bufs) |bufs| {
                var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try ExpressionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]ExpressionReader{};
        }
        pub fn getOptions(self: *const MultiOrListReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.MultiOrList.RecordReader {
            if (self._options_bufs) |bufs| {
                var result = try std.ArrayList(Expression.MultiOrList.RecordReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try Expression.MultiOrList.RecordReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]Expression.MultiOrList.RecordReader{};
        }
    };
    
    const EmbeddedFunctionWire = struct {
        const ARGUMENTS_WIRE: gremlin.ProtoWireNumber = 1;
        const OUTPUT_TYPE_WIRE: gremlin.ProtoWireNumber = 2;
        const PYTHON_PICKLE_FUNCTION_WIRE: gremlin.ProtoWireNumber = 3;
        const WEB_ASSEMBLY_FUNCTION_WIRE: gremlin.ProtoWireNumber = 4;
    };
    
    pub const EmbeddedFunction = struct {
        // nested structs
        const PythonPickleFunctionWire = struct {
            const FUNCTION_WIRE: gremlin.ProtoWireNumber = 1;
            const PREREQUISITE_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const PythonPickleFunction = struct {
            // fields
            function: ?[]const u8 = null,
            prerequisite: ?[]const ?[]const u8 = null,

            pub fn calcProtobufSize(self: *const PythonPickleFunction) usize {
                var res: usize = 0;
                if (self.function) |v| { res += gremlin.sizes.sizeWireNumber(Expression.EmbeddedFunction.PythonPickleFunctionWire.FUNCTION_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                if (self.prerequisite) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.EmbeddedFunction.PythonPickleFunctionWire.PREREQUISITE_WIRE);
                        if (maybe_v) |v| {
                            res += gremlin.sizes.sizeUsize(v.len) + v.len;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                return res;
            }

            pub fn encode(self: *const PythonPickleFunction, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const PythonPickleFunction, target: *gremlin.Writer) void {
                if (self.function) |v| { target.appendBytes(Expression.EmbeddedFunction.PythonPickleFunctionWire.FUNCTION_WIRE, v); }
                if (self.prerequisite) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            target.appendBytes(Expression.EmbeddedFunction.PythonPickleFunctionWire.PREREQUISITE_WIRE, v);
                        } else {
                            target.appendBytesTag(Expression.EmbeddedFunction.PythonPickleFunctionWire.PREREQUISITE_WIRE, 0);
                        }
                    }
                }
            }
        };
        
        pub const PythonPickleFunctionReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _function: ?[]const u8 = null,
            _prerequisite: ?std.ArrayList([]const u8) = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!PythonPickleFunctionReader {
                var buf = gremlin.Reader.init(src);
                var res = PythonPickleFunctionReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.EmbeddedFunction.PythonPickleFunctionWire.FUNCTION_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._function = result.value;
                        },
                        Expression.EmbeddedFunction.PythonPickleFunctionWire.PREREQUISITE_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._prerequisite == null) {
                                res._prerequisite = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._prerequisite.?.append(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const PythonPickleFunctionReader) void {
                if (self._prerequisite) |arr| {
                    arr.deinit();
                }
            }
            pub inline fn getFunction(self: *const PythonPickleFunctionReader) []const u8 { return self._function orelse &[_]u8{}; }
            pub fn getPrerequisite(self: *const PythonPickleFunctionReader) []const []const u8 {
                if (self._prerequisite) |arr| {
                    return arr.items;
                }
                return &[_][]u8{};
            }
        };
        
        const WebAssemblyFunctionWire = struct {
            const SCRIPT_WIRE: gremlin.ProtoWireNumber = 1;
            const PREREQUISITE_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const WebAssemblyFunction = struct {
            // fields
            script: ?[]const u8 = null,
            prerequisite: ?[]const ?[]const u8 = null,

            pub fn calcProtobufSize(self: *const WebAssemblyFunction) usize {
                var res: usize = 0;
                if (self.script) |v| { res += gremlin.sizes.sizeWireNumber(Expression.EmbeddedFunction.WebAssemblyFunctionWire.SCRIPT_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                if (self.prerequisite) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.EmbeddedFunction.WebAssemblyFunctionWire.PREREQUISITE_WIRE);
                        if (maybe_v) |v| {
                            res += gremlin.sizes.sizeUsize(v.len) + v.len;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                return res;
            }

            pub fn encode(self: *const WebAssemblyFunction, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const WebAssemblyFunction, target: *gremlin.Writer) void {
                if (self.script) |v| { target.appendBytes(Expression.EmbeddedFunction.WebAssemblyFunctionWire.SCRIPT_WIRE, v); }
                if (self.prerequisite) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            target.appendBytes(Expression.EmbeddedFunction.WebAssemblyFunctionWire.PREREQUISITE_WIRE, v);
                        } else {
                            target.appendBytesTag(Expression.EmbeddedFunction.WebAssemblyFunctionWire.PREREQUISITE_WIRE, 0);
                        }
                    }
                }
            }
        };
        
        pub const WebAssemblyFunctionReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _script: ?[]const u8 = null,
            _prerequisite: ?std.ArrayList([]const u8) = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!WebAssemblyFunctionReader {
                var buf = gremlin.Reader.init(src);
                var res = WebAssemblyFunctionReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.EmbeddedFunction.WebAssemblyFunctionWire.SCRIPT_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._script = result.value;
                        },
                        Expression.EmbeddedFunction.WebAssemblyFunctionWire.PREREQUISITE_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._prerequisite == null) {
                                res._prerequisite = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._prerequisite.?.append(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const WebAssemblyFunctionReader) void {
                if (self._prerequisite) |arr| {
                    arr.deinit();
                }
            }
            pub inline fn getScript(self: *const WebAssemblyFunctionReader) []const u8 { return self._script orelse &[_]u8{}; }
            pub fn getPrerequisite(self: *const WebAssemblyFunctionReader) []const []const u8 {
                if (self._prerequisite) |arr| {
                    return arr.items;
                }
                return &[_][]u8{};
            }
        };
        
        // fields
        arguments: ?[]const ?Expression = null,
        output_type: ?type.Type = null,
        python_pickle_function: ?Expression.EmbeddedFunction.PythonPickleFunction = null,
        web_assembly_function: ?Expression.EmbeddedFunction.WebAssemblyFunction = null,

        pub fn calcProtobufSize(self: *const EmbeddedFunction) usize {
            var res: usize = 0;
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    res += gremlin.sizes.sizeWireNumber(Expression.EmbeddedFunctionWire.ARGUMENTS_WIRE);
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeUsize(size) + size;
                    } else {
                        res += gremlin.sizes.sizeUsize(0);
                    }
                }
            }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.EmbeddedFunctionWire.OUTPUT_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.python_pickle_function) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.EmbeddedFunctionWire.PYTHON_PICKLE_FUNCTION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.web_assembly_function) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.EmbeddedFunctionWire.WEB_ASSEMBLY_FUNCTION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const EmbeddedFunction, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const EmbeddedFunction, target: *gremlin.Writer) void {
            if (self.arguments) |arr| {
                for (arr) |maybe_v| {
                    if (maybe_v) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.EmbeddedFunctionWire.ARGUMENTS_WIRE, size);
                        v.encodeTo(target);
                    } else {
                        target.appendBytesTag(Expression.EmbeddedFunctionWire.ARGUMENTS_WIRE, 0);
                    }
                }
            }
            if (self.output_type) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.EmbeddedFunctionWire.OUTPUT_TYPE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.python_pickle_function) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.EmbeddedFunctionWire.PYTHON_PICKLE_FUNCTION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.web_assembly_function) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.EmbeddedFunctionWire.WEB_ASSEMBLY_FUNCTION_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const EmbeddedFunctionReader = struct {
        allocator: std.mem.Allocator,
        buf: gremlin.Reader,
        _arguments_bufs: ?std.ArrayList([]const u8) = null,
        _output_type_buf: ?[]const u8 = null,
        _python_pickle_function_buf: ?[]const u8 = null,
        _web_assembly_function_buf: ?[]const u8 = null,

        pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!EmbeddedFunctionReader {
            var buf = gremlin.Reader.init(src);
            var res = EmbeddedFunctionReader{.allocator = allocator, .buf = buf};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.EmbeddedFunctionWire.ARGUMENTS_WIRE => {
                        const result = try buf.readBytes(offset);
                        offset += result.size;
                        if (res._arguments_bufs == null) {
                            res._arguments_bufs = std.ArrayList([]const u8).init(allocator);
                        }
                        try res._arguments_bufs.?.append(result.value);
                    },
                    Expression.EmbeddedFunctionWire.OUTPUT_TYPE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._output_type_buf = result.value;
                    },
                    Expression.EmbeddedFunctionWire.PYTHON_PICKLE_FUNCTION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._python_pickle_function_buf = result.value;
                    },
                    Expression.EmbeddedFunctionWire.WEB_ASSEMBLY_FUNCTION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._web_assembly_function_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(self: *const EmbeddedFunctionReader) void {
            if (self._arguments_bufs) |arr| {
                arr.deinit();
            }
        }
        pub fn getArguments(self: *const EmbeddedFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
            if (self._arguments_bufs) |bufs| {
                var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                for (bufs.items) |buf| {
                    try result.append(try ExpressionReader.init(allocator, buf));
                }
                return result.toOwnedSlice();
            }
            return &[_]ExpressionReader{};
        }
        pub fn getOutputType(self: *const EmbeddedFunctionReader, allocator: std.mem.Allocator) gremlin.Error!type.TypeReader {
            if (self._output_type_buf) |buf| {
                return try type.TypeReader.init(allocator, buf);
            }
            return try type.TypeReader.init(allocator, &[_]u8{});
        }
        pub fn getPythonPickleFunction(self: *const EmbeddedFunctionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.EmbeddedFunction.PythonPickleFunctionReader {
            if (self._python_pickle_function_buf) |buf| {
                return try Expression.EmbeddedFunction.PythonPickleFunctionReader.init(allocator, buf);
            }
            return try Expression.EmbeddedFunction.PythonPickleFunctionReader.init(allocator, &[_]u8{});
        }
        pub fn getWebAssemblyFunction(self: *const EmbeddedFunctionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.EmbeddedFunction.WebAssemblyFunctionReader {
            if (self._web_assembly_function_buf) |buf| {
                return try Expression.EmbeddedFunction.WebAssemblyFunctionReader.init(allocator, buf);
            }
            return try Expression.EmbeddedFunction.WebAssemblyFunctionReader.init(allocator, &[_]u8{});
        }
    };
    
    const ReferenceSegmentWire = struct {
        const MAP_KEY_WIRE: gremlin.ProtoWireNumber = 1;
        const STRUCT_FIELD_WIRE: gremlin.ProtoWireNumber = 2;
        const LIST_ELEMENT_WIRE: gremlin.ProtoWireNumber = 3;
    };
    
    pub const ReferenceSegment = struct {
        // nested structs
        const MapKeyWire = struct {
            const MAP_KEY_WIRE: gremlin.ProtoWireNumber = 1;
            const CHILD_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const MapKey = struct {
            // fields
            map_key: ?Expression.Literal = null,
            child: ?Expression.ReferenceSegment = null,

            pub fn calcProtobufSize(self: *const MapKey) usize {
                var res: usize = 0;
                if (self.map_key) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.ReferenceSegment.MapKeyWire.MAP_KEY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.ReferenceSegment.MapKeyWire.CHILD_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const MapKey, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const MapKey, target: *gremlin.Writer) void {
                if (self.map_key) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.ReferenceSegment.MapKeyWire.MAP_KEY_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.ReferenceSegment.MapKeyWire.CHILD_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const MapKeyReader = struct {
            _map_key_buf: ?[]const u8 = null,
            _child_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!MapKeyReader {
                var buf = gremlin.Reader.init(src);
                var res = MapKeyReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.ReferenceSegment.MapKeyWire.MAP_KEY_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._map_key_buf = result.value;
                        },
                        Expression.ReferenceSegment.MapKeyWire.CHILD_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._child_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const MapKeyReader) void { }
            
            pub fn getMapKey(self: *const MapKeyReader, allocator: std.mem.Allocator) gremlin.Error!Expression.LiteralReader {
                if (self._map_key_buf) |buf| {
                    return try Expression.LiteralReader.init(allocator, buf);
                }
                return try Expression.LiteralReader.init(allocator, &[_]u8{});
            }
            pub fn getChild(self: *const MapKeyReader, allocator: std.mem.Allocator) gremlin.Error!Expression.ReferenceSegmentReader {
                if (self._child_buf) |buf| {
                    return try Expression.ReferenceSegmentReader.init(allocator, buf);
                }
                return try Expression.ReferenceSegmentReader.init(allocator, &[_]u8{});
            }
        };
        
        const StructFieldWire = struct {
            const FIELD_WIRE: gremlin.ProtoWireNumber = 1;
            const CHILD_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const StructField = struct {
            // fields
            field: i32 = 0,
            child: ?Expression.ReferenceSegment = null,

            pub fn calcProtobufSize(self: *const StructField) usize {
                var res: usize = 0;
                if (self.field != 0) { res += gremlin.sizes.sizeWireNumber(Expression.ReferenceSegment.StructFieldWire.FIELD_WIRE) + gremlin.sizes.sizeI32(self.field); }
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.ReferenceSegment.StructFieldWire.CHILD_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const StructField, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const StructField, target: *gremlin.Writer) void {
                if (self.field != 0) { target.appendInt32(Expression.ReferenceSegment.StructFieldWire.FIELD_WIRE, self.field); }
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.ReferenceSegment.StructFieldWire.CHILD_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const StructFieldReader = struct {
            _field: i32 = 0,
            _child_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!StructFieldReader {
                var buf = gremlin.Reader.init(src);
                var res = StructFieldReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.ReferenceSegment.StructFieldWire.FIELD_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._field = result.value;
                        },
                        Expression.ReferenceSegment.StructFieldWire.CHILD_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._child_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const StructFieldReader) void { }
            
            pub inline fn getField(self: *const StructFieldReader) i32 { return self._field; }
            pub fn getChild(self: *const StructFieldReader, allocator: std.mem.Allocator) gremlin.Error!Expression.ReferenceSegmentReader {
                if (self._child_buf) |buf| {
                    return try Expression.ReferenceSegmentReader.init(allocator, buf);
                }
                return try Expression.ReferenceSegmentReader.init(allocator, &[_]u8{});
            }
        };
        
        const ListElementWire = struct {
            const OFFSET_WIRE: gremlin.ProtoWireNumber = 1;
            const CHILD_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const ListElement = struct {
            // fields
            offset: i32 = 0,
            child: ?Expression.ReferenceSegment = null,

            pub fn calcProtobufSize(self: *const ListElement) usize {
                var res: usize = 0;
                if (self.offset != 0) { res += gremlin.sizes.sizeWireNumber(Expression.ReferenceSegment.ListElementWire.OFFSET_WIRE) + gremlin.sizes.sizeI32(self.offset); }
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.ReferenceSegment.ListElementWire.CHILD_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const ListElement, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const ListElement, target: *gremlin.Writer) void {
                if (self.offset != 0) { target.appendInt32(Expression.ReferenceSegment.ListElementWire.OFFSET_WIRE, self.offset); }
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.ReferenceSegment.ListElementWire.CHILD_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const ListElementReader = struct {
            _offset: i32 = 0,
            _child_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ListElementReader {
                var buf = gremlin.Reader.init(src);
                var res = ListElementReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.ReferenceSegment.ListElementWire.OFFSET_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._offset = result.value;
                        },
                        Expression.ReferenceSegment.ListElementWire.CHILD_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._child_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const ListElementReader) void { }
            
            pub inline fn getOffset(self: *const ListElementReader) i32 { return self._offset; }
            pub fn getChild(self: *const ListElementReader, allocator: std.mem.Allocator) gremlin.Error!Expression.ReferenceSegmentReader {
                if (self._child_buf) |buf| {
                    return try Expression.ReferenceSegmentReader.init(allocator, buf);
                }
                return try Expression.ReferenceSegmentReader.init(allocator, &[_]u8{});
            }
        };
        
        // fields
        map_key: ?Expression.ReferenceSegment.MapKey = null,
        struct_field: ?Expression.ReferenceSegment.StructField = null,
        list_element: ?Expression.ReferenceSegment.ListElement = null,

        pub fn calcProtobufSize(self: *const ReferenceSegment) usize {
            var res: usize = 0;
            if (self.map_key) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.ReferenceSegmentWire.MAP_KEY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.struct_field) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.ReferenceSegmentWire.STRUCT_FIELD_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.list_element) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.ReferenceSegmentWire.LIST_ELEMENT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const ReferenceSegment, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const ReferenceSegment, target: *gremlin.Writer) void {
            if (self.map_key) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.ReferenceSegmentWire.MAP_KEY_WIRE, size);
                v.encodeTo(target);
            }
            if (self.struct_field) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.ReferenceSegmentWire.STRUCT_FIELD_WIRE, size);
                v.encodeTo(target);
            }
            if (self.list_element) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.ReferenceSegmentWire.LIST_ELEMENT_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const ReferenceSegmentReader = struct {
        _map_key_buf: ?[]const u8 = null,
        _struct_field_buf: ?[]const u8 = null,
        _list_element_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ReferenceSegmentReader {
            var buf = gremlin.Reader.init(src);
            var res = ReferenceSegmentReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.ReferenceSegmentWire.MAP_KEY_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._map_key_buf = result.value;
                    },
                    Expression.ReferenceSegmentWire.STRUCT_FIELD_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._struct_field_buf = result.value;
                    },
                    Expression.ReferenceSegmentWire.LIST_ELEMENT_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._list_element_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const ReferenceSegmentReader) void { }
        
        pub fn getMapKey(self: *const ReferenceSegmentReader, allocator: std.mem.Allocator) gremlin.Error!Expression.ReferenceSegment.MapKeyReader {
            if (self._map_key_buf) |buf| {
                return try Expression.ReferenceSegment.MapKeyReader.init(allocator, buf);
            }
            return try Expression.ReferenceSegment.MapKeyReader.init(allocator, &[_]u8{});
        }
        pub fn getStructField(self: *const ReferenceSegmentReader, allocator: std.mem.Allocator) gremlin.Error!Expression.ReferenceSegment.StructFieldReader {
            if (self._struct_field_buf) |buf| {
                return try Expression.ReferenceSegment.StructFieldReader.init(allocator, buf);
            }
            return try Expression.ReferenceSegment.StructFieldReader.init(allocator, &[_]u8{});
        }
        pub fn getListElement(self: *const ReferenceSegmentReader, allocator: std.mem.Allocator) gremlin.Error!Expression.ReferenceSegment.ListElementReader {
            if (self._list_element_buf) |buf| {
                return try Expression.ReferenceSegment.ListElementReader.init(allocator, buf);
            }
            return try Expression.ReferenceSegment.ListElementReader.init(allocator, &[_]u8{});
        }
    };
    
    const MaskExpressionWire = struct {
        const SELECT_WIRE: gremlin.ProtoWireNumber = 1;
        const MAINTAIN_SINGULAR_STRUCT_WIRE: gremlin.ProtoWireNumber = 2;
    };
    
    pub const MaskExpression = struct {
        // nested structs
        const SelectWire = struct {
            const STRUCT_WIRE: gremlin.ProtoWireNumber = 1;
            const LIST_WIRE: gremlin.ProtoWireNumber = 2;
            const MAP_WIRE: gremlin.ProtoWireNumber = 3;
        };
        
        pub const Select = struct {
            // fields
            struct_: ?Expression.MaskExpression.StructSelect = null,
            list: ?Expression.MaskExpression.ListSelect = null,
            map: ?Expression.MaskExpression.MapSelect = null,

            pub fn calcProtobufSize(self: *const Select) usize {
                var res: usize = 0;
                if (self.struct_) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.SelectWire.STRUCT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.list) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.SelectWire.LIST_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.map) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.SelectWire.MAP_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const Select, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const Select, target: *gremlin.Writer) void {
                if (self.struct_) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.MaskExpression.SelectWire.STRUCT_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.list) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.MaskExpression.SelectWire.LIST_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.map) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.MaskExpression.SelectWire.MAP_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const SelectReader = struct {
            _struct__buf: ?[]const u8 = null,
            _list_buf: ?[]const u8 = null,
            _map_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!SelectReader {
                var buf = gremlin.Reader.init(src);
                var res = SelectReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.MaskExpression.SelectWire.STRUCT_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._struct__buf = result.value;
                        },
                        Expression.MaskExpression.SelectWire.LIST_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._list_buf = result.value;
                        },
                        Expression.MaskExpression.SelectWire.MAP_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._map_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const SelectReader) void { }
            
            pub fn getStruct(self: *const SelectReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpression.StructSelectReader {
                if (self._struct__buf) |buf| {
                    return try Expression.MaskExpression.StructSelectReader.init(allocator, buf);
                }
                return try Expression.MaskExpression.StructSelectReader.init(allocator, &[_]u8{});
            }
            pub fn getList(self: *const SelectReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpression.ListSelectReader {
                if (self._list_buf) |buf| {
                    return try Expression.MaskExpression.ListSelectReader.init(allocator, buf);
                }
                return try Expression.MaskExpression.ListSelectReader.init(allocator, &[_]u8{});
            }
            pub fn getMap(self: *const SelectReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpression.MapSelectReader {
                if (self._map_buf) |buf| {
                    return try Expression.MaskExpression.MapSelectReader.init(allocator, buf);
                }
                return try Expression.MaskExpression.MapSelectReader.init(allocator, &[_]u8{});
            }
        };
        
        const StructSelectWire = struct {
            const STRUCT_ITEMS_WIRE: gremlin.ProtoWireNumber = 1;
        };
        
        pub const StructSelect = struct {
            // fields
            struct_items: ?[]const ?Expression.MaskExpression.StructItem = null,

            pub fn calcProtobufSize(self: *const StructSelect) usize {
                var res: usize = 0;
                if (self.struct_items) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.StructSelectWire.STRUCT_ITEMS_WIRE);
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            res += gremlin.sizes.sizeUsize(size) + size;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                return res;
            }

            pub fn encode(self: *const StructSelect, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const StructSelect, target: *gremlin.Writer) void {
                if (self.struct_items) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            target.appendBytesTag(Expression.MaskExpression.StructSelectWire.STRUCT_ITEMS_WIRE, size);
                            v.encodeTo(target);
                        } else {
                            target.appendBytesTag(Expression.MaskExpression.StructSelectWire.STRUCT_ITEMS_WIRE, 0);
                        }
                    }
                }
            }
        };
        
        pub const StructSelectReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _struct_items_bufs: ?std.ArrayList([]const u8) = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!StructSelectReader {
                var buf = gremlin.Reader.init(src);
                var res = StructSelectReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.MaskExpression.StructSelectWire.STRUCT_ITEMS_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._struct_items_bufs == null) {
                                res._struct_items_bufs = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._struct_items_bufs.?.append(result.value);
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const StructSelectReader) void {
                if (self._struct_items_bufs) |arr| {
                    arr.deinit();
                }
            }
            pub fn getStructItems(self: *const StructSelectReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.MaskExpression.StructItemReader {
                if (self._struct_items_bufs) |bufs| {
                    var result = try std.ArrayList(Expression.MaskExpression.StructItemReader).initCapacity(allocator, bufs.items.len);
                    for (bufs.items) |buf| {
                        try result.append(try Expression.MaskExpression.StructItemReader.init(allocator, buf));
                    }
                    return result.toOwnedSlice();
                }
                return &[_]Expression.MaskExpression.StructItemReader{};
            }
        };
        
        const StructItemWire = struct {
            const FIELD_WIRE: gremlin.ProtoWireNumber = 1;
            const CHILD_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const StructItem = struct {
            // fields
            field: i32 = 0,
            child: ?Expression.MaskExpression.Select = null,

            pub fn calcProtobufSize(self: *const StructItem) usize {
                var res: usize = 0;
                if (self.field != 0) { res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.StructItemWire.FIELD_WIRE) + gremlin.sizes.sizeI32(self.field); }
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.StructItemWire.CHILD_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const StructItem, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const StructItem, target: *gremlin.Writer) void {
                if (self.field != 0) { target.appendInt32(Expression.MaskExpression.StructItemWire.FIELD_WIRE, self.field); }
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.MaskExpression.StructItemWire.CHILD_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const StructItemReader = struct {
            _field: i32 = 0,
            _child_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!StructItemReader {
                var buf = gremlin.Reader.init(src);
                var res = StructItemReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.MaskExpression.StructItemWire.FIELD_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._field = result.value;
                        },
                        Expression.MaskExpression.StructItemWire.CHILD_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._child_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const StructItemReader) void { }
            
            pub inline fn getField(self: *const StructItemReader) i32 { return self._field; }
            pub fn getChild(self: *const StructItemReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpression.SelectReader {
                if (self._child_buf) |buf| {
                    return try Expression.MaskExpression.SelectReader.init(allocator, buf);
                }
                return try Expression.MaskExpression.SelectReader.init(allocator, &[_]u8{});
            }
        };
        
        const ListSelectWire = struct {
            const SELECTION_WIRE: gremlin.ProtoWireNumber = 1;
            const CHILD_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const ListSelect = struct {
            // nested structs
            const ListSelectItemWire = struct {
                const ITEM_WIRE: gremlin.ProtoWireNumber = 1;
                const SLICE_WIRE: gremlin.ProtoWireNumber = 2;
            };
            
            pub const ListSelectItem = struct {
                // nested structs
                const ListElementWire = struct {
                    const FIELD_WIRE: gremlin.ProtoWireNumber = 1;
                };
                
                pub const ListElement = struct {
                    // fields
                    field: i32 = 0,

                    pub fn calcProtobufSize(self: *const ListElement) usize {
                        var res: usize = 0;
                        if (self.field != 0) { res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.ListSelect.ListSelectItem.ListElementWire.FIELD_WIRE) + gremlin.sizes.sizeI32(self.field); }
                        return res;
                    }

                    pub fn encode(self: *const ListElement, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                        const size = self.calcProtobufSize();
                        if (size == 0) {
                            return &[_]u8{};
                        }
                        const buf = try allocator.alloc(u8, self.calcProtobufSize());
                        var writer = gremlin.Writer.init(buf);
                        self.encodeTo(&writer);
                        return buf;
                    }


                    pub fn encodeTo(self: *const ListElement, target: *gremlin.Writer) void {
                        if (self.field != 0) { target.appendInt32(Expression.MaskExpression.ListSelect.ListSelectItem.ListElementWire.FIELD_WIRE, self.field); }
                    }
                };
                
                pub const ListElementReader = struct {
                    _field: i32 = 0,

                    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ListElementReader {
                        var buf = gremlin.Reader.init(src);
                        var res = ListElementReader{};
                        if (buf.buf.len == 0) {
                            return res;
                        }
                        var offset: usize = 0;
                        while (buf.hasNext(offset, 0)) {
                            const tag = try buf.readTagAt(offset);
                            offset += tag.size;
                            switch (tag.number) {
                                Expression.MaskExpression.ListSelect.ListSelectItem.ListElementWire.FIELD_WIRE => {
                                  const result = try buf.readInt32(offset);
                                  offset += result.size;
                                  res._field = result.value;
                                },
                                else => {
                                    offset = try buf.skipData(offset, tag.wire);
                                }
                            }
                        }
                        return res;
                    }
                    pub fn deinit(_: *const ListElementReader) void { }
                    
                    pub inline fn getField(self: *const ListElementReader) i32 { return self._field; }
                };
                
                const ListSliceWire = struct {
                    const START_WIRE: gremlin.ProtoWireNumber = 1;
                    const END_WIRE: gremlin.ProtoWireNumber = 2;
                };
                
                pub const ListSlice = struct {
                    // fields
                    start: i32 = 0,
                    end: i32 = 0,

                    pub fn calcProtobufSize(self: *const ListSlice) usize {
                        var res: usize = 0;
                        if (self.start != 0) { res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.ListSelect.ListSelectItem.ListSliceWire.START_WIRE) + gremlin.sizes.sizeI32(self.start); }
                        if (self.end != 0) { res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.ListSelect.ListSelectItem.ListSliceWire.END_WIRE) + gremlin.sizes.sizeI32(self.end); }
                        return res;
                    }

                    pub fn encode(self: *const ListSlice, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                        const size = self.calcProtobufSize();
                        if (size == 0) {
                            return &[_]u8{};
                        }
                        const buf = try allocator.alloc(u8, self.calcProtobufSize());
                        var writer = gremlin.Writer.init(buf);
                        self.encodeTo(&writer);
                        return buf;
                    }


                    pub fn encodeTo(self: *const ListSlice, target: *gremlin.Writer) void {
                        if (self.start != 0) { target.appendInt32(Expression.MaskExpression.ListSelect.ListSelectItem.ListSliceWire.START_WIRE, self.start); }
                        if (self.end != 0) { target.appendInt32(Expression.MaskExpression.ListSelect.ListSelectItem.ListSliceWire.END_WIRE, self.end); }
                    }
                };
                
                pub const ListSliceReader = struct {
                    _start: i32 = 0,
                    _end: i32 = 0,

                    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ListSliceReader {
                        var buf = gremlin.Reader.init(src);
                        var res = ListSliceReader{};
                        if (buf.buf.len == 0) {
                            return res;
                        }
                        var offset: usize = 0;
                        while (buf.hasNext(offset, 0)) {
                            const tag = try buf.readTagAt(offset);
                            offset += tag.size;
                            switch (tag.number) {
                                Expression.MaskExpression.ListSelect.ListSelectItem.ListSliceWire.START_WIRE => {
                                  const result = try buf.readInt32(offset);
                                  offset += result.size;
                                  res._start = result.value;
                                },
                                Expression.MaskExpression.ListSelect.ListSelectItem.ListSliceWire.END_WIRE => {
                                  const result = try buf.readInt32(offset);
                                  offset += result.size;
                                  res._end = result.value;
                                },
                                else => {
                                    offset = try buf.skipData(offset, tag.wire);
                                }
                            }
                        }
                        return res;
                    }
                    pub fn deinit(_: *const ListSliceReader) void { }
                    
                    pub inline fn getStart(self: *const ListSliceReader) i32 { return self._start; }
                    pub inline fn getEnd(self: *const ListSliceReader) i32 { return self._end; }
                };
                
                // fields
                item: ?Expression.MaskExpression.ListSelect.ListSelectItem.ListElement = null,
                slice: ?Expression.MaskExpression.ListSelect.ListSelectItem.ListSlice = null,

                pub fn calcProtobufSize(self: *const ListSelectItem) usize {
                    var res: usize = 0;
                    if (self.item) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.ListSelect.ListSelectItemWire.ITEM_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                    }
                    if (self.slice) |v| {
                        const size = v.calcProtobufSize();
                        res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.ListSelect.ListSelectItemWire.SLICE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                    }
                    return res;
                }

                pub fn encode(self: *const ListSelectItem, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(self: *const ListSelectItem, target: *gremlin.Writer) void {
                    if (self.item) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.MaskExpression.ListSelect.ListSelectItemWire.ITEM_WIRE, size);
                        v.encodeTo(target);
                    }
                    if (self.slice) |v| {
                        const size = v.calcProtobufSize();
                        target.appendBytesTag(Expression.MaskExpression.ListSelect.ListSelectItemWire.SLICE_WIRE, size);
                        v.encodeTo(target);
                    }
                }
            };
            
            pub const ListSelectItemReader = struct {
                _item_buf: ?[]const u8 = null,
                _slice_buf: ?[]const u8 = null,

                pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ListSelectItemReader {
                    var buf = gremlin.Reader.init(src);
                    var res = ListSelectItemReader{};
                    if (buf.buf.len == 0) {
                        return res;
                    }
                    var offset: usize = 0;
                    while (buf.hasNext(offset, 0)) {
                        const tag = try buf.readTagAt(offset);
                        offset += tag.size;
                        switch (tag.number) {
                            Expression.MaskExpression.ListSelect.ListSelectItemWire.ITEM_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._item_buf = result.value;
                            },
                            Expression.MaskExpression.ListSelect.ListSelectItemWire.SLICE_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._slice_buf = result.value;
                            },
                            else => {
                                offset = try buf.skipData(offset, tag.wire);
                            }
                        }
                    }
                    return res;
                }
                pub fn deinit(_: *const ListSelectItemReader) void { }
                
                pub fn getItem(self: *const ListSelectItemReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpression.ListSelect.ListSelectItem.ListElementReader {
                    if (self._item_buf) |buf| {
                        return try Expression.MaskExpression.ListSelect.ListSelectItem.ListElementReader.init(allocator, buf);
                    }
                    return try Expression.MaskExpression.ListSelect.ListSelectItem.ListElementReader.init(allocator, &[_]u8{});
                }
                pub fn getSlice(self: *const ListSelectItemReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpression.ListSelect.ListSelectItem.ListSliceReader {
                    if (self._slice_buf) |buf| {
                        return try Expression.MaskExpression.ListSelect.ListSelectItem.ListSliceReader.init(allocator, buf);
                    }
                    return try Expression.MaskExpression.ListSelect.ListSelectItem.ListSliceReader.init(allocator, &[_]u8{});
                }
            };
            
            // fields
            selection: ?[]const ?Expression.MaskExpression.ListSelect.ListSelectItem = null,
            child: ?Expression.MaskExpression.Select = null,

            pub fn calcProtobufSize(self: *const ListSelect) usize {
                var res: usize = 0;
                if (self.selection) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.ListSelectWire.SELECTION_WIRE);
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            res += gremlin.sizes.sizeUsize(size) + size;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.ListSelectWire.CHILD_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const ListSelect, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const ListSelect, target: *gremlin.Writer) void {
                if (self.selection) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            target.appendBytesTag(Expression.MaskExpression.ListSelectWire.SELECTION_WIRE, size);
                            v.encodeTo(target);
                        } else {
                            target.appendBytesTag(Expression.MaskExpression.ListSelectWire.SELECTION_WIRE, 0);
                        }
                    }
                }
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.MaskExpression.ListSelectWire.CHILD_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const ListSelectReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _selection_bufs: ?std.ArrayList([]const u8) = null,
            _child_buf: ?[]const u8 = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!ListSelectReader {
                var buf = gremlin.Reader.init(src);
                var res = ListSelectReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.MaskExpression.ListSelectWire.SELECTION_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._selection_bufs == null) {
                                res._selection_bufs = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._selection_bufs.?.append(result.value);
                        },
                        Expression.MaskExpression.ListSelectWire.CHILD_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._child_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const ListSelectReader) void {
                if (self._selection_bufs) |arr| {
                    arr.deinit();
                }
            }
            pub fn getSelection(self: *const ListSelectReader, allocator: std.mem.Allocator) gremlin.Error![]Expression.MaskExpression.ListSelect.ListSelectItemReader {
                if (self._selection_bufs) |bufs| {
                    var result = try std.ArrayList(Expression.MaskExpression.ListSelect.ListSelectItemReader).initCapacity(allocator, bufs.items.len);
                    for (bufs.items) |buf| {
                        try result.append(try Expression.MaskExpression.ListSelect.ListSelectItemReader.init(allocator, buf));
                    }
                    return result.toOwnedSlice();
                }
                return &[_]Expression.MaskExpression.ListSelect.ListSelectItemReader{};
            }
            pub fn getChild(self: *const ListSelectReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpression.SelectReader {
                if (self._child_buf) |buf| {
                    return try Expression.MaskExpression.SelectReader.init(allocator, buf);
                }
                return try Expression.MaskExpression.SelectReader.init(allocator, &[_]u8{});
            }
        };
        
        const MapSelectWire = struct {
            const CHILD_WIRE: gremlin.ProtoWireNumber = 3;
            const KEY_WIRE: gremlin.ProtoWireNumber = 1;
            const EXPRESSION_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const MapSelect = struct {
            // nested structs
            const MapKeyWire = struct {
                const MAP_KEY_WIRE: gremlin.ProtoWireNumber = 1;
            };
            
            pub const MapKey = struct {
                // fields
                map_key: ?[]const u8 = null,

                pub fn calcProtobufSize(self: *const MapKey) usize {
                    var res: usize = 0;
                    if (self.map_key) |v| { res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.MapSelect.MapKeyWire.MAP_KEY_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                    return res;
                }

                pub fn encode(self: *const MapKey, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(self: *const MapKey, target: *gremlin.Writer) void {
                    if (self.map_key) |v| { target.appendBytes(Expression.MaskExpression.MapSelect.MapKeyWire.MAP_KEY_WIRE, v); }
                }
            };
            
            pub const MapKeyReader = struct {
                _map_key: ?[]const u8 = null,

                pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!MapKeyReader {
                    var buf = gremlin.Reader.init(src);
                    var res = MapKeyReader{};
                    if (buf.buf.len == 0) {
                        return res;
                    }
                    var offset: usize = 0;
                    while (buf.hasNext(offset, 0)) {
                        const tag = try buf.readTagAt(offset);
                        offset += tag.size;
                        switch (tag.number) {
                            Expression.MaskExpression.MapSelect.MapKeyWire.MAP_KEY_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._map_key = result.value;
                            },
                            else => {
                                offset = try buf.skipData(offset, tag.wire);
                            }
                        }
                    }
                    return res;
                }
                pub fn deinit(_: *const MapKeyReader) void { }
                
                pub inline fn getMapKey(self: *const MapKeyReader) []const u8 { return self._map_key orelse &[_]u8{}; }
            };
            
            const MapKeyExpressionWire = struct {
                const MAP_KEY_EXPRESSION_WIRE: gremlin.ProtoWireNumber = 1;
            };
            
            pub const MapKeyExpression = struct {
                // fields
                map_key_expression: ?[]const u8 = null,

                pub fn calcProtobufSize(self: *const MapKeyExpression) usize {
                    var res: usize = 0;
                    if (self.map_key_expression) |v| { res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.MapSelect.MapKeyExpressionWire.MAP_KEY_EXPRESSION_WIRE) + gremlin.sizes.sizeUsize(v.len) + v.len; }
                    return res;
                }

                pub fn encode(self: *const MapKeyExpression, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                    const size = self.calcProtobufSize();
                    if (size == 0) {
                        return &[_]u8{};
                    }
                    const buf = try allocator.alloc(u8, self.calcProtobufSize());
                    var writer = gremlin.Writer.init(buf);
                    self.encodeTo(&writer);
                    return buf;
                }


                pub fn encodeTo(self: *const MapKeyExpression, target: *gremlin.Writer) void {
                    if (self.map_key_expression) |v| { target.appendBytes(Expression.MaskExpression.MapSelect.MapKeyExpressionWire.MAP_KEY_EXPRESSION_WIRE, v); }
                }
            };
            
            pub const MapKeyExpressionReader = struct {
                _map_key_expression: ?[]const u8 = null,

                pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!MapKeyExpressionReader {
                    var buf = gremlin.Reader.init(src);
                    var res = MapKeyExpressionReader{};
                    if (buf.buf.len == 0) {
                        return res;
                    }
                    var offset: usize = 0;
                    while (buf.hasNext(offset, 0)) {
                        const tag = try buf.readTagAt(offset);
                        offset += tag.size;
                        switch (tag.number) {
                            Expression.MaskExpression.MapSelect.MapKeyExpressionWire.MAP_KEY_EXPRESSION_WIRE => {
                              const result = try buf.readBytes(offset);
                              offset += result.size;
                              res._map_key_expression = result.value;
                            },
                            else => {
                                offset = try buf.skipData(offset, tag.wire);
                            }
                        }
                    }
                    return res;
                }
                pub fn deinit(_: *const MapKeyExpressionReader) void { }
                
                pub inline fn getMapKeyExpression(self: *const MapKeyExpressionReader) []const u8 { return self._map_key_expression orelse &[_]u8{}; }
            };
            
            // fields
            child: ?Expression.MaskExpression.Select = null,
            key: ?Expression.MaskExpression.MapSelect.MapKey = null,
            expression: ?Expression.MaskExpression.MapSelect.MapKeyExpression = null,

            pub fn calcProtobufSize(self: *const MapSelect) usize {
                var res: usize = 0;
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.MapSelectWire.CHILD_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.key) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.MapSelectWire.KEY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.expression) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.MaskExpression.MapSelectWire.EXPRESSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const MapSelect, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const MapSelect, target: *gremlin.Writer) void {
                if (self.child) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.MaskExpression.MapSelectWire.CHILD_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.key) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.MaskExpression.MapSelectWire.KEY_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.expression) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.MaskExpression.MapSelectWire.EXPRESSION_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const MapSelectReader = struct {
            _child_buf: ?[]const u8 = null,
            _key_buf: ?[]const u8 = null,
            _expression_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!MapSelectReader {
                var buf = gremlin.Reader.init(src);
                var res = MapSelectReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.MaskExpression.MapSelectWire.CHILD_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._child_buf = result.value;
                        },
                        Expression.MaskExpression.MapSelectWire.KEY_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._key_buf = result.value;
                        },
                        Expression.MaskExpression.MapSelectWire.EXPRESSION_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._expression_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const MapSelectReader) void { }
            
            pub fn getChild(self: *const MapSelectReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpression.SelectReader {
                if (self._child_buf) |buf| {
                    return try Expression.MaskExpression.SelectReader.init(allocator, buf);
                }
                return try Expression.MaskExpression.SelectReader.init(allocator, &[_]u8{});
            }
            pub fn getKey(self: *const MapSelectReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpression.MapSelect.MapKeyReader {
                if (self._key_buf) |buf| {
                    return try Expression.MaskExpression.MapSelect.MapKeyReader.init(allocator, buf);
                }
                return try Expression.MaskExpression.MapSelect.MapKeyReader.init(allocator, &[_]u8{});
            }
            pub fn getExpression(self: *const MapSelectReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpression.MapSelect.MapKeyExpressionReader {
                if (self._expression_buf) |buf| {
                    return try Expression.MaskExpression.MapSelect.MapKeyExpressionReader.init(allocator, buf);
                }
                return try Expression.MaskExpression.MapSelect.MapKeyExpressionReader.init(allocator, &[_]u8{});
            }
        };
        
        // fields
        select: ?Expression.MaskExpression.StructSelect = null,
        maintain_singular_struct: bool = false,

        pub fn calcProtobufSize(self: *const MaskExpression) usize {
            var res: usize = 0;
            if (self.select) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.MaskExpressionWire.SELECT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.maintain_singular_struct != false) { res += gremlin.sizes.sizeWireNumber(Expression.MaskExpressionWire.MAINTAIN_SINGULAR_STRUCT_WIRE) + gremlin.sizes.sizeBool(self.maintain_singular_struct); }
            return res;
        }

        pub fn encode(self: *const MaskExpression, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const MaskExpression, target: *gremlin.Writer) void {
            if (self.select) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.MaskExpressionWire.SELECT_WIRE, size);
                v.encodeTo(target);
            }
            if (self.maintain_singular_struct != false) { target.appendBool(Expression.MaskExpressionWire.MAINTAIN_SINGULAR_STRUCT_WIRE, self.maintain_singular_struct); }
        }
    };
    
    pub const MaskExpressionReader = struct {
        _select_buf: ?[]const u8 = null,
        _maintain_singular_struct: bool = false,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!MaskExpressionReader {
            var buf = gremlin.Reader.init(src);
            var res = MaskExpressionReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.MaskExpressionWire.SELECT_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._select_buf = result.value;
                    },
                    Expression.MaskExpressionWire.MAINTAIN_SINGULAR_STRUCT_WIRE => {
                      const result = try buf.readBool(offset);
                      offset += result.size;
                      res._maintain_singular_struct = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const MaskExpressionReader) void { }
        
        pub fn getSelect(self: *const MaskExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpression.StructSelectReader {
            if (self._select_buf) |buf| {
                return try Expression.MaskExpression.StructSelectReader.init(allocator, buf);
            }
            return try Expression.MaskExpression.StructSelectReader.init(allocator, &[_]u8{});
        }
        pub inline fn getMaintainSingularStruct(self: *const MaskExpressionReader) bool { return self._maintain_singular_struct; }
    };
    
    const FieldReferenceWire = struct {
        const DIRECT_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
        const MASKED_REFERENCE_WIRE: gremlin.ProtoWireNumber = 2;
        const EXPRESSION_WIRE: gremlin.ProtoWireNumber = 3;
        const ROOT_REFERENCE_WIRE: gremlin.ProtoWireNumber = 4;
        const OUTER_REFERENCE_WIRE: gremlin.ProtoWireNumber = 5;
    };
    
    pub const FieldReference = struct {
        // nested structs
        pub const RootReference = struct {

            pub fn calcProtobufSize(_: *const RootReference) usize { return 0; }
            

            pub fn encode(self: *const RootReference, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(_: *const RootReference, _: *gremlin.Writer) void {}
            
        };
        
        pub const RootReferenceReader = struct {

            pub fn init(_: std.mem.Allocator, _: []const u8) gremlin.Error!RootReferenceReader {
                return RootReferenceReader{};
            }
            pub fn deinit(_: *const RootReferenceReader) void { }
            
        };
        
        const OuterReferenceWire = struct {
            const STEPS_OUT_WIRE: gremlin.ProtoWireNumber = 1;
        };
        
        pub const OuterReference = struct {
            // fields
            steps_out: u32 = 0,

            pub fn calcProtobufSize(self: *const OuterReference) usize {
                var res: usize = 0;
                if (self.steps_out != 0) { res += gremlin.sizes.sizeWireNumber(Expression.FieldReference.OuterReferenceWire.STEPS_OUT_WIRE) + gremlin.sizes.sizeU32(self.steps_out); }
                return res;
            }

            pub fn encode(self: *const OuterReference, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const OuterReference, target: *gremlin.Writer) void {
                if (self.steps_out != 0) { target.appendUint32(Expression.FieldReference.OuterReferenceWire.STEPS_OUT_WIRE, self.steps_out); }
            }
        };
        
        pub const OuterReferenceReader = struct {
            _steps_out: u32 = 0,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!OuterReferenceReader {
                var buf = gremlin.Reader.init(src);
                var res = OuterReferenceReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.FieldReference.OuterReferenceWire.STEPS_OUT_WIRE => {
                          const result = try buf.readUInt32(offset);
                          offset += result.size;
                          res._steps_out = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const OuterReferenceReader) void { }
            
            pub inline fn getStepsOut(self: *const OuterReferenceReader) u32 { return self._steps_out; }
        };
        
        // fields
        direct_reference: ?Expression.ReferenceSegment = null,
        masked_reference: ?Expression.MaskExpression = null,
        expression: ?Expression = null,
        root_reference: ?Expression.FieldReference.RootReference = null,
        outer_reference: ?Expression.FieldReference.OuterReference = null,

        pub fn calcProtobufSize(self: *const FieldReference) usize {
            var res: usize = 0;
            if (self.direct_reference) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.FieldReferenceWire.DIRECT_REFERENCE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.masked_reference) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.FieldReferenceWire.MASKED_REFERENCE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.expression) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.FieldReferenceWire.EXPRESSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.root_reference) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.FieldReferenceWire.ROOT_REFERENCE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.outer_reference) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.FieldReferenceWire.OUTER_REFERENCE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const FieldReference, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const FieldReference, target: *gremlin.Writer) void {
            if (self.direct_reference) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.FieldReferenceWire.DIRECT_REFERENCE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.masked_reference) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.FieldReferenceWire.MASKED_REFERENCE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.expression) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.FieldReferenceWire.EXPRESSION_WIRE, size);
                v.encodeTo(target);
            }
            if (self.root_reference) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.FieldReferenceWire.ROOT_REFERENCE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.outer_reference) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.FieldReferenceWire.OUTER_REFERENCE_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const FieldReferenceReader = struct {
        _direct_reference_buf: ?[]const u8 = null,
        _masked_reference_buf: ?[]const u8 = null,
        _expression_buf: ?[]const u8 = null,
        _root_reference_buf: ?[]const u8 = null,
        _outer_reference_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!FieldReferenceReader {
            var buf = gremlin.Reader.init(src);
            var res = FieldReferenceReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.FieldReferenceWire.DIRECT_REFERENCE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._direct_reference_buf = result.value;
                    },
                    Expression.FieldReferenceWire.MASKED_REFERENCE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._masked_reference_buf = result.value;
                    },
                    Expression.FieldReferenceWire.EXPRESSION_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._expression_buf = result.value;
                    },
                    Expression.FieldReferenceWire.ROOT_REFERENCE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._root_reference_buf = result.value;
                    },
                    Expression.FieldReferenceWire.OUTER_REFERENCE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._outer_reference_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const FieldReferenceReader) void { }
        
        pub fn getDirectReference(self: *const FieldReferenceReader, allocator: std.mem.Allocator) gremlin.Error!Expression.ReferenceSegmentReader {
            if (self._direct_reference_buf) |buf| {
                return try Expression.ReferenceSegmentReader.init(allocator, buf);
            }
            return try Expression.ReferenceSegmentReader.init(allocator, &[_]u8{});
        }
        pub fn getMaskedReference(self: *const FieldReferenceReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MaskExpressionReader {
            if (self._masked_reference_buf) |buf| {
                return try Expression.MaskExpressionReader.init(allocator, buf);
            }
            return try Expression.MaskExpressionReader.init(allocator, &[_]u8{});
        }
        pub fn getExpression(self: *const FieldReferenceReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
            if (self._expression_buf) |buf| {
                return try ExpressionReader.init(allocator, buf);
            }
            return try ExpressionReader.init(allocator, &[_]u8{});
        }
        pub fn getRootReference(self: *const FieldReferenceReader, allocator: std.mem.Allocator) gremlin.Error!Expression.FieldReference.RootReferenceReader {
            if (self._root_reference_buf) |buf| {
                return try Expression.FieldReference.RootReferenceReader.init(allocator, buf);
            }
            return try Expression.FieldReference.RootReferenceReader.init(allocator, &[_]u8{});
        }
        pub fn getOuterReference(self: *const FieldReferenceReader, allocator: std.mem.Allocator) gremlin.Error!Expression.FieldReference.OuterReferenceReader {
            if (self._outer_reference_buf) |buf| {
                return try Expression.FieldReference.OuterReferenceReader.init(allocator, buf);
            }
            return try Expression.FieldReference.OuterReferenceReader.init(allocator, &[_]u8{});
        }
    };
    
    const SubqueryWire = struct {
        const SCALAR_WIRE: gremlin.ProtoWireNumber = 1;
        const IN_PREDICATE_WIRE: gremlin.ProtoWireNumber = 2;
        const SET_PREDICATE_WIRE: gremlin.ProtoWireNumber = 3;
        const SET_COMPARISON_WIRE: gremlin.ProtoWireNumber = 4;
    };
    
    pub const Subquery = struct {
        // nested structs
        const ScalarWire = struct {
            const INPUT_WIRE: gremlin.ProtoWireNumber = 1;
        };
        
        pub const Scalar = struct {
            // fields
            input: ?Rel = null,

            pub fn calcProtobufSize(self: *const Scalar) usize {
                var res: usize = 0;
                if (self.input) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.Subquery.ScalarWire.INPUT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
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
                if (self.input) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.Subquery.ScalarWire.INPUT_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const ScalarReader = struct {
            _input_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ScalarReader {
                var buf = gremlin.Reader.init(src);
                var res = ScalarReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Subquery.ScalarWire.INPUT_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._input_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const ScalarReader) void { }
            
            pub fn getInput(self: *const ScalarReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
                if (self._input_buf) |buf| {
                    return try RelReader.init(allocator, buf);
                }
                return try RelReader.init(allocator, &[_]u8{});
            }
        };
        
        const InPredicateWire = struct {
            const NEEDLES_WIRE: gremlin.ProtoWireNumber = 1;
            const HAYSTACK_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const InPredicate = struct {
            // fields
            needles: ?[]const ?Expression = null,
            haystack: ?Rel = null,

            pub fn calcProtobufSize(self: *const InPredicate) usize {
                var res: usize = 0;
                if (self.needles) |arr| {
                    for (arr) |maybe_v| {
                        res += gremlin.sizes.sizeWireNumber(Expression.Subquery.InPredicateWire.NEEDLES_WIRE);
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            res += gremlin.sizes.sizeUsize(size) + size;
                        } else {
                            res += gremlin.sizes.sizeUsize(0);
                        }
                    }
                }
                if (self.haystack) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.Subquery.InPredicateWire.HAYSTACK_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const InPredicate, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const InPredicate, target: *gremlin.Writer) void {
                if (self.needles) |arr| {
                    for (arr) |maybe_v| {
                        if (maybe_v) |v| {
                            const size = v.calcProtobufSize();
                            target.appendBytesTag(Expression.Subquery.InPredicateWire.NEEDLES_WIRE, size);
                            v.encodeTo(target);
                        } else {
                            target.appendBytesTag(Expression.Subquery.InPredicateWire.NEEDLES_WIRE, 0);
                        }
                    }
                }
                if (self.haystack) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.Subquery.InPredicateWire.HAYSTACK_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const InPredicateReader = struct {
            allocator: std.mem.Allocator,
            buf: gremlin.Reader,
            _needles_bufs: ?std.ArrayList([]const u8) = null,
            _haystack_buf: ?[]const u8 = null,

            pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!InPredicateReader {
                var buf = gremlin.Reader.init(src);
                var res = InPredicateReader{.allocator = allocator, .buf = buf};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Subquery.InPredicateWire.NEEDLES_WIRE => {
                            const result = try buf.readBytes(offset);
                            offset += result.size;
                            if (res._needles_bufs == null) {
                                res._needles_bufs = std.ArrayList([]const u8).init(allocator);
                            }
                            try res._needles_bufs.?.append(result.value);
                        },
                        Expression.Subquery.InPredicateWire.HAYSTACK_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._haystack_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(self: *const InPredicateReader) void {
                if (self._needles_bufs) |arr| {
                    arr.deinit();
                }
            }
            pub fn getNeedles(self: *const InPredicateReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
                if (self._needles_bufs) |bufs| {
                    var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
                    for (bufs.items) |buf| {
                        try result.append(try ExpressionReader.init(allocator, buf));
                    }
                    return result.toOwnedSlice();
                }
                return &[_]ExpressionReader{};
            }
            pub fn getHaystack(self: *const InPredicateReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
                if (self._haystack_buf) |buf| {
                    return try RelReader.init(allocator, buf);
                }
                return try RelReader.init(allocator, &[_]u8{});
            }
        };
        
        const SetPredicateWire = struct {
            const PREDICATE_OP_WIRE: gremlin.ProtoWireNumber = 1;
            const TUPLES_WIRE: gremlin.ProtoWireNumber = 2;
        };
        
        pub const SetPredicate = struct {
            // nested enums
            pub const PredicateOp = enum(i32) {
                PREDICATE_OP_UNSPECIFIED = 0,
                PREDICATE_OP_EXISTS = 1,
                PREDICATE_OP_UNIQUE = 2,
            };
            
            // fields
            predicate_op: Expression.Subquery.SetPredicate.PredicateOp = @enumFromInt(0),
            tuples: ?Rel = null,

            pub fn calcProtobufSize(self: *const SetPredicate) usize {
                var res: usize = 0;
                if (@intFromEnum(self.predicate_op) != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Subquery.SetPredicateWire.PREDICATE_OP_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.predicate_op)); }
                if (self.tuples) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.Subquery.SetPredicateWire.TUPLES_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const SetPredicate, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const SetPredicate, target: *gremlin.Writer) void {
                if (@intFromEnum(self.predicate_op) != 0) { target.appendInt32(Expression.Subquery.SetPredicateWire.PREDICATE_OP_WIRE, @intFromEnum(self.predicate_op)); }
                if (self.tuples) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.Subquery.SetPredicateWire.TUPLES_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const SetPredicateReader = struct {
            _predicate_op: Expression.Subquery.SetPredicate.PredicateOp = @enumFromInt(0),
            _tuples_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!SetPredicateReader {
                var buf = gremlin.Reader.init(src);
                var res = SetPredicateReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Subquery.SetPredicateWire.PREDICATE_OP_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._predicate_op = @enumFromInt(result.value);
                        },
                        Expression.Subquery.SetPredicateWire.TUPLES_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._tuples_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const SetPredicateReader) void { }
            
            pub inline fn getPredicateOp(self: *const SetPredicateReader) Expression.Subquery.SetPredicate.PredicateOp { return self._predicate_op; }
            pub fn getTuples(self: *const SetPredicateReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
                if (self._tuples_buf) |buf| {
                    return try RelReader.init(allocator, buf);
                }
                return try RelReader.init(allocator, &[_]u8{});
            }
        };
        
        const SetComparisonWire = struct {
            const REDUCTION_OP_WIRE: gremlin.ProtoWireNumber = 1;
            const COMPARISON_OP_WIRE: gremlin.ProtoWireNumber = 2;
            const LEFT_WIRE: gremlin.ProtoWireNumber = 3;
            const RIGHT_WIRE: gremlin.ProtoWireNumber = 4;
        };
        
        pub const SetComparison = struct {
            // nested enums
            pub const ComparisonOp = enum(i32) {
                COMPARISON_OP_UNSPECIFIED = 0,
                COMPARISON_OP_EQ = 1,
                COMPARISON_OP_NE = 2,
                COMPARISON_OP_LT = 3,
                COMPARISON_OP_GT = 4,
                COMPARISON_OP_LE = 5,
                COMPARISON_OP_GE = 6,
            };
            
            pub const ReductionOp = enum(i32) {
                REDUCTION_OP_UNSPECIFIED = 0,
                REDUCTION_OP_ANY = 1,
                REDUCTION_OP_ALL = 2,
            };
            
            // fields
            reduction_op: Expression.Subquery.SetComparison.ReductionOp = @enumFromInt(0),
            comparison_op: Expression.Subquery.SetComparison.ComparisonOp = @enumFromInt(0),
            left: ?Expression = null,
            right: ?Rel = null,

            pub fn calcProtobufSize(self: *const SetComparison) usize {
                var res: usize = 0;
                if (@intFromEnum(self.reduction_op) != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Subquery.SetComparisonWire.REDUCTION_OP_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.reduction_op)); }
                if (@intFromEnum(self.comparison_op) != 0) { res += gremlin.sizes.sizeWireNumber(Expression.Subquery.SetComparisonWire.COMPARISON_OP_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.comparison_op)); }
                if (self.left) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.Subquery.SetComparisonWire.LEFT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                if (self.right) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeWireNumber(Expression.Subquery.SetComparisonWire.RIGHT_WIRE) + gremlin.sizes.sizeUsize(size) + size;
                }
                return res;
            }

            pub fn encode(self: *const SetComparison, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
                const size = self.calcProtobufSize();
                if (size == 0) {
                    return &[_]u8{};
                }
                const buf = try allocator.alloc(u8, self.calcProtobufSize());
                var writer = gremlin.Writer.init(buf);
                self.encodeTo(&writer);
                return buf;
            }


            pub fn encodeTo(self: *const SetComparison, target: *gremlin.Writer) void {
                if (@intFromEnum(self.reduction_op) != 0) { target.appendInt32(Expression.Subquery.SetComparisonWire.REDUCTION_OP_WIRE, @intFromEnum(self.reduction_op)); }
                if (@intFromEnum(self.comparison_op) != 0) { target.appendInt32(Expression.Subquery.SetComparisonWire.COMPARISON_OP_WIRE, @intFromEnum(self.comparison_op)); }
                if (self.left) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.Subquery.SetComparisonWire.LEFT_WIRE, size);
                    v.encodeTo(target);
                }
                if (self.right) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(Expression.Subquery.SetComparisonWire.RIGHT_WIRE, size);
                    v.encodeTo(target);
                }
            }
        };
        
        pub const SetComparisonReader = struct {
            _reduction_op: Expression.Subquery.SetComparison.ReductionOp = @enumFromInt(0),
            _comparison_op: Expression.Subquery.SetComparison.ComparisonOp = @enumFromInt(0),
            _left_buf: ?[]const u8 = null,
            _right_buf: ?[]const u8 = null,

            pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!SetComparisonReader {
                var buf = gremlin.Reader.init(src);
                var res = SetComparisonReader{};
                if (buf.buf.len == 0) {
                    return res;
                }
                var offset: usize = 0;
                while (buf.hasNext(offset, 0)) {
                    const tag = try buf.readTagAt(offset);
                    offset += tag.size;
                    switch (tag.number) {
                        Expression.Subquery.SetComparisonWire.REDUCTION_OP_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._reduction_op = @enumFromInt(result.value);
                        },
                        Expression.Subquery.SetComparisonWire.COMPARISON_OP_WIRE => {
                          const result = try buf.readInt32(offset);
                          offset += result.size;
                          res._comparison_op = @enumFromInt(result.value);
                        },
                        Expression.Subquery.SetComparisonWire.LEFT_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._left_buf = result.value;
                        },
                        Expression.Subquery.SetComparisonWire.RIGHT_WIRE => {
                          const result = try buf.readBytes(offset);
                          offset += result.size;
                          res._right_buf = result.value;
                        },
                        else => {
                            offset = try buf.skipData(offset, tag.wire);
                        }
                    }
                }
                return res;
            }
            pub fn deinit(_: *const SetComparisonReader) void { }
            
            pub inline fn getReductionOp(self: *const SetComparisonReader) Expression.Subquery.SetComparison.ReductionOp { return self._reduction_op; }
            pub inline fn getComparisonOp(self: *const SetComparisonReader) Expression.Subquery.SetComparison.ComparisonOp { return self._comparison_op; }
            pub fn getLeft(self: *const SetComparisonReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
                if (self._left_buf) |buf| {
                    return try ExpressionReader.init(allocator, buf);
                }
                return try ExpressionReader.init(allocator, &[_]u8{});
            }
            pub fn getRight(self: *const SetComparisonReader, allocator: std.mem.Allocator) gremlin.Error!RelReader {
                if (self._right_buf) |buf| {
                    return try RelReader.init(allocator, buf);
                }
                return try RelReader.init(allocator, &[_]u8{});
            }
        };
        
        // fields
        scalar: ?Expression.Subquery.Scalar = null,
        in_predicate: ?Expression.Subquery.InPredicate = null,
        set_predicate: ?Expression.Subquery.SetPredicate = null,
        set_comparison: ?Expression.Subquery.SetComparison = null,

        pub fn calcProtobufSize(self: *const Subquery) usize {
            var res: usize = 0;
            if (self.scalar) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.SubqueryWire.SCALAR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.in_predicate) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.SubqueryWire.IN_PREDICATE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.set_predicate) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.SubqueryWire.SET_PREDICATE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            if (self.set_comparison) |v| {
                const size = v.calcProtobufSize();
                res += gremlin.sizes.sizeWireNumber(Expression.SubqueryWire.SET_COMPARISON_WIRE) + gremlin.sizes.sizeUsize(size) + size;
            }
            return res;
        }

        pub fn encode(self: *const Subquery, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
            const size = self.calcProtobufSize();
            if (size == 0) {
                return &[_]u8{};
            }
            const buf = try allocator.alloc(u8, self.calcProtobufSize());
            var writer = gremlin.Writer.init(buf);
            self.encodeTo(&writer);
            return buf;
        }


        pub fn encodeTo(self: *const Subquery, target: *gremlin.Writer) void {
            if (self.scalar) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.SubqueryWire.SCALAR_WIRE, size);
                v.encodeTo(target);
            }
            if (self.in_predicate) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.SubqueryWire.IN_PREDICATE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.set_predicate) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.SubqueryWire.SET_PREDICATE_WIRE, size);
                v.encodeTo(target);
            }
            if (self.set_comparison) |v| {
                const size = v.calcProtobufSize();
                target.appendBytesTag(Expression.SubqueryWire.SET_COMPARISON_WIRE, size);
                v.encodeTo(target);
            }
        }
    };
    
    pub const SubqueryReader = struct {
        _scalar_buf: ?[]const u8 = null,
        _in_predicate_buf: ?[]const u8 = null,
        _set_predicate_buf: ?[]const u8 = null,
        _set_comparison_buf: ?[]const u8 = null,

        pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!SubqueryReader {
            var buf = gremlin.Reader.init(src);
            var res = SubqueryReader{};
            if (buf.buf.len == 0) {
                return res;
            }
            var offset: usize = 0;
            while (buf.hasNext(offset, 0)) {
                const tag = try buf.readTagAt(offset);
                offset += tag.size;
                switch (tag.number) {
                    Expression.SubqueryWire.SCALAR_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._scalar_buf = result.value;
                    },
                    Expression.SubqueryWire.IN_PREDICATE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._in_predicate_buf = result.value;
                    },
                    Expression.SubqueryWire.SET_PREDICATE_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._set_predicate_buf = result.value;
                    },
                    Expression.SubqueryWire.SET_COMPARISON_WIRE => {
                      const result = try buf.readBytes(offset);
                      offset += result.size;
                      res._set_comparison_buf = result.value;
                    },
                    else => {
                        offset = try buf.skipData(offset, tag.wire);
                    }
                }
            }
            return res;
        }
        pub fn deinit(_: *const SubqueryReader) void { }
        
        pub fn getScalar(self: *const SubqueryReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Subquery.ScalarReader {
            if (self._scalar_buf) |buf| {
                return try Expression.Subquery.ScalarReader.init(allocator, buf);
            }
            return try Expression.Subquery.ScalarReader.init(allocator, &[_]u8{});
        }
        pub fn getInPredicate(self: *const SubqueryReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Subquery.InPredicateReader {
            if (self._in_predicate_buf) |buf| {
                return try Expression.Subquery.InPredicateReader.init(allocator, buf);
            }
            return try Expression.Subquery.InPredicateReader.init(allocator, &[_]u8{});
        }
        pub fn getSetPredicate(self: *const SubqueryReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Subquery.SetPredicateReader {
            if (self._set_predicate_buf) |buf| {
                return try Expression.Subquery.SetPredicateReader.init(allocator, buf);
            }
            return try Expression.Subquery.SetPredicateReader.init(allocator, &[_]u8{});
        }
        pub fn getSetComparison(self: *const SubqueryReader, allocator: std.mem.Allocator) gremlin.Error!Expression.Subquery.SetComparisonReader {
            if (self._set_comparison_buf) |buf| {
                return try Expression.Subquery.SetComparisonReader.init(allocator, buf);
            }
            return try Expression.Subquery.SetComparisonReader.init(allocator, &[_]u8{});
        }
    };
    
    // fields
    literal: ?Expression.Literal = null,
    selection: ?Expression.FieldReference = null,
    scalar_function: ?Expression.ScalarFunction = null,
    window_function: ?Expression.WindowFunction = null,
    if_then: ?Expression.IfThen = null,
    switch_expression: ?Expression.SwitchExpression = null,
    singular_or_list: ?Expression.SingularOrList = null,
    multi_or_list: ?Expression.MultiOrList = null,
    cast: ?Expression.Cast = null,
    subquery: ?Expression.Subquery = null,
    nested: ?Expression.Nested = null,
    enum_: ?Expression.Enum = null,

    pub fn calcProtobufSize(self: *const Expression) usize {
        var res: usize = 0;
        if (self.literal) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.LITERAL_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.selection) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.SELECTION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.scalar_function) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.SCALAR_FUNCTION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.window_function) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.WINDOW_FUNCTION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.if_then) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.IF_THEN_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.switch_expression) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.SWITCH_EXPRESSION_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.singular_or_list) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.SINGULAR_OR_LIST_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.multi_or_list) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.MULTI_OR_LIST_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.cast) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.CAST_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.subquery) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.SUBQUERY_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.nested) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.NESTED_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (self.enum_) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(ExpressionWire.ENUM_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        return res;
    }

    pub fn encode(self: *const Expression, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const Expression, target: *gremlin.Writer) void {
        if (self.literal) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.LITERAL_WIRE, size);
            v.encodeTo(target);
        }
        if (self.selection) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.SELECTION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.scalar_function) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.SCALAR_FUNCTION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.window_function) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.WINDOW_FUNCTION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.if_then) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.IF_THEN_WIRE, size);
            v.encodeTo(target);
        }
        if (self.switch_expression) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.SWITCH_EXPRESSION_WIRE, size);
            v.encodeTo(target);
        }
        if (self.singular_or_list) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.SINGULAR_OR_LIST_WIRE, size);
            v.encodeTo(target);
        }
        if (self.multi_or_list) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.MULTI_OR_LIST_WIRE, size);
            v.encodeTo(target);
        }
        if (self.cast) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.CAST_WIRE, size);
            v.encodeTo(target);
        }
        if (self.subquery) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.SUBQUERY_WIRE, size);
            v.encodeTo(target);
        }
        if (self.nested) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.NESTED_WIRE, size);
            v.encodeTo(target);
        }
        if (self.enum_) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(ExpressionWire.ENUM_WIRE, size);
            v.encodeTo(target);
        }
    }
};

pub const ExpressionReader = struct {
    _literal_buf: ?[]const u8 = null,
    _selection_buf: ?[]const u8 = null,
    _scalar_function_buf: ?[]const u8 = null,
    _window_function_buf: ?[]const u8 = null,
    _if_then_buf: ?[]const u8 = null,
    _switch_expression_buf: ?[]const u8 = null,
    _singular_or_list_buf: ?[]const u8 = null,
    _multi_or_list_buf: ?[]const u8 = null,
    _cast_buf: ?[]const u8 = null,
    _subquery_buf: ?[]const u8 = null,
    _nested_buf: ?[]const u8 = null,
    _enum__buf: ?[]const u8 = null,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ExpressionReader {
        var buf = gremlin.Reader.init(src);
        var res = ExpressionReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ExpressionWire.LITERAL_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._literal_buf = result.value;
                },
                ExpressionWire.SELECTION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._selection_buf = result.value;
                },
                ExpressionWire.SCALAR_FUNCTION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._scalar_function_buf = result.value;
                },
                ExpressionWire.WINDOW_FUNCTION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._window_function_buf = result.value;
                },
                ExpressionWire.IF_THEN_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._if_then_buf = result.value;
                },
                ExpressionWire.SWITCH_EXPRESSION_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._switch_expression_buf = result.value;
                },
                ExpressionWire.SINGULAR_OR_LIST_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._singular_or_list_buf = result.value;
                },
                ExpressionWire.MULTI_OR_LIST_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._multi_or_list_buf = result.value;
                },
                ExpressionWire.CAST_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._cast_buf = result.value;
                },
                ExpressionWire.SUBQUERY_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._subquery_buf = result.value;
                },
                ExpressionWire.NESTED_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._nested_buf = result.value;
                },
                ExpressionWire.ENUM_WIRE => {
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
    pub fn deinit(_: *const ExpressionReader) void { }
    
    pub fn getLiteral(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.LiteralReader {
        if (self._literal_buf) |buf| {
            return try Expression.LiteralReader.init(allocator, buf);
        }
        return try Expression.LiteralReader.init(allocator, &[_]u8{});
    }
    pub fn getSelection(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.FieldReferenceReader {
        if (self._selection_buf) |buf| {
            return try Expression.FieldReferenceReader.init(allocator, buf);
        }
        return try Expression.FieldReferenceReader.init(allocator, &[_]u8{});
    }
    pub fn getScalarFunction(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.ScalarFunctionReader {
        if (self._scalar_function_buf) |buf| {
            return try Expression.ScalarFunctionReader.init(allocator, buf);
        }
        return try Expression.ScalarFunctionReader.init(allocator, &[_]u8{});
    }
    pub fn getWindowFunction(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.WindowFunctionReader {
        if (self._window_function_buf) |buf| {
            return try Expression.WindowFunctionReader.init(allocator, buf);
        }
        return try Expression.WindowFunctionReader.init(allocator, &[_]u8{});
    }
    pub fn getIfThen(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.IfThenReader {
        if (self._if_then_buf) |buf| {
            return try Expression.IfThenReader.init(allocator, buf);
        }
        return try Expression.IfThenReader.init(allocator, &[_]u8{});
    }
    pub fn getSwitchExpression(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.SwitchExpressionReader {
        if (self._switch_expression_buf) |buf| {
            return try Expression.SwitchExpressionReader.init(allocator, buf);
        }
        return try Expression.SwitchExpressionReader.init(allocator, &[_]u8{});
    }
    pub fn getSingularOrList(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.SingularOrListReader {
        if (self._singular_or_list_buf) |buf| {
            return try Expression.SingularOrListReader.init(allocator, buf);
        }
        return try Expression.SingularOrListReader.init(allocator, &[_]u8{});
    }
    pub fn getMultiOrList(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.MultiOrListReader {
        if (self._multi_or_list_buf) |buf| {
            return try Expression.MultiOrListReader.init(allocator, buf);
        }
        return try Expression.MultiOrListReader.init(allocator, &[_]u8{});
    }
    pub fn getCast(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.CastReader {
        if (self._cast_buf) |buf| {
            return try Expression.CastReader.init(allocator, buf);
        }
        return try Expression.CastReader.init(allocator, &[_]u8{});
    }
    pub fn getSubquery(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.SubqueryReader {
        if (self._subquery_buf) |buf| {
            return try Expression.SubqueryReader.init(allocator, buf);
        }
        return try Expression.SubqueryReader.init(allocator, &[_]u8{});
    }
    pub fn getNested(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.NestedReader {
        if (self._nested_buf) |buf| {
            return try Expression.NestedReader.init(allocator, buf);
        }
        return try Expression.NestedReader.init(allocator, &[_]u8{});
    }
    pub fn getEnum(self: *const ExpressionReader, allocator: std.mem.Allocator) gremlin.Error!Expression.EnumReader {
        if (self._enum__buf) |buf| {
            return try Expression.EnumReader.init(allocator, buf);
        }
        return try Expression.EnumReader.init(allocator, &[_]u8{});
    }
};

const SortFieldWire = struct {
    const EXPR_WIRE: gremlin.ProtoWireNumber = 1;
    const DIRECTION_WIRE: gremlin.ProtoWireNumber = 2;
    const COMPARISON_FUNCTION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 3;
};

pub const SortField = struct {
    // nested enums
    pub const SortDirection = enum(i32) {
        SORT_DIRECTION_UNSPECIFIED = 0,
        SORT_DIRECTION_ASC_NULLS_FIRST = 1,
        SORT_DIRECTION_ASC_NULLS_LAST = 2,
        SORT_DIRECTION_DESC_NULLS_FIRST = 3,
        SORT_DIRECTION_DESC_NULLS_LAST = 4,
        SORT_DIRECTION_CLUSTERED = 5,
    };
    
    // fields
    expr: ?Expression = null,
    direction: SortField.SortDirection = @enumFromInt(0),
    comparison_function_reference: u32 = 0,

    pub fn calcProtobufSize(self: *const SortField) usize {
        var res: usize = 0;
        if (self.expr) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(SortFieldWire.EXPR_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (@intFromEnum(self.direction) != 0) { res += gremlin.sizes.sizeWireNumber(SortFieldWire.DIRECTION_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.direction)); }
        if (self.comparison_function_reference != 0) { res += gremlin.sizes.sizeWireNumber(SortFieldWire.COMPARISON_FUNCTION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.comparison_function_reference); }
        return res;
    }

    pub fn encode(self: *const SortField, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const SortField, target: *gremlin.Writer) void {
        if (self.expr) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(SortFieldWire.EXPR_WIRE, size);
            v.encodeTo(target);
        }
        if (@intFromEnum(self.direction) != 0) { target.appendInt32(SortFieldWire.DIRECTION_WIRE, @intFromEnum(self.direction)); }
        if (self.comparison_function_reference != 0) { target.appendUint32(SortFieldWire.COMPARISON_FUNCTION_REFERENCE_WIRE, self.comparison_function_reference); }
    }
};

pub const SortFieldReader = struct {
    _expr_buf: ?[]const u8 = null,
    _direction: SortField.SortDirection = @enumFromInt(0),
    _comparison_function_reference: u32 = 0,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!SortFieldReader {
        var buf = gremlin.Reader.init(src);
        var res = SortFieldReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                SortFieldWire.EXPR_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._expr_buf = result.value;
                },
                SortFieldWire.DIRECTION_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._direction = @enumFromInt(result.value);
                },
                SortFieldWire.COMPARISON_FUNCTION_REFERENCE_WIRE => {
                  const result = try buf.readUInt32(offset);
                  offset += result.size;
                  res._comparison_function_reference = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const SortFieldReader) void { }
    
    pub fn getExpr(self: *const SortFieldReader, allocator: std.mem.Allocator) gremlin.Error!ExpressionReader {
        if (self._expr_buf) |buf| {
            return try ExpressionReader.init(allocator, buf);
        }
        return try ExpressionReader.init(allocator, &[_]u8{});
    }
    pub inline fn getDirection(self: *const SortFieldReader) SortField.SortDirection { return self._direction; }
    pub inline fn getComparisonFunctionReference(self: *const SortFieldReader) u32 { return self._comparison_function_reference; }
};

const AggregateFunctionWire = struct {
    const FUNCTION_REFERENCE_WIRE: gremlin.ProtoWireNumber = 1;
    const ARGUMENTS_WIRE: gremlin.ProtoWireNumber = 7;
    const OPTIONS_WIRE: gremlin.ProtoWireNumber = 8;
    const OUTPUT_TYPE_WIRE: gremlin.ProtoWireNumber = 5;
    const PHASE_WIRE: gremlin.ProtoWireNumber = 4;
    const SORTS_WIRE: gremlin.ProtoWireNumber = 3;
    const INVOCATION_WIRE: gremlin.ProtoWireNumber = 6;
    const ARGS_WIRE: gremlin.ProtoWireNumber = 2;
};

pub const AggregateFunction = struct {
    // nested enums
    pub const AggregationInvocation = enum(i32) {
        AGGREGATION_INVOCATION_UNSPECIFIED = 0,
        AGGREGATION_INVOCATION_ALL = 1,
        AGGREGATION_INVOCATION_DISTINCT = 2,
    };
    
    // fields
    function_reference: u32 = 0,
    arguments: ?[]const ?FunctionArgument = null,
    options: ?[]const ?FunctionOption = null,
    output_type: ?type.Type = null,
    phase: AggregationPhase = @enumFromInt(0),
    sorts: ?[]const ?SortField = null,
    invocation: AggregateFunction.AggregationInvocation = @enumFromInt(0),
    args: ?[]const ?Expression = null,

    pub fn calcProtobufSize(self: *const AggregateFunction) usize {
        var res: usize = 0;
        if (self.function_reference != 0) { res += gremlin.sizes.sizeWireNumber(AggregateFunctionWire.FUNCTION_REFERENCE_WIRE) + gremlin.sizes.sizeU32(self.function_reference); }
        if (self.arguments) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(AggregateFunctionWire.ARGUMENTS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.options) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(AggregateFunctionWire.OPTIONS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (self.output_type) |v| {
            const size = v.calcProtobufSize();
            res += gremlin.sizes.sizeWireNumber(AggregateFunctionWire.OUTPUT_TYPE_WIRE) + gremlin.sizes.sizeUsize(size) + size;
        }
        if (@intFromEnum(self.phase) != 0) { res += gremlin.sizes.sizeWireNumber(AggregateFunctionWire.PHASE_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.phase)); }
        if (self.sorts) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(AggregateFunctionWire.SORTS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        if (@intFromEnum(self.invocation) != 0) { res += gremlin.sizes.sizeWireNumber(AggregateFunctionWire.INVOCATION_WIRE) + gremlin.sizes.sizeI32(@intFromEnum(self.invocation)); }
        if (self.args) |arr| {
            for (arr) |maybe_v| {
                res += gremlin.sizes.sizeWireNumber(AggregateFunctionWire.ARGS_WIRE);
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    res += gremlin.sizes.sizeUsize(size) + size;
                } else {
                    res += gremlin.sizes.sizeUsize(0);
                }
            }
        }
        return res;
    }

    pub fn encode(self: *const AggregateFunction, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const AggregateFunction, target: *gremlin.Writer) void {
        if (self.function_reference != 0) { target.appendUint32(AggregateFunctionWire.FUNCTION_REFERENCE_WIRE, self.function_reference); }
        if (self.arguments) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(AggregateFunctionWire.ARGUMENTS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(AggregateFunctionWire.ARGUMENTS_WIRE, 0);
                }
            }
        }
        if (self.options) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(AggregateFunctionWire.OPTIONS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(AggregateFunctionWire.OPTIONS_WIRE, 0);
                }
            }
        }
        if (self.output_type) |v| {
            const size = v.calcProtobufSize();
            target.appendBytesTag(AggregateFunctionWire.OUTPUT_TYPE_WIRE, size);
            v.encodeTo(target);
        }
        if (@intFromEnum(self.phase) != 0) { target.appendInt32(AggregateFunctionWire.PHASE_WIRE, @intFromEnum(self.phase)); }
        if (self.sorts) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(AggregateFunctionWire.SORTS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(AggregateFunctionWire.SORTS_WIRE, 0);
                }
            }
        }
        if (@intFromEnum(self.invocation) != 0) { target.appendInt32(AggregateFunctionWire.INVOCATION_WIRE, @intFromEnum(self.invocation)); }
        if (self.args) |arr| {
            for (arr) |maybe_v| {
                if (maybe_v) |v| {
                    const size = v.calcProtobufSize();
                    target.appendBytesTag(AggregateFunctionWire.ARGS_WIRE, size);
                    v.encodeTo(target);
                } else {
                    target.appendBytesTag(AggregateFunctionWire.ARGS_WIRE, 0);
                }
            }
        }
    }
};

pub const AggregateFunctionReader = struct {
    allocator: std.mem.Allocator,
    buf: gremlin.Reader,
    _function_reference: u32 = 0,
    _arguments_bufs: ?std.ArrayList([]const u8) = null,
    _options_bufs: ?std.ArrayList([]const u8) = null,
    _output_type_buf: ?[]const u8 = null,
    _phase: AggregationPhase = @enumFromInt(0),
    _sorts_bufs: ?std.ArrayList([]const u8) = null,
    _invocation: AggregateFunction.AggregationInvocation = @enumFromInt(0),
    _args_bufs: ?std.ArrayList([]const u8) = null,

    pub fn init(allocator: std.mem.Allocator, src: []const u8) gremlin.Error!AggregateFunctionReader {
        var buf = gremlin.Reader.init(src);
        var res = AggregateFunctionReader{.allocator = allocator, .buf = buf};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                AggregateFunctionWire.FUNCTION_REFERENCE_WIRE => {
                  const result = try buf.readUInt32(offset);
                  offset += result.size;
                  res._function_reference = result.value;
                },
                AggregateFunctionWire.ARGUMENTS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._arguments_bufs == null) {
                        res._arguments_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._arguments_bufs.?.append(result.value);
                },
                AggregateFunctionWire.OPTIONS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._options_bufs == null) {
                        res._options_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._options_bufs.?.append(result.value);
                },
                AggregateFunctionWire.OUTPUT_TYPE_WIRE => {
                  const result = try buf.readBytes(offset);
                  offset += result.size;
                  res._output_type_buf = result.value;
                },
                AggregateFunctionWire.PHASE_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._phase = @enumFromInt(result.value);
                },
                AggregateFunctionWire.SORTS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._sorts_bufs == null) {
                        res._sorts_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._sorts_bufs.?.append(result.value);
                },
                AggregateFunctionWire.INVOCATION_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._invocation = @enumFromInt(result.value);
                },
                AggregateFunctionWire.ARGS_WIRE => {
                    const result = try buf.readBytes(offset);
                    offset += result.size;
                    if (res._args_bufs == null) {
                        res._args_bufs = std.ArrayList([]const u8).init(allocator);
                    }
                    try res._args_bufs.?.append(result.value);
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(self: *const AggregateFunctionReader) void {
        if (self._arguments_bufs) |arr| {
            arr.deinit();
        }
        if (self._options_bufs) |arr| {
            arr.deinit();
        }
        if (self._sorts_bufs) |arr| {
            arr.deinit();
        }
        if (self._args_bufs) |arr| {
            arr.deinit();
        }
    }
    pub inline fn getFunctionReference(self: *const AggregateFunctionReader) u32 { return self._function_reference; }
    pub fn getArguments(self: *const AggregateFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionArgumentReader {
        if (self._arguments_bufs) |bufs| {
            var result = try std.ArrayList(FunctionArgumentReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try FunctionArgumentReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]FunctionArgumentReader{};
    }
    pub fn getOptions(self: *const AggregateFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]FunctionOptionReader {
        if (self._options_bufs) |bufs| {
            var result = try std.ArrayList(FunctionOptionReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try FunctionOptionReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]FunctionOptionReader{};
    }
    pub fn getOutputType(self: *const AggregateFunctionReader, allocator: std.mem.Allocator) gremlin.Error!type.TypeReader {
        if (self._output_type_buf) |buf| {
            return try type.TypeReader.init(allocator, buf);
        }
        return try type.TypeReader.init(allocator, &[_]u8{});
    }
    pub inline fn getPhase(self: *const AggregateFunctionReader) AggregationPhase { return self._phase; }
    pub fn getSorts(self: *const AggregateFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]SortFieldReader {
        if (self._sorts_bufs) |bufs| {
            var result = try std.ArrayList(SortFieldReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try SortFieldReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]SortFieldReader{};
    }
    pub inline fn getInvocation(self: *const AggregateFunctionReader) AggregateFunction.AggregationInvocation { return self._invocation; }
    pub fn getArgs(self: *const AggregateFunctionReader, allocator: std.mem.Allocator) gremlin.Error![]ExpressionReader {
        if (self._args_bufs) |bufs| {
            var result = try std.ArrayList(ExpressionReader).initCapacity(allocator, bufs.items.len);
            for (bufs.items) |buf| {
                try result.append(try ExpressionReader.init(allocator, buf));
            }
            return result.toOwnedSlice();
        }
        return &[_]ExpressionReader{};
    }
};

const ReferenceRelWire = struct {
    const SUBTREE_ORDINAL_WIRE: gremlin.ProtoWireNumber = 1;
};

pub const ReferenceRel = struct {
    // fields
    subtree_ordinal: i32 = 0,

    pub fn calcProtobufSize(self: *const ReferenceRel) usize {
        var res: usize = 0;
        if (self.subtree_ordinal != 0) { res += gremlin.sizes.sizeWireNumber(ReferenceRelWire.SUBTREE_ORDINAL_WIRE) + gremlin.sizes.sizeI32(self.subtree_ordinal); }
        return res;
    }

    pub fn encode(self: *const ReferenceRel, allocator: std.mem.Allocator) gremlin.Error![]const u8 {
        const size = self.calcProtobufSize();
        if (size == 0) {
            return &[_]u8{};
        }
        const buf = try allocator.alloc(u8, self.calcProtobufSize());
        var writer = gremlin.Writer.init(buf);
        self.encodeTo(&writer);
        return buf;
    }


    pub fn encodeTo(self: *const ReferenceRel, target: *gremlin.Writer) void {
        if (self.subtree_ordinal != 0) { target.appendInt32(ReferenceRelWire.SUBTREE_ORDINAL_WIRE, self.subtree_ordinal); }
    }
};

pub const ReferenceRelReader = struct {
    _subtree_ordinal: i32 = 0,

    pub fn init(_: std.mem.Allocator, src: []const u8) gremlin.Error!ReferenceRelReader {
        var buf = gremlin.Reader.init(src);
        var res = ReferenceRelReader{};
        if (buf.buf.len == 0) {
            return res;
        }
        var offset: usize = 0;
        while (buf.hasNext(offset, 0)) {
            const tag = try buf.readTagAt(offset);
            offset += tag.size;
            switch (tag.number) {
                ReferenceRelWire.SUBTREE_ORDINAL_WIRE => {
                  const result = try buf.readInt32(offset);
                  offset += result.size;
                  res._subtree_ordinal = result.value;
                },
                else => {
                    offset = try buf.skipData(offset, tag.wire);
                }
            }
        }
        return res;
    }
    pub fn deinit(_: *const ReferenceRelReader) void { }
    
    pub inline fn getSubtreeOrdinal(self: *const ReferenceRelReader) i32 { return self._subtree_ordinal; }
};

