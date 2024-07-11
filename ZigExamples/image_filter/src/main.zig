const std = @import("std");
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});
const png = @cImport({
    @cInclude("spng.h");
});

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var buffer = try allocator.alloc(u8, 289477);
    defer allocator.free(buffer);
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }

    var file = try std.fs.cwd().openFile("pedro_pascal.png", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    const n_bytes = try in_stream.read(buffer[0..buffer.len]);
    _ = n_bytes;

    const ctx = png.spng_ctx_new(0);
    defer png.spng_ctx_free(ctx);
    _ = png.spng_set_png_buffer(ctx, @as([*c]u8, @ptrCast(buffer)), buffer.len);
    var out_size: usize = 0;
    _ = png.spng_decoded_image_size(ctx, png.SPNG_FMT_RGB8, &out_size);
    std.debug.print("Image size: {d}\n", .{out_size});

    var decoded_buffer = try allocator.alloc(u8, out_size);
    defer allocator.free(decoded_buffer);
    for (0..decoded_buffer.len) |i| {
        decoded_buffer[i] = 0;
    }

    _ = png.spng_decode_image(ctx, @as([*c]u8, @ptrCast(decoded_buffer)), decoded_buffer.len, png.SPNG_FMT_RGB8, 0);
    std.debug.print("Decoded: {any}\n", .{decoded_buffer[0..40]});

    const n_pixels = 36000;
    var cred: @Vector(n_pixels, u8) = undefined;
    var cblue: @Vector(n_pixels, u8) = undefined;
    var cgreen: @Vector(n_pixels, u8) = undefined;
    var index: u64 = 0;
    var count: u8 = 0;
    for (0..decoded_buffer.len) |i| {
        if (count == 0) {
            std.debug.print("{d}\n", .{i});
            cred[index] = decoded_buffer[i];
            index += 1;
            count += 1;
            continue;
        }
        if (count == 1) {
            cgreen[index] = decoded_buffer[i];
            index += 1;
            count += 1;
            continue;
        }

        cblue[index] = decoded_buffer[i];
        index += 1;
        count = 0;
    }

    // var gray_buffer = try allocator.alloc(u8, n_pixels);
    // defer allocator.free(gray_buffer);
}
