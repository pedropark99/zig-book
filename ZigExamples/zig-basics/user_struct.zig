const std = @import("std");
const User = struct {
    id: u64,
    name: []const u8,
    email: []const u8,

    pub fn init(id: u64, name: []const u8, email: []const u8) User {
        return User{ .id = id, .name = name, .email = email };
    }
};

pub fn main() !void {
    const u = User.init(1, "pedro", "pedrosomeemail@gmail.com");
    _ = u;
    const eu = User{ .id = 1, .name = "Pedro", .email = "someemail@gmail.com" };
    _ = eu;
}
