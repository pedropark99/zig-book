const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    try cwd.createDir(init.io, "src", .default_dir);
    try cwd.deleteDir(init.io, "src");
}
