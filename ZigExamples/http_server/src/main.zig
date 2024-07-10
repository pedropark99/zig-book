const std = @import("std");
const SocketConf = @import("config.zig");
const Request = @import("request.zig");
const Response = @import("response.zig");
const Method = Request.Method;
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const socket = try SocketConf.Socket.init();
    try stdout.print("Server Addr: {any}\n", .{socket._address});
    var server = try socket._address.listen(.{});
    const connection = try server.accept();

    var buffer: [1000]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }
    try Request.read_request(connection, buffer[0..buffer.len]);
    const request = Request.parse_request(buffer[0..buffer.len]);
    if (request.method == Method.GET) {
        if (std.mem.eql(u8, request.uri, "/")) {
            Response.resp_200(connection);
        } else {
            Response.resp_404(connection);
        }
    }
}

// const reader = incoming_connection.stream.reader();
// _ = try reader.read(&buffer);
// try stdout.print("{s}\n", .{buffer});
// _ = try incoming_connection.stream.write("HTTP/1.1 200 OK\nContent-Length: 48\nContent-Type: text/html\nConnection: Closed\n\n<html><body><h1>Hello, World!</h1></body></html>");
