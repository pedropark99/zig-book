const std = @import("std");
const stdout = std.io.getStdOut().writer();

fn print(input: []const u8) !void {
    try stdout.print("{s}\n", .{input});
}

const Base64 = struct {
    table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers = "0123456789+/";
        return Base64{
            .table = upper ++ lower ++ numbers,
        };
    }

    pub fn char_at(self: Base64, index: u8) u8 {
        return self.table[index];
    }
};

fn calc_output_length(input_length: usize) u8 {
    const as_float: f64 = @floatFromInt(input_length);
    const d = as_float / 3.0;
    return @intFromFloat(@ceil(d));
}

fn decode(allocator: std.mem.Allocator, input: []const u8) !void {
    try stdout.print("Start decoding of {s}\n", .{input});
    // var output = [_]u8{ 0, 0, 0, 0 };
    // _ = output;
    if (input.len == 0) return;
    const n_windows = calc_output_length(input.len);
    var bytes_to_convert = try allocator.alloc(u8, n_windows * 3);
    for (bytes_to_convert, 0..) |_, i| {
        bytes_to_convert[i] = 0;
    }
    for (input, 0..) |_, i| {
        bytes_to_convert[i] = input[i];
    }
    try print(bytes_to_convert);
}

pub fn main() !void {
    const text = "Hi";
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    try decode(allocator, text);
}
