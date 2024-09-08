// In this example, we are performing the some work
// in a separate thread. However, there is no real garantee that the work
// performed in this thread is going to finish before the execution of the
// main function, simply because we did not called `join()` on the thread.
// The only thing in this program that makes the execution of the thread finish before
// the execution of main() is the `sleep()` call.
const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Thread = std.Thread;
fn do_some_work() !void {
    _ = try stdout.write("Starting the work.\n");
    std.time.sleep(100 * std.time.ns_per_ms);
    _ = try stdout.write("Finishing the work.\n");
}

pub fn main() !void {
    const thread = try Thread.spawn(.{}, do_some_work, .{});
    _ = thread;

    std.time.sleep(2 * std.time.ns_per_s);
}
