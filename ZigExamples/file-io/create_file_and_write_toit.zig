const std = @import("std");
pub fn main() !void {
    const cwd = std.fs.cwd();
    const file = try cwd.createFile("foo.txt", .{});
    defer file.close();
    // Do things with the file ...
    var fw = file.writer();
    _ = try fw.writeAll("Writing this line to the file\n");
}
