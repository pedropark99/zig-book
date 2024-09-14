const cmath = @cImport({
    @cInclude("math.h");
});
const stdio = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});

pub fn main() !void {
    const x: f32 = 15.2;
    const y = cmath.powf(x, @as(f32, 2.6));
    _ = stdio.printf("%.3f\n", y);
}
