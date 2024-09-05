const std = @import("std");
const stdout = std.io.getStdOut().writer();
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});
const png = @cImport({
    @cInclude("spng.h");
});

fn get_image_header(ctx: *png.spng_ctx) !png.spng_ihdr {
    var image_header: png.spng_ihdr = undefined;
    if (png.spng_get_ihdr(ctx, &image_header) != 0) {
        return error.CouldNotGetImageHeader;
    }

    return image_header;
}

fn calc_output_size(ctx: *png.spng_ctx) !u64 {
    var output_size: u64 = 0;
    const status = png.spng_decoded_image_size(ctx, png.SPNG_FMT_RGBA8, &output_size);
    if (status != 0) {
        return error.CouldNotCalcOutputSize;
    }
    return output_size;
}

fn read_data_to_buffer(ctx: *png.spng_ctx, buffer: []u8) !void {
    const status = png.spng_decode_image(ctx, buffer.ptr, buffer.len, png.SPNG_FMT_RGBA8, 0);

    if (status != 0) {
        return error.CouldNotDecodeImage;
    }
}

fn apply_image_filter(buffer: []u8) !void {
    const len = buffer.len;
    const red_factor: f16 = 0.2126;
    const green_factor: f16 = 0.7152;
    const blue_factor: f16 = 0.0722;
    var index: u64 = 0;
    while (index < (len - 4)) : (index += 4) {
        const rf: f16 = @floatFromInt(buffer[index]);
        const gf: f16 = @floatFromInt(buffer[index + 1]);
        const bf: f16 = @floatFromInt(buffer[index + 2]);
        const y_linear: f16 = ((rf * red_factor) + (gf * green_factor) + (bf * blue_factor));
        buffer[index] = @intFromFloat(y_linear);
        buffer[index + 1] = @intFromFloat(y_linear);
        buffer[index + 2] = @intFromFloat(y_linear);
    }
}

fn save_png(image_header: *png.spng_ihdr, buffer: []u8) !void {
    const path = "pedro_pascal_filter.png";
    const file_descriptor = c.fopen(path.ptr, "wb");
    if (file_descriptor == null) {
        return error.CouldNotOpenFile;
    }
    const ctx = (png.spng_ctx_new(png.SPNG_CTX_ENCODER) orelse unreachable);
    defer png.spng_ctx_free(ctx);
    _ = png.spng_set_png_file(ctx, @ptrCast(file_descriptor));
    _ = png.spng_set_ihdr(ctx, image_header);

    const encode_status = png.spng_encode_image(ctx, buffer.ptr, buffer.len, png.SPNG_FMT_PNG, png.SPNG_ENCODE_FINALIZE);
    if (encode_status != 0) {
        return error.CouldNotEncodeImage;
    }
    if (c.fclose(file_descriptor) != 0) {
        return error.CouldNotCloseFileDescriptor;
    }
}

pub fn main() !void {
    const path = "pedro_pascal.png";
    const file_descriptor = c.fopen(path, "rb");
    if (file_descriptor == null) {
        @panic("Could not open file!");
    }
    const ctx = png.spng_ctx_new(0) orelse unreachable;
    _ = png.spng_set_png_file(ctx, @ptrCast(file_descriptor));

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var image_header = try get_image_header(ctx);
    const output_size = try calc_output_size(ctx);
    var buffer = try allocator.alloc(u8, output_size);
    @memset(buffer[0..], 0);

    try read_data_to_buffer(ctx, buffer[0..]);
    try apply_image_filter(buffer[0..]);
    try save_png(&image_header, buffer[0..]);
}
