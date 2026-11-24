const std = @import("std");
const math = std.math;

const c = @import("c");
const cmath = @import("cmath");
const png = @import("png");

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

const PngReader = struct {
    allocator: std.mem.Allocator,
    stdout: *std.Io.Writer,
    stderr: *std.Io.Writer,
    ctx: *png.spng_ctx,

    fn init(
        allocator: std.mem.Allocator,
        stdout_writer: *std.Io.Writer,
        stderr_writer: *std.Io.Writer
    ) PngReader {
        return PngReader{
            .allocator = allocator,
            .stdout = stdout_writer,
            .stderr = stderr_writer,
            .ctx = png.spng_ctx_new(0) orelse unreachable,
        };
    }

    fn deinit(self: *PngReader) void {
        defer png.spng_ctx_free(self.ctx);
    }

    fn read_png(self: *PngReader, path: []const u8) !ImageData {
        const file_descriptor = try fopen_file(
            path,
            "rb",
            self.stdout,
            self.stderr
        );
        _ = png.spng_set_png_file(self.ctx, @ptrCast(file_descriptor));
        const image_header = try self._get_image_header();
        try self._print_image_properties(image_header);

        const output_size = try self._calc_output_size();
        var buffer = try self.allocator.alloc(u8, output_size);
        @memset(buffer[0..], 0);
        try self._read_data_to_buffer(buffer[0..]);
        try fclose_file(
            file_descriptor,
            self.stdout,
            self.stderr
        );
        return ImageData{
            .data = buffer[0..],
            .decoded_size = output_size,
            .header = image_header,
        };
    }

    fn _print_image_properties(self: *PngReader, image_header: ImageHeader) !void {
        _ = try self.stdout.write("Image statistics:\n");
        try self.stdout.print(
            "  * Width: {d}\n  * Height: {d}\n  * Bit depth: {d}\n",
            .{ image_header.width, image_header.height, image_header.bit_depth }
        );
        try self.stdout.flush();
    }

    fn _get_image_header(self: *PngReader) !ImageHeader {
        _ = try self.stdout.write("Trying to get the header of the PNG file...\n");
        try self.stdout.flush();
        var image_header: png.spng_ihdr = undefined;
        if (png.spng_get_ihdr(self.ctx, &image_header) != 0) {
            return error.CouldNotGetImageHeader;
        }
        _ = try self.stdout.write("Header of PNG file retrieve succesfully\n");
        try self.stdout.flush();
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

    fn _read_data_to_buffer(self: *PngReader, buffer: []u8) !void {
        _ = try self.stdout.write("Decoding PNG file ...\n");
        try self.stdout.flush();
        const status = png.spng_decode_image(
            self.ctx,
            buffer.ptr,
            buffer.len,
            png.SPNG_FMT_RGBA8,
            0
        );
        if (status != 0) {
            return error.CouldNotDecodeImage;
        }
        _ = try self.stdout.write("PNG file read and decoded successfully\n");
        try self.stdout.flush();
    }

    fn _calc_output_size(self: *PngReader) !u64 {
        var output_size: u64 = 0;
        const status = png.spng_decoded_image_size(self.ctx, png.SPNG_FMT_RGBA8, &output_size);
        if (status != 0) {
            return error.CouldNotCalcOutputSize;
        }
        try self.stdout.print("Size of decoded PNG file in bytes: {d}\n", .{output_size});
        try self.stdout.flush();
        return output_size;
    }
};


const PngWriter = struct {
    allocator: std.mem.Allocator,
    stdout: *std.Io.Writer,
    stderr: *std.Io.Writer,
    ctx: *png.spng_ctx,
    image_header: *png.spng_ihdr,

    fn init(
        allocator: std.mem.Allocator,
        stdout_writer: *std.Io.Writer,
        stderr_writer: *std.Io.Writer
    ) PngWriter {
        return PngWriter{
            .allocator = allocator,
            .stdout = stdout_writer,
            .stderr = stderr_writer,
            .ctx = png.spng_ctx_new(png.SPNG_CTX_ENCODER) orelse unreachable,
            .image_header = undefined,
        };
    }

    fn deinit(self: *PngWriter) void {
        png.spng_ctx_free(self.ctx);
    }

    fn save_png(
        self: *PngWriter,
        image_data: *ImageData,
        path: []const u8
    ) !void {
        const file_descriptor = try fopen_file(
            path,
            "wb",
            self.stdout,
            self.stderr
        );
        _ = png.spng_set_png_file(self.ctx, @ptrCast(file_descriptor));
        self._build_image_header(image_data);
        _ = png.spng_set_ihdr(self.ctx, self.image_header);

        try self._print_image_properties(image_data);
        try self._encode_and_write_image(image_data);
        try fclose_file(
            file_descriptor,
            self.stdout,
            self.stderr
        );

    }

    fn _build_image_header(self: *PngWriter, image_data: *ImageData) void {
        self.image_header.height = image_data.header.height;
        self.image_header.width = image_data.header.width;
        self.image_header.bit_depth = image_data.header.bit_depth;
        self.image_header.color_type = image_data.header.color_type;
        self.image_header.compression_method = image_data.header.compression_method;
        self.image_header.filter_method = image_data.header.filter_method;
        self.image_header.interlace_method = image_data.header.interlace_method;
    }

    fn _print_image_properties(self: *PngWriter, image_data: *ImageData) !void {
        _ = try self.stdout.write("Decoded image data statistics:\n");
        try self.stdout.print(
            "  * Size of decoded image data: {any}\n",
            .{image_data.decoded_size}
        );
        try self.stdout.print(
            "  * Size of buffer to store decoded image data: {any}\n",
            .{image_data.data.len}
        );
        try self.stdout.flush();
    }

    fn _encode_and_write_image(self: *PngWriter, image_data: *ImageData) !void {
        const encode_status = png.spng_encode_image(
            self.ctx,
            @as([*c]u8, @ptrCast(image_data.data)),
            image_data.data.len,
            png.SPNG_FMT_PNG,
            png.SPNG_ENCODE_FINALIZE
        );
        if (encode_status != 0) {
            const status: u32 = @intCast(encode_status);
            try self.stderr.print("Test: {any}\n", .{encode_status == png.SPNG_EFMT});
            try self.stderr.print("Error code: {d}\n", .{status});
            try self.stderr.flush();
            return error.CouldNotEncodeImage;
        }
        _ = try self.stdout.write("Image encoded and written successfully\n");
        try self.stdout.flush();
    }
};


fn fopen_file(
    path: []const u8,
    mode: []const u8,
    stdout: *std.Io.Writer,
    stderr: *std.Io.Writer
) !*c.FILE {
    const file_descriptor = c.fopen(path.ptr, mode.ptr);
    if (file_descriptor == null) {
        try stderr.print("Could not open file: {s}\n", .{path});
        try stderr.flush();
        return error.CouldNotOpenFile;
    }
    try stdout.print("File at path {s} opened successfully\n", .{path});
    try stdout.flush();
    return file_descriptor;
}

fn fclose_file(
    file_descriptor: *c.FILE,
    stdout: *std.Io.Writer,
    stderr: *std.Io.Writer
) !void {
    const close_status = c.fclose(file_descriptor);
    if (close_status != 0) {
        try stderr.print(
            "Could not close file descriptor with status: {any}\n", .{close_status}
        );
        try stderr.flush();
        return error.CouldNotCloseFileDescriptor;
    }
    _ = try stdout.write("File descriptor closed successfully\n");
    try stdout.flush();
}


fn apply_image_filter(image_data: *ImageData) !void {
    const len = image_data.data.len;
    const red_factor: f16 = 0.2126;
    const green_factor: f16 = 0.7152;
    const blue_factor: f16 = 0.0722;
    var index: u64 = 0;
    while (index < len) : (index += 4) {
        const rf: f16 = @floatFromInt(image_data.data[index]);
        const gf: f16 = @floatFromInt(image_data.data[index + 1]);
        const bf: f16 = @floatFromInt(image_data.data[index + 2]);
        const y_linear: f16 = (rf * red_factor) + (gf * green_factor) + (bf * blue_factor);
        image_data.data[index] = @intFromFloat(y_linear);
        image_data.data[index + 1] = @intFromFloat(y_linear);
        image_data.data[index + 2] = @intFromFloat(y_linear);
    }
}


pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stderr_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    var stderr_writer = std.Io.File.stderr().writer(init.io, &stderr_buffer);
    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();

    var png_reader = PngReader.init(
        allocator,
        &stdout_writer.interface,
        &stderr_writer.interface
    );
    defer png_reader.deinit();

    var image_data = try png_reader.read_png("pedro_pascal.png");
    try apply_image_filter(&image_data);

    var png_writer = PngWriter.init(
        allocator,
        &stdout_writer.interface,
        &stderr_writer.interface
    );
    defer png_writer.deinit();
    try png_writer.save_png(&image_data, "pedro_pascal_filter.png");
}
