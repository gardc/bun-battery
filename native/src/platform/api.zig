const std = @import("std");
const builtin = @import("builtin");

const battery = switch (builtin.target.os.tag) {
    .windows => @import("windows/battery.zig"),
    .linux => @import("linux/battery.zig"),
    .macos => @import("macos/battery.zig"),
    else => @compileError("Unsupported platform"),
};

pub const BatteryInfoError = error{
    BatteryLevelUnknown,
};

pub fn getBatteryPercentage() BatteryInfoError!f32 {
    return battery.getBatteryLevel();
}
