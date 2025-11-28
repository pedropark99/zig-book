const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const Thread = std.Thread;

fn print_id(id: *const u8) !void {
    try stdout.print("Thread ID: {d}\n", .{id.*});
}

pub fn main() !void {
    const id1: u8 = 1;
    const thread1 = try Thread.spawn(.{}, print_id, .{&id1});
    thread1.detach();
    _ = try stdout.write("Finish main\n");
}
