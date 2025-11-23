const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const cwd = std.fs.cwd();
    const dir = try cwd.openDir("ZigExamples/file-io/", .{ .iterate = true });
    var it = dir.iterate();
    while (try it.next()) |entry| {
        try stdout.print("File name: {s}\n", .{entry.name});
    }
}
