const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const name = [_]u8{ 'P', 'e', 'd', 'r', 'o' };
    for (name[0..2]) |char| {
        try stdout.print("{d} | ", .{char});
    }
}
