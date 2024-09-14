const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Thread = std.Thread;

// Global counter variable
var counter: usize = 0;
// Function to increment the counter
fn increment() void {
    for (0..100000) |_| {
        counter += 1;
    }
}

pub fn main() !void {
    const thr1 = try Thread.spawn(.{}, increment, .{});
    const thr2 = try Thread.spawn(.{}, increment, .{});
    thr1.join();
    thr2.join();
    try stdout.print("Couter value: {d}\n", .{counter});
}
