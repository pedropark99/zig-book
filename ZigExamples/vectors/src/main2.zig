const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const Random = std.crypto.random;
    const n: usize = 1000;
    var A: [n][]u64 = undefined;
    var B: [n][]u64 = undefined;
    var C: [n][]u64 = undefined;
    for (0..n) |i| {
        A[i] = try allocator.alloc(u64, n);
        B[i] = try allocator.alloc(u64, n);
        C[i] = try allocator.alloc(u64, n);
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

    for (0..n) |i| {
        allocator.free(A[i]);
        allocator.free(B[i]);
        allocator.free(C[i]);
    }
}
