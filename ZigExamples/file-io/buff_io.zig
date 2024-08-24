const std = @import("std");
const stdout = std.io.getStdOut().writer();
pub fn main() !void {
    var file = try std.fs.cwd().openFile("ZigExamples/file-io/lorem.txt", .{});
    defer file.close();
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    var buffer: [1000]u8 = undefined;
    @memset(buffer[0..], 0);

    _ = try reader.readUntilDelimiterOrEof(buffer[0..], '\n');
    try stdout.print("{s}\n", .{buffer});
}
