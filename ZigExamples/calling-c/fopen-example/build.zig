const std = @import("std");
const Translator = @import("translate_c").Translator;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const translate_c_dep = b.dependency("translate_c", .{});
    const translate_c: Translator = .init(translate_c_dep, .{
        .c_source_file = b.path("c.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    const exe = b.addExecutable(.{
        .name = "fopen_example",
        .root_module = b.createModule(.{
            .root_source_file = b.path("fopen.zig"),
            .target = target,
            .link_libc = true,
            .imports = &.{
                .{ .name = "c", .module = translate_c.mod },
             },
        }),
    });

    b.installArtifact(exe);

    const main_exe = b.addExecutable(.{
        .name = "main",
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .target = target,
            .link_libc = true,
            .imports = &.{
                .{ .name = "c", .module = translate_c.mod },
             },
        }),
    });
    b.installArtifact(main_exe);
}

