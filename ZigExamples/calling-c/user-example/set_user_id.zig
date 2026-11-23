const std = @import("std");
const c = @import("c");

fn set_user_id(id: u64, user: *c.User) void {
    user.*.id = id;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();

    var new_user: c.User = undefined;
    new_user.id = 1;
    var user_name = try allocator.alloc(u8, 12);
    defer allocator.free(user_name);
    @memcpy(user_name[0..(user_name.len - 1)], "pedropark99");
    user_name[user_name.len - 1] = 0;
    new_user.name = user_name.ptr;

    try stdout.print("Previous user id: {any}\n", .{new_user.id});
    set_user_id(25, &new_user);
    try stdout.print("New user id: {any}\n", .{new_user.id});
    try stdout.flush();
}
