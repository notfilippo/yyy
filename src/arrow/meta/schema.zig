pub const Schema = struct {
    const Self = @This();

    fields: []const Field,
};

pub const Field = struct {
    const Self = @This();

    name: []const u8,
    dt: DataType,
};

pub const DataType = union(enum) {
    const Self = @This();

    null,
    boolean,
    i8,
    i16,
    i32,
    i64,
    u8,
    u16,
    u32,
    u64,
    f16,
    f32,
    f64,
    utf8,
    binary,

    pub fn fromType(comptime T: type) Self {
        switch (T) {
            void => return .null,
            bool => return .boolean,
            i8 => return .i8,
            i16 => return .i16,
            i32 => return .i32,
            i64 => return .i64,
            u8 => return .ui8,
            u16 => return .u16,
            u32 => return .u32,
            u64 => return .u64,
            f16 => return .f16,
            f32 => return .f32,
            f64 => return .f64,
            []const u8 => return .utf8,
        }
    }
};
