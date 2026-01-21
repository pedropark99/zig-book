const std = @import("std");
// This code does not compile because we are trying to
// change the value of a function parameter.
fn add2(x: u32) u32 {
    x = x + 2;
    return x;
}

pub fn main() !void {
    const y = add2(4);
    std.debug.print("{d}\n", .{y});
}
