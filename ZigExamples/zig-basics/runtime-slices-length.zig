const std = @import("std");
const builtin = @import("builtin");

pub fn main() !void {
    comptime var n: usize = 0;
    if (builtin.target.os.tag == .windows) {
        n = 10;
    } else {
        n = 12;
    }
    const buffer: [n]u8 = undefined;
    _ = buffer;
}
