const std = @import("std");
const Thread = std.Thread;
const clock: std.Io.Clock = .awake;
const duration = std.Io.Duration.fromSeconds(1);
const State = std.Io.Mutex.State;
var mut1: std.Io.Mutex = .{.state=std.atomic.Value(State).init(.unlocked)};
var mut2: std.Io.Mutex = .{.state=std.atomic.Value(State).init(.unlocked)};

fn do_some_work1(io: std.Io) !void {
    try mut1.lock(io);
    try std.Io.sleep(io, duration, clock);
    try mut2.lock(io);
    std.debug.print("Doing some work 1\n", .{});
    mut2.unlock(io);
    mut1.unlock(io);
}

fn do_some_work2(io: std.Io) !void {
    try mut2.lock(io);
    try std.Io.sleep(io, duration, clock);
    try mut1.lock(io);
    std.debug.print("Doing some work 2\n", .{});
    mut1.unlock(io);
    mut2.unlock(io);
}

pub fn main(init: std.process.Init) !void {
    const thr1 = try Thread.spawn(.{}, do_some_work1, .{init.io});
    const thr2 = try Thread.spawn(.{}, do_some_work2, .{init.io});
    thr1.join();
    thr2.join();
}
