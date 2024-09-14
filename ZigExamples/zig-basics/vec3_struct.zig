const std = @import("std");
const math = std.math;
const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn distance(self: Vec3, other: Vec3) f64 {
        const xd = math.pow(f64, self.x - other.x, 2.0);
        const yd = math.pow(f64, self.y - other.y, 2.0);
        const zd = math.pow(f64, self.z - other.z, 2.0);
        return math.sqrt(xd + yd + zd);
    }

    pub fn double(self: *Vec3) void {
        self.x = self.x * 2.0;
        self.y = self.y * 2.0;
        self.z = self.z * 2.0;
    }
};

pub fn main() !void {
    var v1 = Vec3{
        .x = 4.2,
        .y = 2.4,
        .z = 0.9,
    };
    const v2 = Vec3{
        .x = 5.1,
        .y = 5.6,
        .z = 1.6,
    };

    std.debug.print("Distance: {d}\n", .{v1.distance(v2)});
    v1.double();
    std.debug.print("Doubled: {d}\n", .{v1.x});
}
