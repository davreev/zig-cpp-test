const std = @import("std");

export fn mylib_hello() void {
    std.debug.print("Hello from Zig!\n", .{});
}
