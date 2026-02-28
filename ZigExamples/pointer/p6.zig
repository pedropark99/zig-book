const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var num: i32 = 5;
    const ptr: ?*i32 = &num;
    _ = ptr;
}
