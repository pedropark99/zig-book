const std = @import("std");
const AllocError = std.heap.Allocator.Error;

fn print_name() AllocError!void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("My name is Pedro!\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const some_number = try allocator.create(u32);
    defer allocator.destroy(some_number);
}

pub fn main() !void {
    try print_name();
}
