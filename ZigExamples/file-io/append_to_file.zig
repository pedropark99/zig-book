const std = @import("std");

pub fn main() !void {
    const cwd = std.fs.cwd();
    const file = try cwd.openFile("foo.txt", .{ .mode = .write_only });
    defer file.close();
    try file.seekFromEnd(0);
    var fw = file.writer();
    _ = try fw.writeAll("Some random text to write\n");
}
