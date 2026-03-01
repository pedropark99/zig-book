const std = @import("std");
const Thread = std.Thread;
const RwLock = std.Io.RwLock;
const duration = std.Io.Duration.fromSeconds(2);
const clock: std.Io.Clock = .awake;
var counter: u32 = 0;

fn reader(io: std.Io, id: u32, lock: *RwLock) !void {
    while (true) {
        if (lock.tryLockShared(io)) {
            std.debug.print("Thread {d}: {d}\n", .{id, counter});
            _ = lock.unlockShared(io);
            try std.Io.sleep(io, duration, clock);
        }
    }
}

fn writer(io: std.Io, lock: *RwLock) !void {
    while (true) {
        if (lock.tryLock(io)) {
            counter += 1;
            _ = lock.unlock(io);
            try std.Io.sleep(io, duration, clock);
        }
    }
}

pub fn main(init: std.process.Init) !void {
    var lock: RwLock = .init;
    const thr1 = try Thread.spawn(.{}, reader, .{init.io, 1, &lock});
    const thr2 = try Thread.spawn(.{}, reader, .{init.io, 2, &lock});
    const thr3 = try Thread.spawn(.{}, reader, .{init.io, 3, &lock});
    const wthread = try Thread.spawn(.{}, writer, .{init.io, &lock});

    thr1.join();
    thr2.join();
    thr3.join();
    wthread.join();
}
