const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var aa = std.heap.ArenaAllocator.init(gpa.allocator());
    defer aa.deinit();
    const allocator = aa.allocator();

    var input = allocator.alloc(u8, 5);
    input = allocator.alloc(u8, 10);
    input = allocator.alloc(u8, 15);
}
