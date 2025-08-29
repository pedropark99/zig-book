const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const Thread = std.Thread;

fn do_some_work() !void {
    _ = try stdout.write("Starting the work.\n");
    try stdout.flush();
    Thread.sleep(1000 * std.time.ns_per_ms);
    _ = try stdout.write("Finishing the work.\n");
    try stdout.flush();
}

pub fn main() !void {
    const thread = try Thread.spawn(.{}, do_some_work, .{});
    thread.join();
}

