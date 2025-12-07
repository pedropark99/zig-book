const std = @import("std");
const builtin = @import("builtin");

fn read_file(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var file_buffer = try allocator.alloc(u8, 1024);
    defer allocator.free(file_buffer);
    @memset(file_buffer[0..], 0);

    const nbytes = try file.read(file_buffer[0..]);
    return try allocator.dupe(u8, file_buffer[0..nbytes]);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const path = "./ZigExamples/file-io/shop-list.txt";
    const file_contents = try read_file(allocator, path);
    defer allocator.free(file_contents);
    const slice = file_contents[0..file_contents.len];

    std.debug.print("{s}", .{slice});
}
