const std = @import("std");
const stdout = std.io.getStdOut().writer();
pub fn main() !void {
    const name: []const u8 = "Pedro";
    try stdout.print("{any}\n", .{std.mem.eql(u8, name, "Pedro")});
}
