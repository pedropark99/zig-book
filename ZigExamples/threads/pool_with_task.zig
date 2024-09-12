const std = @import("std");
const stdout = std.io.getStdOut().writer();
const Pool = std.Thread.Pool;

fn print_id(id: *const u8) void {
    _ = stdout.print("Thread ID: {d}\n", .{id.*}) catch void;
}

pub fn main() !void {
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
    try pool.spawn(print_id, .{&id1});
    try pool.spawn(print_id, .{&id2});
}
