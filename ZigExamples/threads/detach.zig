const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Thread = std.Thread;
fn print_id(id: *const u8) !void {
    try stdout.print("Thread ID: {d}\n", .{id.*});
}

pub fn main() !void {
    const id1: u8 = 1;
    const thread1 = try Thread.spawn(.{}, print_id, .{&id1});
    thread1.detach();
    _ = try stdout.write("Finish main\n");
}
