const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var utf8 = try std.unicode.Utf8View.init("アメリカ");
    var iterator = utf8.iterator();
    while (iterator.nextCodepointSlice()) |codepoint| {
        try stdout.print(
            "got codepoint {}\n",
            .{std.fmt.fmtSliceHexUpper(codepoint)},
        );
    }
}
