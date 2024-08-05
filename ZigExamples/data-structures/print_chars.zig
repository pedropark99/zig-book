const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var buffer = try std.ArrayList(u8)
        .initCapacity(allocator, 10);
    defer buffer.deinit();

    try buffer.appendSlice("My Pedro");
    try buffer.insert(4, '3');
    try buffer.insertSlice(2, " name");
    for (buffer.items) |char| {
        try stdout.print("{c}", .{char});
    }
}
