const std = @import("std");
const Allocator = std.mem.Allocator;
fn double_free(allocator: Allocator) !void {
    const buffer = try allocator.alloc(u32, 10);
    defer allocator.free(buffer);
    defer allocator.free(buffer);
    // Return without freeing the
    // allocated memory
}

test "memory leak" {
    const allocator = std.testing.allocator;
    try double_free(allocator);
}
