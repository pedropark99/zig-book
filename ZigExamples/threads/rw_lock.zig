const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Thread = std.Thread;
const RwLock = std.Thread.RwLock;
var counter: u64 = 0;
var buffer = [4]u32{ 512, 2700, 9921, 112 };

fn reader(lock: *RwLock) !void {
    while (true) {
        lock.lockShared();
        const v: u32 = buffer[0];
        _ = v;
        lock.unlockShared();
    }
}

fn writer(lock: *RwLock) void {
    while (true) {
        if ((counter % 2) == 0) {
            lock.lock();
            buffer[0] = 654;
            lock.unlock();
        } else {
            lock.lock();
            buffer[0] = 512;
            lock.unlock();
        }
        counter += 1;
        std.time.sleep(0.5 * std.time.ns_per_s);
    }
}

pub fn main() !void {
    const ids = [3]u8{ 1, 2, 3 };
    var lock: RwLock = .{};
    const thr1 = try Thread.spawn(.{}, reader, .{ &ids[0], &lock });
    const thr2 = try Thread.spawn(.{}, reader, .{ &ids[1], &lock });
    const thr3 = try Thread.spawn(.{}, reader, .{ &ids[2], &lock });
    const wthread = try Thread.spawn(.{}, writer, .{&lock});

    thr1.join();
    thr2.join();
    thr3.join();
    wthread.join();
}
