const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Thread = std.Thread;
const RwLock = std.Thread.RwLock;
var counter: u32 = 0;
var buffer = [4]u32{ 512, 2700, 9921, 112 };

fn reader(lock: *RwLock) !void {
    while (true) {
        lock.lockShared();
        const v: u32 = counter;
        try stdout.print("{d}", .{v});
        lock.unlockShared();
        std.time.sleep(2 * std.time.ns_per_s);
    }
}

fn writer(lock: *RwLock) void {
    while (true) {
        lock.lock();
        counter += 1;
        lock.unlock();
        std.time.sleep(2 * std.time.ns_per_s);
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
