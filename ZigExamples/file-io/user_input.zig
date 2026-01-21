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

    // Read user input until a line break is found.
    const stream = try stdin.takeDelimiterExclusive('\n');
    // Store the input into our heap memory.
    @memcpy(input[0..stream.len], stream[0..]);
    // Print our heap memory, so that we can see what
    // was stored in it.
    std.debug.print("{s}\n", .{input});
}
