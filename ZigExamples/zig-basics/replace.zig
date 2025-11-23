const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const str1 = "Hello";
    var output: [5]u8 = undefined;
    const nrep = std.mem.replace(u8, str1, "el", "34", output[0..]);
    try stdout.print("New string: {s}\n", .{output});
    try stdout.print("N of replacements: {d}\n", .{nrep});
}
