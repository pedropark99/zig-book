const std = @import("std");
const io = std.testing.io;
var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var input = try allocator.alloc(u8, 50);
    defer allocator.free(input);
    @memset(input[0..], 0);

    // Read user input
    stdin.readSliceAll(input[0..]) catch |err| switch(err) {
        // Reached end of input, do nothing else
        error.EndOfStream => {},
        // If it's other kind of error, then return it
        else => return err,
    };
    std.debug.print("{s}\n", .{input});
}

