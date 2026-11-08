const std = @import("std");
const builtin = @import("builtin");
const LazyPath = std.Build.LazyPath;
const Translator = @import("translate_c").Translator;

pub fn build(b: *std.Build) void {
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
    // link_to_spng(exe.root_module);
    add_c_headers(exe.root_module, b, target, optimize);
    // add_cstdio_header(exe.root_module, b, target, optimize);
    // add_spng_header(exe.root_module, b, target, optimize);


    b.installArtifact(exe);
    // const run_cmd = b.addRunArtifact(exe);
    // run_cmd.step.dependOn(b.getInstallStep());
    // const run_step = b.step("run", "Run the app");
    // run_step.dependOn(&run_cmd.step);
}

fn add_c_headers(
    module: *std.Build.Module,
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.Optimize
) void {
    const translate_c = b.dependency("translate_c", .{});
    const translate_step: Translator = .init(translate_c, .{
        .c_source_file = b.path("stdio.h"),
        .target = target,
        .optimize = optimize,
    });

    translate_step.addIncludePath(LazyPath{ .cwd_relative = "C:/msys64/mingw64/include"});
    translate_step.addIncludePath(LazyPath{ .cwd_relative = "C:/Program Files (x86)/Windows Kits/10/Include/10.0.22000.0/ucrt"});

    module.addImport("c", translate_step.mod);
}

fn add_spng_header(
    module: *std.Build.Module,
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.Optimize
) void {
    const translate_c = b.dependency("translate_c", .{});
    const translator: Translator = .init(translate_c, .{
        .c_source_file = b.path("spng.h"),
        .target = target,
        .optimize = optimize,
    });
    link_to_spng(translator.mod);
    module.addImport("png", translator.mod);
}

fn add_cstdio_header(
    module: *std.Build.Module,
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.Optimize
) void {
    const translate_c = b.dependency("translate_c", .{});
    const translate_step: Translator = .init(translate_c, .{
        .c_source_file = b.path("stdio.h"),
        .target = target,
        .optimize = optimize,
    });
    translate_step.mod.linkSystemLibrary("c", .{});
    // if (builtin.target.os.tag == .windows) {
    //     translate_step.addIncludePath();
    // } else {
    //     translate_step.defineCMacro("_NO_CRT_STDIO_INLINE", "1");
    // }
    module.addImport("c", translate_step.mod);
}

fn link_to_spng(module: *std.Build.Module) void {
    const lib_path = if (builtin.target.os.tag == .windows) "C:/msys64/mingw64/lib" else "/usr/local/lib/";
    const spng_search_name = if (builtin.target.os.tag == .windows) "spng.dll" else "spng";
    const preferred_link_mode: std.builtin.LinkMode = if (builtin.target.os.tag == .windows) .static else .dynamic;

    // Link to libspng library:
    module.linkSystemLibrary(spng_search_name, .{.preferred_link_mode = preferred_link_mode});
    module.addLibraryPath(LazyPath{ .cwd_relative = lib_path });
}
