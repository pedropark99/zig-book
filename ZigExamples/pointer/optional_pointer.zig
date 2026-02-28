const std = @import("std");

pub fn main() !void {
    var num: ?u32 = 5;
    const p = &num;
    std.debug.print("{any}\n", .{@TypeOf(p)});
}
