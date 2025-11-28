const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const Thread = std.Thread;
const RwLock = std.Thread.RwLock;
var counter: u32 = 0;
var buffer = [4]u32{ 512, 2700, 9921, 112 };
const clock: std.Io.Clock = .awake;
const io = std.testing.io;

fn reader(lock: *RwLock) !void {
    while (true) {
        lock.lockShared();
        const v: u32 = counter;
        try stdout.print("{d}", .{v});
        lock.unlockShared();
        const duration: std.Io.Duration = .{.nanoseconds = 2};
        try std.Io.sleep(io, duration, clock);
    }
}

fn writer(lock: *RwLock) !void {
    while (true) {
        lock.lock();
        counter += 1;
        lock.unlock();
        const duration: std.Io.Duration = .{.nanoseconds = 2};
        try std.Io.sleep(io, duration, clock);
    }
}

pub fn main() !void {
    const ids = [3]u8{ 1, 2, 3 };
    _ = ids;
    var lock: RwLock = .{};
    const thr1 = try Thread.spawn(.{}, reader, .{&lock});
    const thr2 = try Thread.spawn(.{}, reader, .{&lock});
    const thr3 = try Thread.spawn(.{}, reader, .{&lock});
    const wthread = try Thread.spawn(.{}, writer, .{&lock});

    thr1.join();
    thr2.join();
    thr3.join();
    wthread.join();
}
