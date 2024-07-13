const std = @import("std");
const stdout = std.io.getStdOut().writer();

fn return_null(n: i32) ?i32 {
    if (n == 5) return null;
    return n;
}

pub fn main() !void {
    const x: i32 = 5;
    const y: ?i32 = return_null(x);
    try stdout.print("{d}\n", .{y.?});
}
