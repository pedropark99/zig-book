const std = @import("std");
const c = @import("c");

pub fn main() !void {
    const file = c.fopen("./build.zig", "rb");
    if (file == null) {
        return error.CouldNotOpenFile;
    }
    const close_status = c.fclose(file);
    if (close_status != 0) {
        return error.CouldNotCloseFileDescriptor;
    }
}
