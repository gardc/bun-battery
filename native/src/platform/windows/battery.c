#include <windows.h>

float nativeGetBatteryLevel()
{
    SYSTEM_POWER_STATUS status;
    if (GetSystemPowerStatus(&status))
    {
        unsigned char battery = status.BatteryLifePercent;
        /* battery := 0..100 or 255 if unknown */
        if (battery == 255)
        {
            return -1.0;
        }
        else
        {
            return battery;
        }
    }
    else
    {
        return -1.0;
    }
}
