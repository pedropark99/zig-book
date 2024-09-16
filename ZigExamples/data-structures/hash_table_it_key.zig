const std = @import("std");
const AutoHashMap = std.hash_map.AutoHashMap;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var hash_table = AutoHashMap(u32, u16).init(allocator);
    defer hash_table.deinit();

    try hash_table.put(54321, 89);
    try hash_table.put(50050, 55);
    try hash_table.put(57709, 41);

    var kit = hash_table.keyIterator();
    while (kit.next()) |key| {
        std.debug.print("Key: {d}\n", .{key.*});
    }
}
