const std = @import("std");
const Thread = std.Thread;
const clock: std.Io.Clock = .awake;
const duration = std.Io.Duration.fromNanoseconds(1000);

fn do_some_work(io: std.Io) !void {
    std.debug.print("Starting the work.\n", .{});
    try std.Io.sleep(io, duration, clock);
    std.debug.print("Finishing the work.\n", .{});
}

pub fn main(init: std.process.Init) !void {
    const thread = try Thread.spawn(.{}, do_some_work, .{init.io});
    thread.join();
}
