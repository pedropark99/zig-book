const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    try cwd.deleteFile(init.io, "foo.txt");
}
