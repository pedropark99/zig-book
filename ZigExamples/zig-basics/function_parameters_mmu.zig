const std = @import("std");
fn add2(x: *u32) void {
    const d: u32 = 2;
    x.* = x.* + d;
}

pub fn main() !void {
    var x: u32 = 4;
    add2(&x);
    std.debug.print("{d}\n", .{x});
}
