const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const NodeU32 = struct {
    data: u32,
    node: std.SinglyLinkedList.Node = .{},
};

pub fn main() !void {
    var list: std.SinglyLinkedList = .{};
    var one: NodeU32 = .{ .data = 1 };
    var two: NodeU32 = .{ .data = 2 };
    var three: NodeU32 = .{ .data = 3 };
    var five: NodeU32 = .{ .data = 5 };

    list.prepend(&two.node); // {2}
    two.node.insertAfter(&five.node); // {2, 5}
    two.node.insertAfter(&three.node); // {2, 3, 5}
    list.prepend(&one.node); // {1, 2, 3, 5}

    try stdout.print("Number of nodes: {}", .{list.len()});
    try stdout.flush();
}
