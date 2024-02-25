const std = @import("std");

export fn hello_zig() void {
    std.debug.print("Hello from Zig!\n", .{});
}
