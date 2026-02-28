const std = @import("std");
const AllocError = std.mem.Allocator.Error;

fn print_name(stdout: *std.Io.Writer) AllocError!void {
    try stdout.print("My name is Pedro!\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const some_number = try allocator.create(u32);
    defer allocator.destroy(some_number);
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    try print_name(stdout);
}
