const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var num: ?u32 = 5;
    const p = &num;
    std.debug.print("{any}\n", .{@TypeOf(p)});
}
