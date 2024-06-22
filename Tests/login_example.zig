const std = @import("std");
const stdin = std.io.getStdIn();

pub fn main() !void {
    var input: [6]u8 = undefined;

    const input_reader = stdin.reader();
    _ = try input_reader.readUntilDelimiterOrEof(
        &input,
        '\n'
    );

    std.debug.print("{s}\n", .{input});
}
