const std = @import("std");
fn twice(comptime num: u32) u32 {
    return num * 2;
}

pub fn main() !void {
    var buffer: [5]u8 = .{ 0, 0, 0, 0, 0 };
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    _ = try stdout.write("Please write a 4-digit integer number\n");
    _ = try stdin.readUntilDelimiter(&buffer, '\n');

    try stdout.print("Input: {s}", .{buffer});
    const n: u32 = try std.fmt.parseInt(u32, buffer[0 .. buffer.len - 1], 10);
    const twice_result = twice(n);
    try stdout.print("Result: {d}\n", .{twice_result});
}
