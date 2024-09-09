const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Thread = std.Thread;
fn print_id(id: *const u8) !void {
    try stdout.print("Thread ID: {d}\n", .{id.*});
}

pub fn main() !void {
    const id1: u8 = 1;
    const id2: u8 = 2;
    const thread1 = try Thread.spawn(.{}, print_id, .{&id1});
    const thread2 = try Thread.spawn(.{}, print_id, .{&id2});

    _ = try stdout.write("Joining thread 1\n");
    thread1.join();
    std.time.sleep(2 * std.time.ns_per_s);
    _ = try stdout.write("Joining thread 2\n");
    thread2.join();
}
