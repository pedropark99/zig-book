const std = @import("std");
const Socket = std.Io.net.Socket;
const Protocol = std.Io.net.Protocol;

const Request = @import("request.zig");
const Response = @import("response.zig");
const Method = Request.Method;
const Server = @import("server.zig").Server;


pub fn main() !void {
    var alloc = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = alloc.allocator();

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    var threaded: std.Io.Threaded = .init(gpa);
    const io = threaded.io();
    defer threaded.deinit();

    const server = try Server.init(io);
    var listening = try server.listen();
    const connection = try listening.accept(io);
    defer connection.close(io);

    var request_buffer: [400]u8 = undefined;
    try Request.read_request(
        io,
        connection,
        request_buffer[0..request_buffer.len]
    );
    const request = Request.parse_request(request_buffer[0..request_buffer.len]);

    request_buffer[buffer.len - 1] = '\n';
    _ = try stdout.writeAll(buffer[0..]);
    try stdout.flush();

    if (request.method == Method.GET) {
        if (std.mem.eql(u8, request.uri, "/")) {
            try Response.send_200(connection, io);
        } else {
            try Response.send_404(connection, io);
        }
    }
}

