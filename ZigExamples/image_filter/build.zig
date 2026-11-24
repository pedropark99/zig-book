const std = @import("std");
const builtin = @import("builtin");
const LazyPath = std.Build.LazyPath;
const Translator = @import("translate_c").Translator;

const HeaderToTranslate = struct {
    path: []const u8,
    name: []const u8,

    pub fn init(path: []const u8, name: []const u8) HeaderToTranslate  {
        return HeaderToTranslate {
            .path = path,
            .name = name,
        };
    }
};

fn get_c_headers(allocator: std.mem.Allocator) !std.ArrayList(HeaderToTranslate)  {
    var c_headers = try std.ArrayList(HeaderToTranslate ).initCapacity(allocator, 3);
    try c_headers.append(allocator, HeaderToTranslate.init("src/c.h", "c"));
    try c_headers.append(allocator, HeaderToTranslate.init("src/cmath.h", "cmath"));
    try c_headers.append(allocator, HeaderToTranslate.init("src/png.h", "png"));
    return c_headers;
}


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

    exe.root_module.linkSystemLibrary("m", .{});

    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();
    var c_headers = try get_c_headers(allocator);
    defer c_headers.deinit(allocator);

    for (c_headers.items) |header| {
        add_translate_c_step(
            b, header, exe, target, optimize
        );
    }

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}


fn add_translate_c_step(
    b: *std.Build,
    header: HeaderToTranslate,
    exe: *std.Build.Step.Compile,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.Optimize
) void {
    const translate_step = b.addTranslateC(.{
        .root_source_file = b.path(header.path),
        .target = target,
        .optimize = optimize,
    });
    if (std.mem.eql(u8, header.name, "png")) {
        translate_step.addIncludePath(LazyPath{ .cwd_relative = "C:/msys64/mingw64/include"});
        exe.root_module.addLibraryPath(LazyPath{ .cwd_relative = "C:/msys64/mingw64/lib"});
        exe.root_module.linkSystemLibrary("spng", .{});
        exe.root_module.linkSystemLibrary("zlib", .{});
    }

    exe.root_module.addImport(header.name, translate_step.createModule());
}
