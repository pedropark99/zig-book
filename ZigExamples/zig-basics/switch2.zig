const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

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
