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
    thread.join();
}
