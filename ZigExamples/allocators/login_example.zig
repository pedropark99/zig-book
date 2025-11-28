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

    for (0..input.len) |i| {
        input[i] = 0; // initialize all fields to zero.
    }

    _ = try stdin.takeDelimiterExclusive(
        '\n'
    );

    std.debug.print("{s}\n", .{input});
}
