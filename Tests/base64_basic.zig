const std = @import("std");
const stdout = std.io.getStdOut().writer();

fn print(input: []const u8) !void {
    try stdout.print("{s}\n", .{input});
}

const Base64 = struct {
    table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers = "0123456789+/";
        return Base64{
            .table = upper ++ lower ++ numbers,
        };
    }

    pub fn char_at(self: Base64, index: u8) u8 {
        return self.table[index];
    }
};

fn add_padding_(input: []const u8) []u8 {
    var bytes_with_padding = [3]u8{ 0, 0, 0 };
    for (input, 0..) |_, i| {
        bytes_with_padding[i] = input[i];
        try stdout.print("{d} ", .{bytes_with_padding[i]});
    }
    return &bytes_with_padding;
}

fn decode(input: []const u8) !void {
    if (input.len == 0) return;

    const bytes_to_convert = add_padding_(input);
    try print(bytes_to_convert);
}

pub fn main() !void {
    const text = "Hi";
    try decode(text);
}
