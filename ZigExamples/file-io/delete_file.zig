const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const cwd = std.fs.cwd();
    try cwd.deleteFile("foo.txt");
}
