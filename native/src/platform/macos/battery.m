#import <Foundation/Foundation.h>
#import <IOKit/ps/IOPowerSources.h>
#import <IOKit/ps/IOPSKeys.h>

float nativeGetBatteryLevel(void) {
    CFTypeRef powerSourceInfo = IOPSCopyPowerSourcesInfo();
    CFArrayRef powerSources = IOPSCopyPowerSourcesList(powerSourceInfo);
    
    if (!powerSources) {
        if (powerSourceInfo) CFRelease(powerSourceInfo);
        return -1;
    }
    
    CFDictionaryRef powerSource = NULL;
    const void *powerSourceVal;
    
    if (CFArrayGetCount(powerSources) > 0) {
        powerSourceVal = CFArrayGetValueAtIndex(powerSources, 0);
        powerSource = IOPSGetPowerSourceDescription(powerSourceInfo, powerSourceVal);
        
        if (powerSource) {
            CFNumberRef capacityRef = CFDictionaryGetValue(powerSource, CFSTR(kIOPSCurrentCapacityKey));
            float capacity;
            if (capacityRef && CFNumberGetValue(capacityRef, kCFNumberFloat32Type, &capacity)) {
                CFRelease(powerSources);
                CFRelease(powerSourceInfo);
                return capacity;
            }
        }
    }
    
    CFRelease(powerSources);
    CFRelease(powerSourceInfo);
    return -1;
} 