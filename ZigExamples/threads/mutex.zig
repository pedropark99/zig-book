const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Thread = std.Thread;
const Mutex = std.Thread.Mutex;
var counter: usize = 0;
fn increment(mutex: *Mutex) void {
    for (0..100000) |_| {
        mutex.lock();
        counter += 1;
        mutex.unlock();
    }
}

pub fn main() !void {
    var mutex: Mutex = .{};
    const thr1 = try Thread.spawn(.{}, increment, .{&mutex});
    const thr2 = try Thread.spawn(.{}, increment, .{&mutex});
    thr1.join();
    thr2.join();
    try stdout.print("Couter value: {d}\n", .{counter});
}
