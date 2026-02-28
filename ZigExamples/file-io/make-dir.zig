const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const cwd = std.fs.cwd();
    try cwd.makeDir("src");
    try cwd.makePath("src/decoders/jpg/");
}
