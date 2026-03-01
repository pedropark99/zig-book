const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(init.io, "foo.txt", .{});
    defer file.close(init.io);
    // Do things with the file ...
    _ = try file.writePositionalAll(init.io, "Writing this line to the file\n", 0);
}
