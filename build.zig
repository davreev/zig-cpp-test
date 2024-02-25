const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "mylib",
        .root_source_file = .{ .path = "mylib.zig" },
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "hello",
        .target = target,
        .optimize = optimize,
    });
    exe.addCSourceFile(.{
        .file = .{ .path = "hello.cpp" },
        .flags = &.{"-std=c++17"},
    });
    exe.linkLibCpp();
    exe.linkLibrary(lib);

    b.installArtifact(exe);
}
