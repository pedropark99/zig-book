const std = @import("std");
const stdout = std.io.getStdOut().writer();

fn build_table(alph: []const u8) []const u8 {
    var table: [256]u8 = undefined;
    const INVALID_CHAR = 0x00;
    for (alph, 0..) |char, idx| {
        table[idx] = char;
    }
    for (65..256) |idx| {
        table[idx] = INVALID_CHAR;
    }

    return table;
}

pub fn main() !void {
    const base64_alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    const base64_table = build_table(base64_alphabet);
    _ = base64_table;
}
