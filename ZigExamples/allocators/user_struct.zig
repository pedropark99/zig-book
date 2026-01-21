const std = @import("std");
const User = struct {
    id: usize,
    name: []const u8,

    pub fn init(id: usize, name: []const u8) User {
        return .{ .id = id, .name = name };
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const user = try allocator.create(User);
    defer allocator.destroy(user);

    user.* = User.init(0, "Pedro");
}
