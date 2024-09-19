const c = @import("c.zig");

pub fn main() !void {
    const x: f32 = 1772.94122;
    _ = c.printf("%.3f\n", x);
}
