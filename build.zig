const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //////////////////////////////////////////////
    // C++ executable calling into Zig library

    const lib_zig = b.addStaticLibrary(.{
        .name = "hello-lib-zig",
        .root_source_file = .{ .path = "hello_lib.zig" },
        .target = target,
        .optimize = optimize,
    });

    const exe_cpp = b.addExecutable(.{
        .name = "hello-cpp",
        .target = target,
        .optimize = optimize,
    });
    exe_cpp.addCSourceFile(.{
        .file = .{ .path = "hello.cpp" },
        .flags = &.{"-std=c++17"},
    });
    exe_cpp.linkLibCpp();
    exe_cpp.linkLibrary(lib_zig);

    b.installArtifact(exe_cpp);

    //////////////////////////////////////////////
    // Zig executable calling into C++ library

    const lib_cpp = b.addStaticLibrary(.{
        .name = "hello-lib-cpp",
        .target = target,
        .optimize = optimize,
    });
    lib_cpp.addCSourceFile(.{
        .file = .{ .path = "hello_lib.cpp" },
        .flags = &.{"-std=c++17"},
    });
    lib_cpp.linkLibCpp();

    const exe_zig = b.addExecutable(.{
        .name = "hello-zig",
        .root_source_file = .{ .path = "hello.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe_zig.linkLibrary(lib_cpp);
    exe_zig.addIncludePath(.{ .path = "./" });

    b.installArtifact(exe_zig);
}
