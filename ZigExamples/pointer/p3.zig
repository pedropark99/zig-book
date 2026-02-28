const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const array1 = [4]u8{ 1, 2, 3, 4 };
    const p = &array1;
    try stdout.print("{d}\n", .{p[0]});
    try stdout.flush();
}
