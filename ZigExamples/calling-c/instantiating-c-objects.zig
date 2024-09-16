const std = @import("std");
const stdout = std.io.getStdOut().writer();
const c = @cImport({
    @cInclude("user.h");
});

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var new_user: c.User = undefined;
    new_user.id = 1;
    var user_name = try allocator.alloc(u8, 12);
    defer allocator.free(user_name);
    @memcpy(user_name[0..(user_name.len - 1)], "pedropark99");
    user_name[user_name.len - 1] = 0;
    new_user.name = user_name.ptr;

    try stdout.print("{any}\n", .{(new_user.name + 11).*});
}
