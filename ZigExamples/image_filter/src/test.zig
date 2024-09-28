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
    var rv: @Vector(1080000, f16) = @splat(0.0);
    var gv: @Vector(1080000, f16) = @splat(0.0);
    var bv: @Vector(1080000, f16) = @splat(0.0);

    var index: usize = 0;
    var vec_index: usize = 0;
    while (index < (len - 4)) : (index += 4) {
        rv[vec_index] = @floatFromInt(buffer[index]);
        gv[vec_index + 1] = @floatFromInt(buffer[index + 1]);
        bv[vec_index + 2] = @floatFromInt(buffer[index + 2]);
        vec_index += 3;
    }

    const rfactor: @Vector(1080000, f16) = @splat(0.2126);
    const gfactor: @Vector(1080000, f16) = @splat(0.7152);
    const bfactor: @Vector(1080000, f16) = @splat(0.0722);
    rv = rv * rfactor;
    gv = gv * gfactor;
    bv = bv * bfactor;
    const result = rv + gv + bv;
    try stdout.print("{any}\n", .{result});
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
    const output_size = try calc_output_size(ctx);
    var buffer = try allocator.alloc(u8, output_size);
    @memset(buffer[0..], 0);

    try read_data_to_buffer(ctx, buffer[0..]);
    try apply_image_filter(buffer[0..]);
}
