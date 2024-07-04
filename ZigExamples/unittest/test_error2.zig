const std = @import("std");
const Allocator = std.mem.Allocator;
const expectError = std.testing.expectError;

fn alloc_error(allocator: Allocator) !void {
    var ibuffer = try allocator.alloc(u8, 100);
    ibuffer[0] = 2;
}

test "testing errors" {
    var buffer: [10]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    try expectError(error, alloc_error(allocator));
}
