const std = @import("std");
const stdout = std.io.getStdOut().writer();
const User = struct {
    id: u64,
    name: []const u8,
    email: []const u8,

    pub fn init(id: u64, name: []const u8, email: []const u8) User {
        return User{ .id = id, .name = name, .email = email };
    }

    pub fn print_name(self: User) !void {
        try stdout.print("{s}\n", .{self.name});
    }
};

pub fn main() !void {
    const u = User.init(1, "pedro", "email@gmail.com");
    const pointer = &u;
    try pointer.*.print_name();
}
