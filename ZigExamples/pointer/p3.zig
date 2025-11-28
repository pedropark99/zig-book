const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const array1 = [4]u8{ 1, 2, 3, 4 };
    const p = &array1;
    try stdout.print("{d}\n", .{p[0]});
}
