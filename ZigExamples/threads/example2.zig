const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Thread = std.Thread;

fn do_some_work(thread_id: *const u8) !void {
    _ = try stdout.print("Starting thread {d}.\n", .{thread_id.*});
    std.time.sleep(100 * std.time.ns_per_ms);
    _ = try stdout.print("Finishing thread {d}.\n", .{thread_id.*});
}

pub fn main() !void {
    const id1: u8 = 1;
    const id2: u8 = 2;
    const thread1 = try Thread.spawn(.{}, do_some_work, .{&id1});
    const thread2 = try Thread.spawn(.{}, do_some_work, .{&id2});
    thread1.join();
    thread2.join();
}
