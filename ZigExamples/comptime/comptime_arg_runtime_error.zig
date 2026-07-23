const std = @import("std");
fn twice(comptime num: u32) u32 {
    return num * 2;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    var stdin_buffer: [10]u8 = undefined;
    @memset(stdin_buffer[0..], 0);
    var stdin_reader = std.Io.File.stdin().reader(init.io, &stdin_buffer);
    const stdin = &stdin_reader.interface;

    _ = try stdout.write("Please write a 4-digit integer number\n");
    try stdout.flush();
    const buffer = try stdin.takeDelimiterExclusive('\n');

    try stdout.print("Input: {s}\n", .{buffer[0..4]});
    try stdout.flush();
    const n: u32 = try std.fmt.parseInt(
        u32, buffer[0..4], 10
    );
    const twice_result = twice(n);
    try stdout.print("Result: {d}\n", .{twice_result});
    try stdout.flush();
}
