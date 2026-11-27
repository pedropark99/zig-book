const std = @import("std");
pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const exe = b.addExecutable(.{
        .name = "main",
        .root_module = b.createModule(.{
            .target = target,
            .link_libc = true,
        }),
    });

    const c_flags: [0][]const u8 = .{};
    exe.root_module.addCSourceFile(.{
        .file = b.path("main.c"),
        .flags = &c_flags,
    });

    b.installArtifact(exe);
}
