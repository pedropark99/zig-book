const std = @import("std");
const builtin = @import("builtin");

fn read_file(path: []const u8, buffer: []u8, io: std.Io) !usize {
    const file = try std.Io.Dir.cwd().openFile(
        io, path, .{}
    );
    defer file.close(io);

    const nbytes = try file.readPositionalAll(
        io, buffer[0..], 0
    );
    return nbytes;
}

pub fn main(init: std.process.Init) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var file_buffer = try allocator.alloc(u8, 1024);
    defer allocator.free(file_buffer);
    @memset(file_buffer[0..], 0);

    const path = "./ZigExamples/file-io/shop-list.txt";
    const nbytes = try read_file(
        path, file_buffer[0..], init.io
    );

    std.debug.print("{s}", .{file_buffer[0..nbytes]});
}
