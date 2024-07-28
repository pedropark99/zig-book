const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const ar = [_]i32{ 1, 2, 3, 4 };
    const ptr = &ar;
    try stdout.print("{any}\n", .{@TypeOf(ptr)});
}
