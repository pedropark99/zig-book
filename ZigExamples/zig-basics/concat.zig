const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const str1 = "Hello";
    const str2 = " you!";
    const str3 = try std.mem.concat(allocator, u8, &[_][]const u8{ str1, str2 });
    try stdout.print("{s}\n", .{str3});
}
