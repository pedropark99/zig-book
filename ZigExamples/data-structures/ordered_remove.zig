const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var buffer = try std.ArrayList(u8)
        .initCapacity(allocator, 100);
    defer buffer.deinit();

    for (0..10) |i| {
        const index: u8 = @intCast(i);
        try buffer.append(index);
    }

    std.debug.print("{any}\n", .{buffer.items});
    std.debug.print("==========================\n", .{});
    _ = buffer.orderedRemove(3);
    _ = buffer.orderedRemove(3);

    std.debug.print("{any}\n", .{buffer.items});
    std.debug.print("{any}\n", .{buffer.items.len});
}
