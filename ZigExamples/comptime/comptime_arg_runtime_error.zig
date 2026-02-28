const std = @import("std");
fn twice(comptime num: u32) u32 {
    return num * 2;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = std.Io.File.stdin().reader(init.io, &stdin_buffer);
    const stdin = &stdin_reader.interface;

    var buffer: [5]u8 = .{ 0, 0, 0, 0, 0 };
    _ = try stdout.write("Please write a 4-digit integer number\n");
    _ = try stdin.takeDelimiterExclusive('\n');

    try stdout.print("Input: {s}", .{buffer});
    const n: u32 = try std.fmt.parseInt(u32, buffer[0 .. buffer.len - 1], 10);
    const twice_result = twice(n);
    try stdout.print("Result: {d}\n", .{twice_result});
}
