const std = @import("std");
const Thread = std.Thread;
const clock: std.Io.Clock = .awake;

fn print_id(stdout: *std.Io.Writer, id: *const u8) !void {
    try stdout.print("Thread ID: {d}\n", .{id.*});
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const id1: u8 = 1;
    const id2: u8 = 2;
    const thread1 = try Thread.spawn(.{}, print_id, .{stdout, &id1});
    const thread2 = try Thread.spawn(.{}, print_id, .{stdout, &id2});

    _ = try stdout.write("Joining thread 1\n");
    thread1.join();
    const duration: std.Io.Duration = .{ .nanoseconds = 2 };
    try std.Io.sleep(init.io, duration, clock);
    _ = try stdout.write("Joining thread 2\n");
    thread2.join();
}
