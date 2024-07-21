const std = @import("std");

pub fn main() !void {
    const number = 5;
    const pointer = &number;
    pointer.* = 6;
}
