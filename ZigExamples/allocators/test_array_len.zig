const std = @import("std");

pub fn main() !void {
    const name = "Pedro";
    _ = name;
    const array = [_]u8{ 1, 2, 3, 4 };
    _ = input_length(&array);
}

fn input_length(input: []const u8) usize {
    return input.len;
}
