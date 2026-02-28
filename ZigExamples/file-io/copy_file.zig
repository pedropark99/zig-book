const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    try cwd.copyFile(
        "foo.txt",
        cwd,
        "ZigExamples/file-io/foo.txt",
        init.io,
        .{}
    );
}
