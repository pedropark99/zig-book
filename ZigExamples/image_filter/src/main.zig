const std = @import("std");
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});
const png = @cImport({
    @cInclude("png.h");
});

pub fn main() !void {
    const file_path = "pedro_pascal.png";
    const file = c.fopen(file_path, "rb");
    if (file == null) {
        @panic("Error at open! Probably file not found!");
    }
    const png_ptr = png.png_create_read_struct(png.PNG_LIBPNG_VER_STRING, null, null, null);
    defer png.png_destroy_read_struct(&png_ptr, null, null);
    const info_ptr = png.png_create_info_struct(png_ptr);
    const png_transforms = png.PNG_TRANSFORM_STRIP_16;
    png.png_init_io(png_ptr, file);
    png.png_read_png(png_ptr, info_ptr, png_transforms, null);
    _ = c.fclose(file);
}
