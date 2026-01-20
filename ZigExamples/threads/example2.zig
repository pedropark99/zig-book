const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const Thread = std.Thread;
const io = std.testing.io;
const clock: std.Io.Clock = .awake;

fn do_some_work(thread_id: *const u8) !void {
    _ = try stdout.print("Starting thread {d}.\n", .{thread_id.*});
    const duration: std.Io.Duration = .{ .nanoseconds = 100 };
    try std.Io.sleep(io, duration, clock);
    _ = try stdout.print("Finishing thread {d}.\n", .{thread_id.*});
}

pub fn main() !void {
    const id1: u8 = 1;
    const id2: u8 = 2;
    const thread1 = try Thread.spawn(.{}, do_some_work, .{&id1});
    const thread2 = try Thread.spawn(.{}, do_some_work, .{&id2});
    thread1.join();
    thread2.join();
}
