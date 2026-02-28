const std = @import("std");
const Thread = std.Thread;
const Mutex = std.Io.Mutex;
const State = Mutex.State;
var counter: usize = 0;

fn increment(io: std.Io, mutex: *Mutex) !void {
    for (0..100000) |_| {
        try mutex.lock(io);
        counter += 1;
        mutex.unlock(io);
    }
}

pub fn main(init: std.process.Init) !void {
    var mutex: Mutex = .{
        .state=std.atomic.Value(State).init(.unlocked)
    };

    const thr1 = try Thread.spawn(.{}, increment, .{init.io, &mutex});
    const thr2 = try Thread.spawn(.{}, increment, .{init.io, &mutex});
    thr1.join();
    thr2.join();
    std.debug.print("Couter value: {d}\n", .{counter});
}
