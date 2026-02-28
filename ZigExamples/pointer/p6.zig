const std = @import("std");

pub fn main() !void {
    var num: i32 = 5;
    const ptr: ?*i32 = &num;
    _ = ptr;
}
