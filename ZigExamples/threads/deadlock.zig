const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const Thread = std.Thread;
const io = std.testing.io;
const clock: std.Io.Clock = .awake;
var mut1: std.Thread.Mutex = .{};
var mut2: std.Thread.Mutex = .{};

fn do_some_work1() !void {
    mut1.lock();
    const duration: std.Io.Duration = .{ .nanoseconds = 1 };
    try std.Io.sleep(io, duration, clock);
    mut2.lock();
    _ = try stdout.write("Doing some work 1\n");
    mut2.unlock();
    mut1.unlock();
}

fn do_some_work2() !void {
    mut2.lock();
    const duration: std.Io.Duration = .{ .nanoseconds = 1 };
    try std.Io.sleep(io, duration, clock);
    mut1.lock();
    _ = try stdout.write("Doing some work 1\n");
    mut1.unlock();
    mut2.unlock();
}

pub fn main() !void {
    const thr1 = try Thread.spawn(.{}, do_some_work1, .{});
    const thr2 = try Thread.spawn(.{}, do_some_work2, .{});
    thr1.join();
    thr2.join();
}
