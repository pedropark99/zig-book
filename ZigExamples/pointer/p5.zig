const std = @import("std");

fn return_null(n: u8) ?u8 {
    if (n == 5) {
        return null;
    }
    return n;
}

pub fn main() !void {
    var number: u8 = 5;
    number = return_null(number).?;
}
