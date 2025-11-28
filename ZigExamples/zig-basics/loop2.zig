const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const name = [_]u8{ 'P', 'e', 'd', 'r', 'o' };
    for (name[0..2]) |char| {
        try stdout.print("{d} | ", .{char});
    }
}
