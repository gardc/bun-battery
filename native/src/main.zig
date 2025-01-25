const std = @import("std");
const api = @import("platform/api.zig");
const builtin = @import("builtin");

pub export fn getBatteryPercentage() callconv(.C) f32 {
    const batteryLevel = api.getBatteryPercentage() catch -1.0;
    return batteryLevel;
}

test "getBatteryInfo" {
    std.debug.print("builtin.target.os.tag: {s}\n", .{@tagName(builtin.target.os.tag)});

    const batteryLevel = try api.getBatteryPercentage();
    // const batteryLevelStr = std.fmt.allocPrint(std.testing.allocator, "Battery level: {}\n", .{batteryLevel}) catch unreachable;
    std.debug.print("Battery level: {d}\n", .{batteryLevel});
}
