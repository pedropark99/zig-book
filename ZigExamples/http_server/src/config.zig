const std = @import("std");
const builtin = @import("builtin");

pub const SocketConfig = struct {
    _address: std.Io.net.IpAddress,
    _socket: std.Io.net.Socket,

    pub fn init() !SocketConfig {
        const addr = try std.Io.net.IpAddress.parseIp4("127.0.0.1", 3490);
        const socket = try std.posix.socket(4, std.posix.SOCK.STREAM, std.posix.IPPROTO.TCP);

        return SocketConfig{ ._address = addr, ._socket = socket };
    }
};
