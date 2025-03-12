const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const nanopb_upstream = b.dependency("nanopb", .{});
    const substrait_upstream = b.dependency("substrait", .{});
    const protobuf_upstream = b.dependency("protobuf", .{});

    const nanopb = b.addStaticLibrary(.{
        .name = "nanopb",
        .target = target,
        .optimize = optimize,
    });

    nanopb.linkLibC();

    nanopb.addCSourceFiles(.{
        .root = nanopb_upstream.path(""),
        .files = &.{ "pb_common.c", "pb_decode.c", "pb_encode.c" },
        .flags = &.{},
    });

    const headers: []const []const u8 = &.{ "pb.h", "pb_common.h", "pb_decode.h", "pb_encode.h" };
    inline for (headers) |header| {
        nanopb.installHeader(
            nanopb_upstream.path(header),
            header,
        );
    }

    const protobuf_protos: []const []const u8 = &.{
        "google/protobuf/any",
        "google/protobuf/empty",
    };

    const protobuf_protos_lib = b.addStaticLibrary(.{
        .name = "protobuf",
        .target = target,
        .optimize = optimize,
    });

    protobuf_protos_lib.linkLibC();
    protobuf_protos_lib.addIncludePath(b.path("proto"));

    inline for (protobuf_protos) |proto_file| {
        const source = std.fmt.comptimePrint("proto/{s}.pb.c", .{proto_file});
        protobuf_protos_lib.addCSourceFile(.{ .file = b.path(source) });
    }

    inline for (protobuf_protos) |proto_file| {
        const header = std.fmt.comptimePrint("proto/{s}.pb.h", .{proto_file});
        protobuf_protos_lib.installHeader(
            b.path(header),
            b.pathJoin(&.{header}),
        );
    }

    protobuf_protos_lib.linkLibrary(nanopb);

    const substrait_protos: []const []const u8 = &.{
        "substrait/algebra",
        "substrait/capabilities",
        "substrait/extended_expression",
        "substrait/function",
        "substrait/parameterized_types",
        "substrait/plan",
        "substrait/type",
        "substrait/type_expressions",
        "substrait/extensions/extensions",
    };

    const substrait_protos_lib = b.addStaticLibrary(.{
        .name = "substrait",
        .target = target,
        .optimize = optimize,
    });

    substrait_protos_lib.linkLibC();
    substrait_protos_lib.addIncludePath(b.path("proto"));

    inline for (substrait_protos) |proto_file| {
        const source = std.fmt.comptimePrint("proto/{s}.pb.c", .{proto_file});
        substrait_protos_lib.addCSourceFile(.{ .file = b.path(source) });
    }

    inline for (substrait_protos) |proto_file| {
        const header = std.fmt.comptimePrint("proto/{s}.pb.h", .{proto_file});
        substrait_protos_lib.installHeader(
            b.path(header),
            b.pathJoin(&.{header}),
        );
    }

    substrait_protos_lib.linkLibrary(nanopb);
    substrait_protos_lib.linkLibrary(protobuf_protos_lib);

    lib_mod.linkLibrary(substrait_protos_lib);
    lib_mod.addIncludePath(b.path("proto"));
    lib_mod.addIncludePath(nanopb_upstream.path(""));

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_mod.addImport("yyy_lib", lib_mod);

    const lib = b.addStaticLibrary(.{
        .name = "yyy",
        .root_module = lib_mod,
    });
    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "yyy",
        .root_module = exe_mod,
    });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);

    const lldb = b.addSystemCommand(&.{
        "lldb",
        "--",
    });
    lldb.addArtifactArg(lib_unit_tests);

    const lldb_step = b.step("lldb", "Run the tests in lldb");
    lldb_step.dependOn(&lldb.step);

    const protobuf_protos_build = b.addSystemCommand(&.{"python3"});
    protobuf_protos_build.addFileArg(nanopb_upstream.path("generator/nanopb_generator.py"));
    protobuf_protos_build.addArgs(&.{
        "--custom-style",
        "proto/style.NamingStyle",
        "-Dproto",
        "-I",
    });
    protobuf_protos_build.addFileArg(protobuf_upstream.path("src"));

    inline for (protobuf_protos) |proto_file| {
        const path = std.fmt.comptimePrint("{s}.proto", .{proto_file});
        protobuf_protos_build.addFileArg(protobuf_upstream.path("src").path(b, path));
    }

    const substrait_proto_build = b.addSystemCommand(&.{"python3"});
    substrait_proto_build.addFileArg(nanopb_upstream.path("generator/nanopb_generator.py"));
    substrait_proto_build.addArgs(&.{
        "--custom-style",
        "proto/style.NamingStyle",
        "-Dproto",
        "-I",
    });
    substrait_proto_build.addFileArg(substrait_upstream.path("proto"));

    inline for (substrait_protos) |proto_file| {
        const path = std.fmt.comptimePrint("{s}.proto", .{proto_file});
        substrait_proto_build.addFileArg(substrait_upstream.path("proto").path(b, path));
    }

    const proto_step = b.step("proto", "Generate protobuf files");
    proto_step.dependOn(&protobuf_protos_build.step);
    proto_step.dependOn(&substrait_proto_build.step);
}
