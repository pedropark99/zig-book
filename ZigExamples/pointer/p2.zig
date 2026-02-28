const std = @import("std");
const User = struct {
    id: u64,
    name: []const u8,
    email: []const u8,

    pub fn init(id: u64, name: []const u8, email: []const u8) User {
        return User{ .id = id, .name = name, .email = email };
    }

    pub fn print_name(self: User, stdout: *std.Io.Writer) !void {
        try stdout.print("{s}\n", .{self.name});
        try stdout.flush();
    }
};

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const u = User.init(1, "pedro", "email@gmail.com");
    const pointer = &u;
    try pointer.*.print_name(stdout);
}
