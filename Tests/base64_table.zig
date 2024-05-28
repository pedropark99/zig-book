const std = @import("std");
const stdout = std.io.getStdOut().writer();
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

pub fn main() !void {
    const base64 = Base64.init();
    try stdout.print("Character at 28 index: {c}\n", .{base64.char_at(28)});
}
