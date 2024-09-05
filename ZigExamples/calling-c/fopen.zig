const std = @import("std");
const stdout = std.io.getStdOut().writer();
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});

pub fn main() !void {
    const file = c.fopen("ZigExamples/image_filter/build.zig", "rb");
    const close_status = c.fclose(file);
    if (close_status != 0) {
        return error.CouldNotCloseFileDescriptor;
    }
}
