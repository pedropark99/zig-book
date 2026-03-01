const std = @import("std");

pub const User = struct {
    id: u64,
    name: []const u8,
    email: []const u8,

    pub fn init(id: u64, name: []const u8, email: []const u8) User {
        return User{ .id = id, .name = name, .email = email };
    }

    pub fn print_name(self: User) !void {
        std.debug.print("{s}\n", .{self.name});
    }
};

pub fn main() !void {
    const u = User.init(1, "pedro", "email@gmail.com");
    try u.print_name();
}
