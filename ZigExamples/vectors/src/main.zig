const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const Random = std.crypto.random;
    const n: usize = 100;
    var A: [n][]u64 = undefined;
    var B: [n][]u64 = undefined;
    var C: [n][]u64 = undefined;
    for (0..n) |i| {
        A[i] = try allocator.alloc(u64, n);
        B[i] = try allocator.alloc(u64, n);
        C[i] = try allocator.alloc(u64, n);
        defer allocator.free(A[i]);
        defer allocator.free(B[i]);
        defer allocator.free(C[i]);

        for (0..n) |j| {
            const random_num = Random.int(u8);
            A[i].ptr[j] = random_num;
            B[i].ptr[j] = random_num;
            C[i].ptr[j] = 0;
        }
    }

    try stdout.print("{any}\n", .{A[0].ptr[0]});
    // try print_matrix(A, "A");

    // var Aar: [10]u64 = undefined;
    // var Bar: [10]u64 = undefined;
    // for (0..n) |i| {
    //     for (0..n) |j| {
    //         var k: usize = 0;
    //         while (k < n) : (k += 10) {
    //             @memcpy(&Aar, A[i][k..(k + 10)]);
    //             Bar[0] = B[k][j];
    //             Bar[1] = B[k + 1][j];
    //             Bar[2] = B[k + 2][j];
    //             Bar[3] = B[k + 3][j];
    //             Bar[4] = B[k + 4][j];
    //             Bar[5] = B[k + 5][j];
    //             Bar[6] = B[k + 6][j];
    //             Bar[7] = B[k + 7][j];
    //             Bar[8] = B[k + 8][j];
    //             Bar[9] = B[k + 9][j];
    //             const Av: @Vector(10, u64) = Aar;
    //             const Bv: @Vector(10, u64) = Bar;
    //             const result = Av * Bv;
    //             C[i][j] += @reduce(.Add, result);
    //         }
    //     }
    // }
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
