const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;
    const cwd = std.Io.Dir.cwd();
    const dir = try cwd.openDir(init.io, "ZigExamples/file-io/", .{ .iterate = true });
    var it = dir.iterate();
    while (try it.next(init.io)) |entry| {
        try stdout.print("File name: {s}\n", .{entry.name});
    }

    try stdout.flush();
}
