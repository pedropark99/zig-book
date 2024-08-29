const std = @import("std");
const stdout = std.io.getStdOut().writer();
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});
const png = @cImport({
    @cInclude("spng.h");
});

const ImageHeader = struct { width: u32, height: u32, bit_depth: u32, color_type: u32 };
const ImageData = struct {
    data: []u8,
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
    };
}

fn see_image_properties(image_header: ImageHeader) !void {
    try stdout.print("width: {d}, height: {d}, bit depth: {d}\n", .{ image_header.width, image_header.height, image_header.bit_depth });
}

fn calc_output_size(ctx: *png.spng_ctx) !u64 {
    var output_size: u64 = 0;
    const status = png.spng_decoded_image_size(ctx, png.SPNG_FMT_RGB8, &output_size);
    if (status != 0) {
        return error.CouldNotCalcOutputSize;
    }
    return output_size;
}

fn _read_data_to_buffer(ctx: *png.spng_ctx, buffer: []u8) !void {
    const status = png.spng_decode_image(ctx, @as([*c]u8, @ptrCast(buffer)), buffer.len, png.SPNG_FMT_RGB8, 0);
    if (status != 0) {
        return error.CouldNotDecodeImage;
    }
}

pub fn read_png(allocator: std.mem.Allocator, path: []const u8) !ImageData {
    const path_cstr: [:0]const u8 = @ptrCast(path);
    const file_descriptor = c.fopen(path_cstr, @as([*c]const u8, @ptrCast("rb")));
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
        .header = image_header,
    };
}

fn apply_image_filter(image_data: *ImageData) !void {
    try stdout.print("teste", .{});
    const n_pixels = image_data.header.height * image_data.header.width;
    try stdout.print("Pixels: {d}\n", .{n_pixels});
    var as_float: f16 = 0.0;
    const red_factor: f16 = 0.299;
    const green_factor: f16 = 0.587;
    const blue_factor: f16 = 0.114;
    var index: u64 = 0;
    while (index < (n_pixels - 3)) : (index += 3) {
        as_float = @floatFromInt(image_data.data[index]);
        image_data.data[index] = @intFromFloat(as_float * red_factor);
        as_float = @floatFromInt(image_data.data[index + 1]);
        image_data.data[index + 1] = @intFromFloat(as_float * green_factor);
        as_float = @floatFromInt(image_data.data[index + 2]);
        image_data.data[index + 2] = @intFromFloat(as_float * blue_factor);
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var image_data = try read_png(allocator, "ZigExamples/image_filter/pedro_pascal.png");
    // try apply_image_filter(&image_data);

    image_data.deinit(allocator);
}
