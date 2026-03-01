const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const ar = [_]i32{ 1, 2, 3, 4 };
    const ptr = &ar;
    try stdout.print("{any}\n", .{@TypeOf(ptr)});
    try stdout.flush();
}
