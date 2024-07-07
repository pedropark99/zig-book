const std = @import("std");
const Connection = std.net.Server.Connection;

pub fn read_request(conn: Connection) !void {
    var buffer: [1000]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }
    const reader = conn.stream.reader();
    _ = try reader.read(&buffer);
    std.debug.print("{s}\n", .{buffer});
    parse_request(&buffer);
}

const Method = enum { GET, POST };

const Header = struct {
    version: []const u8,
    method: Method,
    uri: []const u8,
};

fn parse_request(text: *[1000]u8) void {
    var iterator = std.mem.splitScalar(u8, text, ' ');
    var method = Method.GET;
    var field = iterator.next();
    method = parse_method(field);
    std.debug.print("{any}\n", .{method});
    field = iterator.next();
    std.debug.print("{?s}\n", .{field});
}

fn parse_method(text: ?[]const u8) Method {
    if (std.mem.eql(u8, text.?, "GET")) {
        return Method.GET;
    }
    return Method.POST;
}
