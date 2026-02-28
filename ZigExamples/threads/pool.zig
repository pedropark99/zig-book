const std = @import("std");
const Pool = std.Thread.Pool;

pub fn main(init: std.process.Init) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const opt = Pool.Options{
        .n_jobs = 4,
        .allocator = allocator,
    };
    var pool: Pool = undefined;
    _ = try pool.init(opt);
    defer pool.deinit();
}
