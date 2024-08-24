const std = @import("std");
const Person = struct {
    name: []const u8,
    age: u8,
    height: f32,
};
const PersonArray = std.MultiArrayList(Person);

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var people = PersonArray{};
    defer people.deinit(allocator);

    try people.append(allocator, .{ .name = "Auguste", .age = 15, .height = 1.54 });
    try people.append(allocator, .{ .name = "Elena", .age = 26, .height = 1.65 });
    try people.append(allocator, .{ .name = "Michael", .age = 64, .height = 1.87 });

    var slice = people.slice();
    for (slice.items(.age)) |*age| {
        age.* += 10;
    }
}
