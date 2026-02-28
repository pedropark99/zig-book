const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const name = [_]u8{ 'P', 'e', 'd', 'r', 'o' };
    for (name[0..2]) |char| {
        try stdout.print("{d} | ", .{char});
    }
    try stdout.flush();
}
