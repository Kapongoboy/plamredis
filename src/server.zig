const std = @import("std");
const os = std.posix;

fn setup() !void {
    const fd = try os.socket(os.AF.INET, os.SOCK.STREAM, 0);
    const val = 1;
    _ = try os.setsockopt(fd, os.SOL.SOCKET, os.SO.REUSEADDR, &[_]u8{val});

    var buf: [14]u8 = [_]u8{0} ** 14;
    std.mem.writeInt(os.sa_family_t, buf[0..2], 1234, .little);

    const addr = os.sockaddr{
        .data = buf,
        .family = os.AF.INET,
    };

    _ = try os.bind(fd, &addr, @sizeOf(os.sockaddr));

    _ = try os.listen(fd, std.os.linux.SOMAXCONN);
}

test "builds" {
    try setup();
    try std.testing.expect(true);
}
