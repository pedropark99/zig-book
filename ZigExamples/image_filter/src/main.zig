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
    var cred: @Vector(n_pixels, f16) = undefined;
    var cblue: @Vector(n_pixels, f16) = undefined;
    var cgreen: @Vector(n_pixels, f16) = undefined;
    var index: u64 = 0;
    var channel_index: u64 = 0;
    while (index < (n_pixels - 3)) : (index += 3) {
        cred[channel_index] = @floatFromInt(decoded_buffer[index]);
        cgreen[channel_index] = @floatFromInt(decoded_buffer[index + 1]);
        cblue[channel_index] = @floatFromInt(decoded_buffer[index + 2]);
        channel_index += 1;
    }

    var red_factor_as_array: [n_pixels]f16 = undefined;
    @memset(&red_factor_as_array, 0.299);
    var green_factor_as_array: [n_pixels]f16 = undefined;
    @memset(&green_factor_as_array, 0.587);
    var blue_factor_as_array: [n_pixels]f16 = undefined;
    @memset(&blue_factor_as_array, 0.114);

    const red_factor: @Vector(n_pixels, f16) = red_factor_as_array;
    const green_factor: @Vector(n_pixels, f16) = green_factor_as_array;
    const blue_factor: @Vector(n_pixels, f16) = blue_factor_as_array;

    // _ = red_factor;
    // _ = blue_factor;
    // _ = green_factor;

    cred = cred * red_factor;
    cgreen = cgreen * green_factor;
    cblue = cblue * blue_factor;
    std.debug.print("Red channel: {any}\n", .{cred[1]});
}
