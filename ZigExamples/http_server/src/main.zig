const std = @import("std");
const Socket = std.Io.net.Socket;
const Protocol = std.Io.net.Protocol;

const Request = @import("request.zig");
const Response = @import("response.zig");
const Method = Request.Method;

pub fn main() !void {
    var alloc = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = alloc.allocator();

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    var threaded: std.Io.Threaded = .init(gpa);
    const io = threaded.io();
    defer threaded.deinit();

    const host: []const u8 = "127.0.0.1";
    const port: u16 = 3490;
    const addr = try std.Io.net.IpAddress.parseIp4(
        host, port
    );
    std.debug.print("Server Addr: {s}:{any}\n", .{host, port});

    var server = try addr.listen(
        io,
        .{.mode=Socket.Mode.stream, .protocol=Protocol.tcp}
    );

    const connection = try server.accept(io);
    defer connection.close(io);

    var buffer: [10000]u8 = undefined;
    @memset(buffer[0..], 0);
    try Request.read_request(connection, io, buffer[0..buffer.len]);
    const request = Request.parse_request(buffer[0..buffer.len]);

    _ = try stdout.write(buffer[0..]);

    if (request.method == Method.GET) {
        if (std.mem.eql(u8, request.uri, "/")) {
            try Response.send_200(connection, io);
        } else {
            try Response.send_404(connection, io);
        }
    }
}

// const reader = incoming_connection.stream.reader();
// _ = try reader.read(&buffer);
// try stdout.print("{s}\n", .{buffer});
