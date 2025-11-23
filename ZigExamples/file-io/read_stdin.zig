const std = @import("std");
const io = std.testing.io
var stdin_buffer: [1024]u8 = undefined;
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;
const stdout = &stdout_writer.interface;

pub fn main() !void {
    try stdout.writeAll("Type your name:\n");
    try stdout.flush();

    const name = try stdin.takeDelimiterExclusive('\n');

    try stdout.print("Your name is: {s}\n", .{name});
    try stdout.flush();
}
