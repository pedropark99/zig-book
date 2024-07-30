const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const array1 = [4]u8{ 1, 2, 3, 4 };
    const p = &array1;
    try stdout.print("{d}\n", .{p[0]});
}
