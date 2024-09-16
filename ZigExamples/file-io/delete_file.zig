const std = @import("std");

pub fn main() !void {
    const cwd = std.fs.cwd();
    try cwd.deleteFile("foo.txt");
}
