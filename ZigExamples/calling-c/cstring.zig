const std = @import("std");

pub fn main() !void {
    const zig_string: []const u8 = "test";
    // Every pointer type casting is made with the @ptrCast() function.
    const c_string: [*c]const u8 = @ptrCast(zig_string);
    _ = c_string;
    // Pointer type casting cannot be done only with @as(), the @ptrCast() function must be involved.
    // This is why the expression below does not compile succesfully.
    const v2 = @as([*c]const u8, zig_string);
    _ = v2;
}
