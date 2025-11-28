const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const Thread = std.Thread;
const io = std.testing.io;
const clock: std.Io.Clock = .awake;

fn print_id(id: *const u8) !void {
    try stdout.print("Thread ID: {d}\n", .{id.*});
}

pub fn main() !void {
    const id1: u8 = 1;
    const id2: u8 = 2;
    const thread1 = try Thread.spawn(.{}, print_id, .{&id1});
    const thread2 = try Thread.spawn(.{}, print_id, .{&id2});

    _ = try stdout.write("Joining thread 1\n");
    thread1.join();
    const duration: std.Io.Duration = .{.nanoseconds = 2};
    try std.Io.sleep(io, duration, clock);
    _ = try stdout.write("Joining thread 2\n");
    thread2.join();
}
