const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var buffer = try std.ArrayList(u8)
        .initCapacity(allocator, 10);
    defer buffer.deinit(allocator);

    try buffer.appendSlice(allocator, "My Pedro");
    try buffer.insert(allocator, 4, '3');
    try buffer.insertSlice(allocator, 2, " name");
    for (buffer.items) |char| {
        try stdout.print("{c}", .{char});
    }

    try stdout.flush();
}
