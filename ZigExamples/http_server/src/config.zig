const std = @import("std");
const builtin = @import("builtin");
const net = @import("std").net;
const Allocator = std.mem.Allocator;

pub const ServerConfig = struct {
    _address: std.net.Address,
    _stream: std.net.Stream,
    _allocator: Allocator,

    pub fn init(allocator: Allocator) !ServerConfig {
        const host = [4]u8{ 127, 0, 0, 1 };
        const port = 3490;
        const addr = net.Address.initIp4(host, port);
        const socket = try std.posix.socket(addr.any.family, std.posix.SOCK.STREAM, std.posix.IPPROTO.TCP);
        const stream = net.Stream{ .handle = socket };
        return ServerConfig{ ._address = addr, ._stream = stream, ._allocator = allocator };
    }
};
