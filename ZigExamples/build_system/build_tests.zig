const std = @import("std");
pub fn build(b: *std.Build) void {
    const test_exe = b.addTest(.{
        .name = "unit_tests",
        .root_source_file = b.path("src/main.zig"),
        .target = b.host,
    });
    b.installArtifact(test_exe);
    const run_arti = b.addRunArtifact(test_exe);
    const run_step = b.step("tests", "Run unit tests");
    run_step.dependOn(&run_arti.step);
}
