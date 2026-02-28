const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const number = 5;
    const pointer = &number;
    pointer.* = 6;
}
