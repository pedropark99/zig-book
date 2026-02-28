const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const some_number = try allocator.create(u32);
    defer allocator.destroy(some_number);

    some_number.* = @as(u32, 45);
}
