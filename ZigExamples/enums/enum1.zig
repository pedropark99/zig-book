const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const PrimaryColorRGB = enum { RED, GREEN, BLUE };
    const acolor = PrimaryColorRGB.MAGENTA;
    _ = acolor;
}
