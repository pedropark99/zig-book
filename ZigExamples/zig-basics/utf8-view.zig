const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    var utf8 = try std.unicode.Utf8View.init("アメリカ");
    var iterator = utf8.iterator();
    while (iterator.nextCodepointSlice()) |codepoint| {
        try stdout.print(
            "got codepoint {x}\n",
            .{codepoint},
        );
    }

    try stdout.flush();
}
