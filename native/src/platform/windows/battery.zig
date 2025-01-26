const BatteryInfo = @import("../api.zig").BatteryInfo;
const BatteryInfoError = @import("../api.zig").BatteryInfoError;

const c = @cImport({
    @cInclude("windows.h");
});

pub fn getBatteryLevel() BatteryInfoError!f32 {
    var status: c.SYSTEM_POWER_STATUS = undefined;
    if (c.GetSystemPowerStatus(&status) == 0) {
        return BatteryInfoError.BatteryLevelUnknown;
    }

    // battery level is 0..100 or 255 if unknown
    if (status.BatteryLifePercent == 255) {
        return BatteryInfoError.BatteryLevelUnknown;
    }

    return @as(f32, @floatFromInt(status.BatteryLifePercent));
}
