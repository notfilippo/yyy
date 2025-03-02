pub const Schema = struct {
    const Self = @This();

    fields: []const Field,
};

pub const Field = struct {
    const Self = @This();

    name: []const u8,
    dt: DataType,
};

pub const DataType = enum {
    const Self = @This();

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
    binary,

    pub fn toType(comptime self: Self) type {
        return switch (self) {
            .boolean => bool,
            .i8 => i8,
            .i16 => i16,
            .i32 => i32,
            .i64 => i64,
            .u8 => u8,
            .u16 => u16,
            .u32 => u32,
            .u64 => u64,
            .f16 => f16,
            .f32 => f32,
            .f64 => f64,
            .binary => []const u8,
        };
    }
};
