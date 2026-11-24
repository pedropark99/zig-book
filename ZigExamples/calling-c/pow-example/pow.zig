const std = @import("std");
const cmath = @import("cmath");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const x: f32 = 15.68;
    const y = cmath.powf(x, 2.32);
    try stdout.print("{d}\n", .{y});
    try stdout.flush();
}
