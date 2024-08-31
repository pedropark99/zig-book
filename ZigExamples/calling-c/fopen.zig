const std = @import("std");
const stdout = std.io.getStdOut().writer();
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});

pub fn main() !void {
    const path: []const u8 = "ZigExamples/image_filter/build.zig";
    const file = c.fopen(path.ptr, "rb");
    const close_status = c.fclose(file);
    if (close_status != 0) {
        return error.CouldNotCloseFileDescriptor;
    }
}
