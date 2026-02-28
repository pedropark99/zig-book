const std = @import("std");
const Pool = std.Thread.Pool;

fn print_id(stdout: *std.Io.Writer, id: *const u8) void {
    _ = stdout.print("Thread ID: {d}\n", .{id.*}) catch void;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const opt = Pool.Options{
        .n_jobs = 4,
        .allocator = allocator,
    };
    var pool: Pool = undefined;
    _ = try pool.init(opt);
    defer pool.deinit();

    const id1: u8 = 1;
    const id2: u8 = 2;
    try pool.spawn(print_id, .{stdout, &id1});
    try pool.spawn(print_id, .{stdout, &id2});
}
