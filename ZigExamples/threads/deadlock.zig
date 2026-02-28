const std = @import("std");
const Thread = std.Thread;
const clock: std.Io.Clock = .awake;
const duration = std.Io.Duration.fromNanoseconds(1);
const State = std.Io.Mutex.State;
var mut1: std.Io.Mutex = .{.state=std.atomic.Value(State).init(.unlocked)};
var mut2: std.Io.Mutex = .{.state=std.atomic.Value(State).init(.unlocked)};

fn do_some_work1(io: std.Io, stdout: *std.Io.Writer) !void {
    try mut1.lock(io);
    try std.Io.sleep(io, duration, clock);
    try mut2.lock(io);
    _ = try stdout.write("Doing some work 1\n");
    try stdout.flush();
    mut2.unlock(io);
    mut1.unlock(io);
}

fn do_some_work2(io: std.Io, stdout: *std.Io.Writer) !void {
    try mut2.lock(io);
    try std.Io.sleep(io, duration, clock);
    try mut1.lock(io);
    _ = try stdout.write("Doing some work 2\n");
    try stdout.flush();
    mut1.unlock(io);
    mut2.unlock(io);
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const thr1 = try Thread.spawn(.{}, do_some_work1, .{init.io, stdout});
    const thr2 = try Thread.spawn(.{}, do_some_work2, .{init.io, stdout});
    thr1.join();
    thr2.join();
}
