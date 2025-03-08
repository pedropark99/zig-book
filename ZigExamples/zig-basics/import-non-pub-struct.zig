const user = @import("pub-keyword.zig");
pub fn main() !void {
    const u: user.User = user.User.init(1, "pedro", "email@gmail.com");
    _ = u;
}
