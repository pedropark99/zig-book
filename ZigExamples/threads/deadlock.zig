const std = @import("std");
const Thread = std.Thread;
const clock: std.Io.Clock = .awake;
var mut1: std.Thread.Mutex = .{};
var mut2: std.Thread.Mutex = .{};

fn do_some_work1(io: std.Io, stdout: *std.Io.Writer) !void {
    mut1.lock();
    const duration: std.Io.Duration = .{ .nanoseconds = 1 };
    try std.Io.sleep(io, duration, clock);
    mut2.lock();
    _ = try stdout.write("Doing some work 1\n");
    mut2.unlock();
    mut1.unlock();
}

fn do_some_work2(io: std.Io, stdout: *std.Io.Writer) !void {
    mut2.lock();
    const duration: std.Io.Duration = .{ .nanoseconds = 1 };
    try std.Io.sleep(io, duration, clock);
    mut1.lock();
    _ = try stdout.write("Doing some work 1\n");
    mut1.unlock();
    mut2.unlock();
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const thr1 = try Thread.spawn(.{}, do_some_work1, .{init.io, stdout});
    const thr2 = try Thread.spawn(.{}, do_some_work2, .{init.io, stdout});
    thr1.join();
    thr2.join();
}
