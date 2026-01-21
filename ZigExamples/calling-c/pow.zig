const std = @import("std");
const stdout = std.io.getStdOut().writer();
const cmath = @cImport({
    @cInclude("math.h");
});

pub fn main() !void {
    const x: f32 = 15.68;
    const y = cmath.powf(x, 2.32);
    try stdout.print("{d}\n", .{y});
}
