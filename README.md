# 🔋 Bun battery

A Bun library for getting the battery percentage of your device.

## Installation

```bash
bun add bun-battery
```

## Usage

```ts
import { getBatteryPercentage } from "bun-battery";

const battery = getBatteryPercentage();
console.log(battery);
```

returns a number between 0 and 100, or -1 if there was an error.

If your device does not have a battery, it will return -1.

## Supported platforms

- aarch64-linux
- aarch64-macos
- aarch64-windows
- x86_64-linux
- x86_64-windows

Please open an issue if you want to add support for another platform.

## building

on macOS, you can build the native library with the following command:

```bash
chmod +x ./build.sh
./build.sh
```

This will build the native library and place it in the `lib` directory.
