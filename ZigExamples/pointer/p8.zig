const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const ar = [_]i32{ 1, 2, 3, 4 };
    const ptr = &ar;
    try stdout.print("{any}\n", .{@TypeOf(ptr)});
}
