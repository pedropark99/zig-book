const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.openFile(init.io, "foo.txt", .{ .mode = .write_only });
    defer file.close(init.io);

    const length = try file.length(init.io);
    _ = try file.writePositionalAll(init.io, "Some random text to write\n", length);
}
