const std = @import("std");

pub fn main() !void {
    const cwd = std.fs.cwd();
    try cwd.makeDir("src");
    try cwd.deleteDir("src");
}
