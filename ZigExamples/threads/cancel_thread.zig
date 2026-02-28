const std = @import("std");
const Thread = std.Thread;
const clock: std.Io.Clock = .awake;
const duration = std.Io.Duration.fromSeconds(2);
var running = std.atomic.Value(bool).init(true);
var counter: u64 = 0;

fn do_more_work(io: std.Io) !void {
    try std.Io.sleep(io, duration, clock);
}

fn work(io: std.Io) !void {
    while (running.load(.monotonic)) {
        for (0..10000) |_| {
            counter += 1;
        }
        if (counter > 15000) {
            std.debug.print("Time to cancel the thread.\n", .{});
            running.store(false, .monotonic);
        } else {
            std.debug.print("Time to do more work.\n", .{});
            try do_more_work(io);
        }
    }
}

pub fn main(init: std.process.Init) !void {
    const thread = try Thread.spawn(.{}, work, .{init.io});
    thread.join();
}
