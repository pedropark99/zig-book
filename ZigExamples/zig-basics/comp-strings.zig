const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const name: []const u8 = "Pedro";
    try stdout.print("{any}\n", .{std.mem.eql(u8, name, "Pedro")});
}
