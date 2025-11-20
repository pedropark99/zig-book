const std = @import("std");
const Socket = std.Io.net.Socket;
const Protocol = std.Io.net.Protocol;

pub const HTTPServer = struct {
    host: []const u8,
    port: u16,
    addr: std.Io.net.IpAddress,
    io: std.Io,

    pub fn init(io: std.Io) !HTTPServer {
        const host: []const u8 = "127.0.0.1";
        const port: u16 = 3490;
        const addr = try std.Io.net.IpAddress.parseIp4(
            host, port
        );

        return .{.host=host, .port=port, .addr=addr, .io=io};
    }

    pub fn listen(self: HTTPServer) !std.Io.net.Server {
        std.debug.print("Server Addr: {s}:{any}\n", .{self.host, self.port});
        return try self.addr.listen(
            self.io,
            .{.mode=Socket.Mode.stream, .protocol=Protocol.tcp}
        );
    }
};
