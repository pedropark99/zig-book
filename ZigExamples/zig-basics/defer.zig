// This program demonstrates that an expression registered
// with `defer` is executed no matter how the code exits the current scope
// (i.e. if it exits with an error, or, exits from a return statement, a break statement, etc.)
const std = @import("std");
fn foo() !void {
    return error.Test;
}

pub fn main() !void {
    var i: usize = 1;
    errdefer std.debug.print("Value of i: {d}\n", .{i});
    defer i = 2;
    try foo();
}
