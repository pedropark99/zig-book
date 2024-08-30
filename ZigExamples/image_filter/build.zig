const std = @import("std");
const LazyPath = std.Build.LazyPath;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "image_filter",
        .root_source_file = b.path("src/image_filter.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();
    // Link C math library:
    exe.linkSystemLibrary("m");
    // Link to spng library:
    exe.linkSystemLibrary("spng");
    exe.addLibraryPath(LazyPath{ .cwd_relative = "/usr/local/lib/" });

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
