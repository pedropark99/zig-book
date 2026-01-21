const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var ages = std.StringHashMap(u8).init(allocator);

    defer ages.deinit();
    try ages.put("Pedro", 25);
    try ages.put("Matheus", 21);
    try ages.put("Abgail", 42);

    var it = ages.iterator();
    while (it.next()) |kv| {
        std.debug.print("Key: {s} | ", .{kv.key_ptr.*});
        std.debug.print("Age: {d}\n", .{kv.value_ptr.*});
    }
}
