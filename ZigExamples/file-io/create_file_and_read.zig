const std = @import("std");
const stdout = std.io.getStdOut().writer();
pub fn main() !void {
    const cwd = std.fs.cwd();
    const file = try cwd.createFile("foo.txt", .{ .read = true });
    defer file.close();

    var fw = file.writer();
    _ = try fw.writeAll("We are going to read this line\n");

    var buffer: [300]u8 = undefined;
    @memset(buffer[0..], 0);
    try file.seekTo(0);
    var fr = file.reader();
    _ = try fr.readAll(buffer[0..]);
    try stdout.print("{s}\n", .{buffer});
}
