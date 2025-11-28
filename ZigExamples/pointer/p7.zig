const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

fn return_null(n: i32) ?i32 {
    if (n == 5) return null;
    return n;
}

pub fn main() !void {
    const x: i32 = 5;
    const y: ?i32 = return_null(x);
    try stdout.print("{d}\n", .{y.?});
}
