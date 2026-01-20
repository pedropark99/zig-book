const std = @import("std");
const AutoHashMap = std.hash_map.AutoHashMap;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var hash_table = AutoHashMap(u32, u32).init(allocator);
    defer hash_table.deinit();

    try hash_table.put(54321, 89);
    try hash_table.put(50050, 55);
    try hash_table.put(57709, 41);

    std.debug.print("N of values stored: {d}\n", .{hash_table.count()});
    std.debug.print("Value at key 50050: {d}\n", .{hash_table.get(50050).?});

    if (hash_table.remove(57709)) {
        std.debug.print("Value at key 57709 succesfully removed!\n", .{});
    }
    std.debug.print("N of values stored: {d}\n", .{hash_table.count()});
}
