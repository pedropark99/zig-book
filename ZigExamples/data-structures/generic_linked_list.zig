const std = @import("std");
const Allocator = std.mem.Allocator;

fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            value: T,
            next: ?*Node = null,
        };

        const self = @This();
        first: ?*Node = null,

        pub fn insert(list: *self, new_node: *Node) void {
            new_node.next = list.first;
            list.first = new_node;
        }
    };
}

pub fn main() !void {
    const Listu32 = LinkedList(u32);
    var list = Listu32{};
    var n1 = Listu32.Node{ .value = 1 };
    list.insert(&n1);
}
