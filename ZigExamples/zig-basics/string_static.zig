const std = @import("std");
pub fn main() !void {
    const string_obj: []const u8 = "Testing";
    std.debug.print("{any}\n", .{@TypeOf(string_obj)});
    std.debug.print("{any}\n", .{@TypeOf(string_obj[0..3])});
    std.debug.print("{any}\n", .{@TypeOf("Some string literal")});
}
