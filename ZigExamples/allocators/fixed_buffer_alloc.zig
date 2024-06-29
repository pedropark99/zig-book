const std = @import("std");

pub fn main() !void {
    var buffer: [10]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }

    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const input = try allocator.alloc(u8, 5);
    defer allocator.free(input);
}
