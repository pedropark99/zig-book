const std = @import("std");

const stdout = std.io.getStdOut().writer();

fn p(r: u8, g: u8, b: u8) Pixel {
    return Pixel{
        .red = r,
        .green = g,
        .blue = b,
    };
}
const Pixel = struct {
    red: u8,
    green: u8,
    blue: u8,
};

pub fn main() !void {
    const matrix = [_]Pixel{
        p(201, 10, 25),  p(185, 65, 70),
        p(65, 120, 110), p(65, 120, 117),
        p(98, 95, 12),   p(213, 26, 88),
        p(143, 112, 65), p(97, 99, 205),
        p(234, 105, 56), p(43, 44, 216),
        p(45, 59, 243),  p(211, 209, 54),
    };
    const row_num = 1;
    const col_num = 2;
    const index = (row_num * 4) + col_num;
    try stdout.print("Pixel at 2nd row and 3rd column: {any}\n", .{matrix[index]});
}
