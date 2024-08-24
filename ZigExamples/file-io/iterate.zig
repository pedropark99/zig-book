const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const cwd = std.fs.cwd();
    const dir = try cwd.openDir("ZigExamples/file-io/", .{ .iterate = true });
    var it = dir.iterate();
    while (try it.next()) |entry| {
        try stdout.print("File name: {s}\n", .{entry.name});
    }
}
