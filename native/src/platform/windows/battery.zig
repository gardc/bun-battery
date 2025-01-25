const BatteryInfo = @import("../api.zig").BatteryInfo;
const BatteryInfoError = @import("../api.zig").BatteryInfoError;

extern "c" fn nativeGetBatteryLevel() f32;

pub fn getBatteryLevel() BatteryInfoError!f32 {
    const percentage = nativeGetBatteryLevel();
    if (percentage == -1.0) {
        return BatteryInfoError.BatteryLevelUnknown;
    }
    return percentage;
}
