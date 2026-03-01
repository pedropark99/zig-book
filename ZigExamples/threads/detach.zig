const std = @import("std");
const Thread = std.Thread;

fn print_id(stdout: *std.Io.Writer, id: *const u8) !void {
    try stdout.print("Thread ID: {d}\n", .{id.*});
    try stdout.flush();
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const id1: u8 = 1;
    const thread1 = try Thread.spawn(.{}, print_id, .{stdout, &id1});
    thread1.detach();
    _ = try stdout.write("Finish main\n");
    try stdout.flush();
}
