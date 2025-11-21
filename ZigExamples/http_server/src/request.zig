const std = @import("std");
const Stream = std.Io.net.Stream;

pub fn read_request(io: std.Io, conn: Stream, buffer: []u8) !void {
    var recv_buffer: [1024]u8 = undefined;
    var reader = conn.reader(io, &recv_buffer);
    const length: usize = 400;
    const input = try reader.interface.peekArray(length);
    @memcpy(buffer[0..length], input[0..length]);
}

const Map = std.static_string_map.StaticStringMap;
const MethodMap = Map(Method).initComptime(.{
    .{ "GET", Method.GET },
});
pub const Method = enum {
    GET,

    pub fn init(text: []const u8) !Method {
        return MethodMap.get(text).?;
    }

    pub fn is_supported(m: []const u8) bool {
        const method = MethodMap.get(m);
        if (method) |_| {
            return true;
        }
        return false;
    }
};

const Request = struct {
    method: Method,
    version: []const u8,
    uri: []const u8,

    pub fn init(method: Method, uri: []const u8, version: []const u8) Request {
        return Request{
            .method = method,
            .uri = uri,
            .version = version,
        };
    }
};

pub fn parse_request(text: []u8) Request {
    const line_index = std.mem.indexOfScalar(u8, text, '\n') orelse text.len;
    var iterator = std.mem.splitScalar(u8, text[0..line_index], ' ');
    const method = try Method.init(iterator.next().?);
    const uri = iterator.next().?;
    const version = iterator.next().?;
    const request = Request.init(method, uri, version);
    return request;
}

test "teste" {
    const a = "GET / HTTP/1.1\n";
    var iterator = std.mem.splitScalar(u8, a, ' ');
    try std.testing.expectEqualStrings("GET", iterator.next().?);
    try std.testing.expectEqualStrings("/", iterator.next().?);
    try std.testing.expectEqualStrings("HTTP/1.1\n", iterator.next().?);

    const index = std.mem.indexOfScalar(u8, a, '\n');
    try std.testing.expect(index == 14);
}
