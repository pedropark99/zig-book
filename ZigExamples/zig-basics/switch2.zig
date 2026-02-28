const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
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
