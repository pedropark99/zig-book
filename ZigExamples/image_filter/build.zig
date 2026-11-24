const std = @import("std");
const builtin = @import("builtin");
const LazyPath = std.Build.LazyPath;

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "image_filter",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/image_filter.zig"),
            .target = target,
            .link_libc = true
        })
    });

    if (builtin.target.os.tag == .windows) {
        exe.root_module.addLibraryPath(LazyPath{ .cwd_relative = "C:/msys64/mingw64/lib"});
    }

    exe.root_module.linkSystemLibrary("m", .{});
    exe.root_module.linkSystemLibrary("spng", .{});
    exe.root_module.linkSystemLibrary("zlib", .{});

    const ch = b.addTranslateC(.{
        .root_source_file = b.path("src/c.h"),
        .target = target,
        .optimize = optimize,
    });
    const cmath = b.addTranslateC(.{
        .root_source_file = b.path("src/cmath.h"),
        .target = target,
        .optimize = optimize,
    });
    const png = b.addTranslateC(.{
        .root_source_file = b.path("src/png.h"),
        .target = target,
        .optimize = optimize,
    });
    if (builtin.target.os.tag == .windows) {
        png.addIncludePath(LazyPath{ .cwd_relative = "C:/msys64/mingw64/include"});
    }

    exe.root_module.addImport("c", ch.createModule());
    exe.root_module.addImport("cmath", cmath.createModule());
    exe.root_module.addImport("png", png.createModule());

    b.installArtifact(exe);
}
