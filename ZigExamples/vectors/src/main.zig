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

    const nv: usize = 10;
    var Aar: [nv]u64 = undefined;
    var Bar: [nv]u64 = undefined;
    for (0..n) |i| {
        for (0..n) |j| {
            var k: usize = 0;
            while (k < n) : (k += nv) {
                @memcpy(&Aar, A[i][k..(k + nv)]);
                for (0..nv) |l| {
                    Bar[l] = B[k + l][j];
                }
                const Av: @Vector(nv, u64) = Aar;
                const Bv: @Vector(nv, u64) = Bar;
                const result = Av * Bv;
                C[i][j] += @reduce(.Add, result);
            }
        }
    }

    for (0..n) |i| {
        allocator.free(A[i]);
        allocator.free(B[i]);
        allocator.free(C[i]);
    }
}

fn print_matrix(matrix: [100][]u64, name: []const u8) !void {
    try stdout.print("Matrix {s}\n\n", .{name});
    for (0..matrix.len) |i| {
        const row = matrix[i];
        _ = try stdout.write("| ");
        for (0..row.len) |j| {
            try stdout.print("{d} | ", .{row[j]});
        }
        _ = try stdout.write("\n-----------------------------------------------------------------------------------\n");
    }
}
