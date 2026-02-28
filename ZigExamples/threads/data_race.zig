const std = @import("std");
const Thread = std.Thread;

// Global counter variable
var counter: usize = 0;
// Function to increment the counter
fn increment() void {
    for (0..100000) |_| {
        counter += 1;
    }
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const thr1 = try Thread.spawn(.{}, increment, .{});
    const thr2 = try Thread.spawn(.{}, increment, .{});
    thr1.join();
    thr2.join();
    try stdout.print("Counter value: {d}\n", .{counter});
    try stdout.flush();
}
