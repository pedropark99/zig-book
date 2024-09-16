const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Thread = std.Thread;
var mut1: std.Thread.Mutex = .{};
var mut2: std.Thread.Mutex = .{};
fn do_some_work1() !void {
    mut1.lock();
    std.time.sleep(1 * std.time.ns_per_s);
    mut2.lock();
    _ = try stdout.write("Doing some work 1\n");
    mut2.unlock();
    mut1.unlock();
}

fn do_some_work2() !void {
    mut2.lock();
    std.time.sleep(1 * std.time.ns_per_s);
    mut1.lock();
    _ = try stdout.write("Doing some work 1\n");
    mut1.unlock();
    mut2.unlock();
}

pub fn main() !void {
    const thr1 = try Thread.spawn(.{}, do_some_work1, .{});
    const thr2 = try Thread.spawn(.{}, do_some_work2, .{});
    thr1.join();
    thr2.join();
}
