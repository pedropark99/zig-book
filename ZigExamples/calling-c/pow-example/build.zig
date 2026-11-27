const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const translate_c = b.addTranslateC(.{
        .root_source_file = b.path("c.h"),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "pow_example",
        .root_module = b.createModule(.{
            .root_source_file = b.path("pow.zig"),
            .target = target,
        }),
    });
    exe.root_module.addImport("cmath", translate_c.createModule());
    b.installArtifact(exe);
}
