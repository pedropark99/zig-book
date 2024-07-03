const std = @import("std");
const stdout = std.io.getStdOut().writer();

fn add_and_increment(a: u8, b: u8) u8 {
    const sum = a + b;
    const incremented = sum + 1;
    return incremented;
}

pub fn main() !void {
    var n = add_and_increment(2, 3);
    n = add_and_increment(n, n);
    try stdout.print("Result: {d}!\n", .{n});
}
