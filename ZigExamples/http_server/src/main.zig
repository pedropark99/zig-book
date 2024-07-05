const std = @import("std");
const stdout = std.io.getStdOut().writer();
const HTTPConf = @import("config.zig");

pub fn main() !void {
    var buffer: [1000]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const server_conf = try HTTPConf.ServerConfig.init(allocator);
    try stdout.print("Server Addr: {any}\n", .{server_conf._address});
    var server = try server_conf._address.listen(.{});
    const incoming_connection = try server.accept();
    const reader = incoming_connection.stream.reader();
    _ = try reader.read(&buffer);
    try stdout.print("{s}\n", .{buffer});
    _ = try incoming_connection.stream.write("HTTP/1.1 200 OK\nContent-Length: 48\nContent-Type: text/html\nConnection: Closed\n\n<html><body><h1>Hello, World!</h1></body></html>");
}
