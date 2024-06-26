const std = @import("std");
const stdout = std.io.getStdOut().writer();
pub fn main() !void {
    const n = 0;
    try stdout.print("{X}\n", .{n});
}
