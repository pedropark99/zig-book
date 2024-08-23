const std = @import("std");

pub fn main() !void {
    const cwd = std.fs.cwd();
    try cwd.copyFile("foo.txt", cwd, "ZigExamples/file-io/foo.txt", .{});
}
