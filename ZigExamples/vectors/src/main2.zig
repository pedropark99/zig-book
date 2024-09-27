const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const Random = std.crypto.random;
    const n: usize = 100;
    var A: [n][]u64 = undefined;
    var B: [n][]u64 = undefined;
    var C: [n][]u64 = undefined;

    for (0..n) |i| {
        for (0..n) |j| {
            const random_num = Random.int(u8);
            A[i][j] = random_num;
            B[i][j] = random_num;
            C[i][j] = 0;
        }
    }

    for (0..n) |i| {
        for (0..n) |j| {
            for (0..n) |k| {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}
