const std = @import("std");
const stdout = std.io.getStdOut().writer();
pub fn main() !void {
    const level: u8 = 4;
    const category = switch (level) {
        1, 2 => "beginner",
        3 => "professional",
        else => {
            @panic("Not supported level!");
        },
    };
    try stdout.print("{s}\n", .{category});
}
