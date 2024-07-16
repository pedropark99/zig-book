const std = @import("std");
pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "hello",
        .root_source_file = b.path("src/hello.zig"),
        .target = b.host
    });
    b.installArtifact(exe);
    const run_arti = b.addRunArtifact(exe);
    const run_step = b.step(
        "run", "Run the project"
    );
    run_step.dependOn(&run_arti.step);
}
