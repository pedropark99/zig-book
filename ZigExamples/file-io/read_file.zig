const std = @import("std");
const builtin = @import("builtin");

fn read_file(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    var reader_buffer: [1024]u8 = undefined;
    var file_buffer = try allocator.alloc(u8, 1024);
    @memset(file_buffer[0..], 0);

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var reader = file.reader(reader_buffer[0..]);
    const nbytes = try reader.read(
        file_buffer[0..]
    );
    return file_buffer[0..nbytes];
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const path = "./ZigExamples/file-io/shop-list.txt";
    const file_contents = try read_file(allocator, path);
    const slice = file_contents[0..file_contents.len];
    _ = slice;
}
