const std = @import("std");
const builtin = @import("builtin");
const api = @import("platform/api.zig");

pub fn main() void {
    const batteryLevel = api.getBatteryPercentage() catch -1.0;

    std.debug.print("Battery level: {d}\n", .{batteryLevel});
}
