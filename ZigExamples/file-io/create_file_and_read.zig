const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(init.io, "foo.txt", .{ .read = true });
    defer file.close(init.io);
    _ = try file.writePositionalAll(init.io, "We are going to read this line", 0);

    var buffer: [300]u8 = undefined;
    @memset(buffer[0..], 0);

    var read_buffer: [1024]u8 = undefined;
    var fr = file.reader(init.io, &read_buffer);
    var reader = &fr.interface;

    _ = reader.readSliceAll(buffer[0..]) catch 0;

    try stdout.print("What we read from the file: {s}\n", .{buffer});
    try stdout.flush();
}
