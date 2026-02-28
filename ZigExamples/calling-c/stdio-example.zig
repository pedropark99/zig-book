// Compile this program with: `zig build-exe stdio-example.zig -lc`
const stdio = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});

pub fn main(init: std.process.Init) !void {
    const x: f32 = 15.2;
    _ = stdio.printf("%.3f\n", x);
}
