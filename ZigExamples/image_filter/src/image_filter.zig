const std = @import("std");
const math = std.math;
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const cmath = @cImport({
    @cInclude("math.h");
});
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});
const png = @cImport({
    @cInclude("spng.h");
});

const ImageHeader = struct {
    width: u32,
    height: u32,
    bit_depth: u8,
    color_type: u8,
    compression_method: u8,
    filter_method: u8,
    interlace_method: u8,
};
const ImageData = struct {
    data: []u8,
    decoded_size: u64,
    header: ImageHeader,

    pub fn deinit(self: ImageData, allocator: std.mem.Allocator) void {
        allocator.free(self.data);
    }
};

fn get_image_header(ctx: *png.spng_ctx) !ImageHeader {
    var image_header: png.spng_ihdr = undefined;
    if (png.spng_get_ihdr(ctx, &image_header) != 0) {
        return error.CouldNotGetImageHeader;
    }

    return ImageHeader{
        .width = image_header.width,
        .height = image_header.height,
        .bit_depth = image_header.bit_depth,
        .color_type = image_header.color_type,
        .compression_method = image_header.compression_method,
        .filter_method = image_header.filter_method,
        .interlace_method = image_header.interlace_method,
    };
}

fn see_image_properties(image_header: ImageHeader) !void {
    try stdout.print("width: {d}, height: {d}, bit depth: {d}\n", .{ image_header.width, image_header.height, image_header.bit_depth });
}

fn calc_output_size(ctx: *png.spng_ctx) !u64 {
    var output_size: u64 = 0;
    const status = png.spng_decoded_image_size(ctx, png.SPNG_FMT_RGBA8, &output_size);
    if (status != 0) {
        return error.CouldNotCalcOutputSize;
    }
    return output_size;
}

fn _read_data_to_buffer(ctx: *png.spng_ctx, buffer: []u8) !void {
    const status = png.spng_decode_image(ctx, buffer.ptr, buffer.len, png.SPNG_FMT_RGBA8, 0);
    if (status != 0) {
        return error.CouldNotDecodeImage;
    }
}

pub fn read_png(allocator: std.mem.Allocator, path: []const u8) !ImageData {
    const file_descriptor = c.fopen(path.ptr, "rb");
    if (file_descriptor == null) {
        return error.CouldNotOpenFile;
    }

    const ctx = png.spng_ctx_new(0) orelse unreachable;
    defer png.spng_ctx_free(ctx);
    _ = png.spng_set_png_file(ctx, @ptrCast(file_descriptor));
    const image_header = try get_image_header(ctx);
    try see_image_properties(image_header);

    const output_size = try calc_output_size(ctx);
    var buffer = try allocator.alloc(u8, output_size);
    @memset(buffer[0..], 0);
    try _read_data_to_buffer(ctx, buffer[0..]);

    const close_status = c.fclose(file_descriptor);
    if (close_status != 0) {
        return error.CouldNotCloseFileDescriptor;
    }
    return ImageData{
        .data = buffer[0..],
        .decoded_size = output_size,
        .header = image_header,
    };
}

fn apply_image_filter(image_data: *ImageData) !void {
    const len = image_data.data.len;
    const red_factor: f16 = 0.2126;
    const green_factor: f16 = 0.7152;
    const blue_factor: f16 = 0.0722;
    var index: u64 = 0;
    while (index < (len - 4)) : (index += 4) {
        const rf: f16 = @floatFromInt(image_data.data[index]);
        const gf: f16 = @floatFromInt(image_data.data[index + 1]);
        const bf: f16 = @floatFromInt(image_data.data[index + 2]);
        const y_linear: f16 = (rf * red_factor) + (gf * green_factor) + (bf * blue_factor);
        image_data.data[index] = @intFromFloat(y_linear);
        image_data.data[index + 1] = @intFromFloat(y_linear);
        image_data.data[index + 2] = @intFromFloat(y_linear);
    }
}

fn save_png(image_data: *ImageData) !void {
    const path = "pedro_pascal_filter.png";
    const file_descriptor = c.fopen(path.ptr, "wb");
    const ctx = png.spng_ctx_new(png.SPNG_CTX_ENCODER) orelse unreachable;
    defer png.spng_ctx_free(ctx);
    _ = png.spng_set_png_file(ctx, @ptrCast(file_descriptor));

    // const image_width = image_data.decoded_size / image_data.header.height;
    var image_header: png.spng_ihdr = undefined;
    image_header.height = image_data.header.height;
    image_header.width = image_data.header.width;
    image_header.bit_depth = image_data.header.bit_depth;
    image_header.color_type = image_data.header.color_type;
    image_header.compression_method = image_data.header.compression_method;
    image_header.filter_method = image_data.header.filter_method;
    image_header.interlace_method = image_data.header.interlace_method;

    try stdout.print("Decoded size: {any}\n", .{image_data.decoded_size});
    try stdout.print("Buffer size: {any}\n", .{image_data.data.len});

    _ = png.spng_set_ihdr(ctx, &image_header);
    const encode_status = png.spng_encode_image(ctx, @as([*c]u8, @ptrCast(image_data.data)), image_data.data.len, png.SPNG_FMT_PNG, png.SPNG_ENCODE_FINALIZE);
    if (encode_status != 0) {
        const status: u32 = @intCast(encode_status);
        try stderr.print("Test: {any}\n", .{encode_status == png.SPNG_EFMT});
        try stderr.print("Error code: {d}\n", .{status});
        return error.CouldNotEncodeImage;
    }
    const close_status = c.fclose(file_descriptor);
    if (close_status != 0) {
        return error.CouldNotCloseFileDescriptor;
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var image_data = try read_png(allocator, "pedro_pascal.png");
    try apply_image_filter(&image_data);

    try save_png(&image_data);

    image_data.deinit(allocator);
}
