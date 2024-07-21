const std = @import("std");

pub fn main() !void {
    const PrimaryColorRGB = enum { RED, GREEN, BLUE };
    const acolor = PrimaryColorRGB.MAGENTA;
    _ = acolor;
}
