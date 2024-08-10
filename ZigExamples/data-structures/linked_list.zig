const std = @import("std");
const testing = std.testing;
const SinglyLinkedList = std.SinglyLinkedList;
const Lu32 = SinglyLinkedList(u32);

pub fn main() !void {
    var list = Lu32{};
    var one = Lu32.Node{ .data = 1 };
    var two = Lu32.Node{ .data = 2 };
    var three = Lu32.Node{ .data = 3 };
    var four = Lu32.Node{ .data = 4 };
    var five = Lu32.Node{ .data = 5 };

    list.prepend(&two); // {2}
    two.insertAfter(&five); // {2, 5}
    list.prepend(&one); // {1, 2, 5}
    two.insertAfter(&three); // {1, 2, 3, 5}
    three.insertAfter(&four); // {1, 2, 3, 4, 5}
}
