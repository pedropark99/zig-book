const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();
pub fn main() !void {
    try stdout.writeAll("Type your name\n");
    var buffer: [20]u8 = undefined;
    @memset(buffer[0..], 0);
    _ = try stdin.readUntilDelimiterOrEof(buffer[0..], '\n');
    try stdout.print("Your name is: {s}\n", .{buffer});
}
