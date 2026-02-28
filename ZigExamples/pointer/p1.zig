const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const number: u8 = 5;
    const pointer = &number;
    const doubled = 2 * pointer.*;
    std.debug.print("{d}\n", .{doubled});
}
