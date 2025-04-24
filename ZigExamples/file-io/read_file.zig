const std = @import("std");
const builtin = @import("builtin");

fn read_file(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    return try file.reader().readAllAlloc(allocator, std.math.maxInt(usize));
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const path = "./ZigExamples/file-io/shop-list.txt";
    const file_contents = try read_file(allocator, path);
    const slice = file_contents[0..file_contents.len];
    _ = slice;
}
