const std = @import("std");
const BatteryInfoError = @import("../api.zig").BatteryInfoError;

pub fn getBatteryLevel() BatteryInfoError!f32 {
    var fba_buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&fba_buffer);
    const allocator = fba.allocator();

    // Open the /sys/class/power_supply directory
    var dir = std.fs.openDirAbsolute("/sys/class/power_supply", .{ .iterate = true }) catch {
        return BatteryInfoError.BatteryLevelUnknown;
    };
    defer dir.close();

    // Iterate through entries to find battery
    var iter = dir.iterate();
    while (iter.next() catch return BatteryInfoError.BatteryLevelUnknown) |entry| {
        if (std.mem.startsWith(u8, entry.name, "BAT")) {
            // Found a battery directory, try to read its capacity
            const bat_path = std.fmt.allocPrint(
                allocator,
                "/sys/class/power_supply/{s}/capacity",
                .{entry.name},
            ) catch |err| {
                std.debug.print("Error: {s}\n", .{@errorName(err)});
                return BatteryInfoError.BatteryLevelUnknown;
            };
            defer allocator.free(bat_path);

            const file = std.fs.openFileAbsolute(bat_path, .{}) catch continue;
            defer file.close();

            var buffer: [8]u8 = undefined;
            const bytes_read = file.readAll(&buffer) catch continue;

            // Parse the capacity value
            const capacity = std.fmt.parseInt(u8, buffer[0 .. bytes_read - 1], 10) catch continue;
            return @as(f32, @floatFromInt(capacity));
        }
    }

    return BatteryInfoError.BatteryLevelUnknown;
}
