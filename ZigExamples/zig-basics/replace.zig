const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const str1 = "Hello";
    var output: [5]u8 = undefined;
    const nrep = std.mem.replace(u8, str1, "el", "34", output[0..]);
    try stdout.print("New string: {s}\n", .{output});
    try stdout.print("N of replacements: {d}\n", .{nrep});
}
