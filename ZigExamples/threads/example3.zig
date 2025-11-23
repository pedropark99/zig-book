// In this example, we are performing the some work
// in a separate thread. However, there is no real garantee that the work
// performed in this thread is going to finish before the execution of the
// main function, simply because we did not called `join()` on the thread.
// The only thing in this program that makes the execution of the thread finish before
// the execution of main() is the `sleep()` call.
const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const Thread = std.Thread;
const io = std.testing.io;
const clock: std.Io.Clock = .awake;
fn do_some_work() !void {
    _ = try stdout.write("Starting the work.\n");
    const duration: std.Io.Duration = .{.nanoseconds = 100};
    try std.Io.sleep(io, duration, clock);
    _ = try stdout.write("Finishing the work.\n");
}

pub fn main() !void {
    const thread = try Thread.spawn(.{}, do_some_work, .{});
    _ = thread;

    const duration: std.Io.Duration = .{.nanoseconds = 2};
    try std.Io.sleep(io, duration, clock);
}
