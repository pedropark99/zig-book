const std = @import("std");
const stdout_file = std.io.getStdOut().writer();
var bw = std.io.bufferedWriter(stdout_file);
const stdout = bw.writer();

pub fn main() !void {
    const A: [][]const u32 = .{
        .{ 12, 21, 22, 4 },
        .{ 15, 10, 43, 12 },
        .{ 9, 7, 12, 3 },
        .{ 5, 9, 4, 12 },
    };
    const B: []const u32 = .{ 12, 11, 43, 25 };
    try stdout.print("Run `zig build test` to run the tests.\n", .{});
    try bw.flush(); // Don't forget to flush!
}
