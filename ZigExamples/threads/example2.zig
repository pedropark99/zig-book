const std = @import("std");
const Thread = std.Thread;
const clock: std.Io.Clock = .awake;
const duration = std.Io.Duration.fromNanoseconds(100);

fn do_some_work(io: std.Io, id: *const u8) !void {
    std.debug.print("Starting thread {d}.\n", .{id.*});
    try std.Io.sleep(io, duration, clock);
    std.debug.print("Finishing thread {d}.\n", .{id.*});
}

pub fn main(init: std.process.Init) !void {
    const id1: u8 = 1;
    const id2: u8 = 2;
    const thread1 = try Thread.spawn(.{}, do_some_work, .{init.io, &id1});
    const thread2 = try Thread.spawn(.{}, do_some_work, .{init.io, &id2});
    thread1.join();
    thread2.join();
}
