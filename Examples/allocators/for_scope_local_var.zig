const std = @import("std");

pub fn main() !void {
    const a = [_]u8{
        0, 1, 2, 3, 4,
        5, 6, 7, 8
    };
    for (0..a.len) |i| {
        const index = i;
        _ = index;
    }
    // Trying to use a variable that was
    // declared in the for loop scope,
    // and that does not exist anymore.
    std.debug.print("{d}\n", index);
}
