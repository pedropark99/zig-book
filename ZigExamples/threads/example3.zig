// In this example, we are performing the some work
// in a separate thread. However, there is no real garantee that the work
// performed in this thread is going to finish before the execution of the
// main function, simply because we did not called `join()` on the thread.
// The only thing in this program that makes the execution of the thread finish before
// the execution of main() is the `sleep()` call.
const std = @import("std");
const Thread = std.Thread;
const clock: std.Io.Clock = .awake;
const duration_100 = std.Io.Duration.fromNanoseconds(100);
const duration_2 = std.Io.Duration.fromSeconds(2);

fn do_some_work(io: std.Io) !void {
    std.debug.print("Starting the work.\n", .{});
    try std.Io.sleep(io, duration_100, clock);
    std.debug.print("Finishing the work.\n", .{});
}

pub fn main(init: std.process.Init) !void {
    const thread = try Thread.spawn(.{}, do_some_work, .{init.io});
    _ = thread;

    try std.Io.sleep(init.io, duration_2, clock);
}
