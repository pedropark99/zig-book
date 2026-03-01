const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const str1 = "Hello";
    var output: [5]u8 = undefined;
    const nrep = std.mem.replace(u8, str1, "el", "34", output[0..]);
    try stdout.print("New string: {s}\n", .{output});
    try stdout.print("N of replacements: {d}\n", .{nrep});
    try stdout.flush();
}
