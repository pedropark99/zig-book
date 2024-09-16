const std = @import("std");
fn Array(comptime T: type) type {
    return struct {
        items: []T,
        size: usize,
    };
}

pub fn main() !void {
    var buffer: [5]u8 = undefined;
    const ar = Array(u8){ .items = &buffer, .size = 0 };
    std.debug.print("{any}\n", .{@TypeOf(ar)});
}
