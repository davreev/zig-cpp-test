const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //////////////////////////////////////////////
    // C++ executable calling into Zig library

    const hello_lib_zig = b.addStaticLibrary(.{
        .name = "hello-lib-zig",
        .root_source_file = b.path("src/hello_lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    const hello_cpp = b.addExecutable(.{
        .name = "hello-cpp",
        .target = target,
        .optimize = optimize,
    });
    hello_cpp.addCSourceFile(.{
        .file = b.path("src/hello.cpp"),
        .flags = &.{"-std=c++17"},
    });
    hello_cpp.linkLibCpp();
    hello_cpp.linkLibrary(hello_lib_zig);

    b.installArtifact(hello_cpp);

    //////////////////////////////////////////////
    // Zig executable calling into C++ library

    const hello_lib_cpp = b.addStaticLibrary(.{
        .name = "hello-lib-cpp",
        .target = target,
        .optimize = optimize,
    });
    hello_lib_cpp.addCSourceFile(.{
        .file = b.path("src/hello_lib.cpp"),
        .flags = &.{"-std=c++17"},
    });
    hello_lib_cpp.linkLibCpp();

    const hello_zig = b.addExecutable(.{
        .name = "hello-zig",
        .root_source_file = b.path("src/hello.zig"),
        .target = target,
        .optimize = optimize,
    });
    hello_zig.linkLibrary(hello_lib_cpp);
    hello_zig.addIncludePath(b.path("./src/"));

    b.installArtifact(hello_zig);
}
