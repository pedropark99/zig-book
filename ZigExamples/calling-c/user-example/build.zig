const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const translate_c = b.addTranslateC(.{
        .root_source_file = b.path("user.h"),
        .target = target,
        .optimize = optimize,
    });

    const user_exe = b.addExecutable(.{
        .name = "set_user_id",
        .root_module = b.createModule(.{
            .root_source_file = b.path("set_user_id.zig"),
            .target = target,
        }),
    });
    user_exe.root_module.addImport("c", translate_c.createModule());

    const instantiating_c_objects_exe = b.addExecutable(.{
        .name = "instantiating_c_objects",
        .root_module = b.createModule(.{
            .root_source_file = b.path("instantiating-c-objects.zig"),
            .target = target,
        }),
    });
    instantiating_c_objects_exe.root_module.addImport("c", translate_c.createModule());

    b.installArtifact(user_exe);
    b.installArtifact(instantiating_c_objects_exe);
}
