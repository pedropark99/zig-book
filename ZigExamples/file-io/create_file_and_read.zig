const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const cwd = std.fs.cwd();
    const io = std.testing.io;
    const file = try cwd.createFile(
        "foo.txt",
        .{ .read = true }
    );
    defer file.close();
    _ = try file.writeAll(
        "We are going to read this line\n"
    );

    var buffer: [300]u8 = undefined;
    @memset(buffer[0..], 0);

    try file.seekTo(0);
    var read_buffer: [1024]u8 = undefined;
    var fr = file.reader(io, &read_buffer);
    var reader = &fr.interface;

    _ = reader.readSliceAll(buffer[0..]) catch 0;

    try stdout.print("{s}\n", .{buffer});
    try stdout.flush();
}
