const std = @import("std");
pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(init.io, "foo.txt", .{});
    file.close(init.io);
}
