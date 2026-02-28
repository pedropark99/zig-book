const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdin_buffer: [1024]u8 = undefined;
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    var stdin_reader = std.Io.File.stdin().reader(init.io, &stdin_buffer);
    const stdin = &stdin_reader.interface;
    const stdout = &stdout_writer.interface;

    try stdout.writeAll("Type your name: ");
    try stdout.flush();

    const name = try stdin.takeDelimiterExclusive('\n');

    try stdout.print("Your name is: {s}\n", .{name});
    try stdout.flush();
}
