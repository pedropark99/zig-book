const std = @import("std");
fn return_null(n: i32) ?i32 {
    if (n == 5) return null;
    return n;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const y: ?i32 = return_null(5);
    try stdout.print("{d}\n", .{y.?});
    try stdout.flush();
}
