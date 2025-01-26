import { dlopen, FFIType, suffix } from "bun:ffi";
const { float } = FFIType;

export function getPlatformSpecificPath(): string {
  // Determine platform-specific library name
  let platformName = process.platform.toString();
  if (platformName === "darwin") {
    platformName = "macos";
  } else if (platformName === "win32") {
    platformName = "windows";
  }

  let archName = process.arch.toString();
  switch (archName) {
    case "arm64":
      archName = "aarch64";
      break;
    case "x64":
      archName = "x86_64";
      break;
    default:
      throw new Error(
        `Unsupported architecture: ${archName}. Only x64 and arm64/aarch64 are supported.`
      );
  }

  // Map to correct library extension
  let extension: string;
  switch (platformName) {
    case "macos":
      extension = "dylib";
      break;
    case "windows":
      extension = "lib";
      break;
    case "linux":
      extension = "so";
      break;
    default:
      throw new Error(`Unsupported platform: ${platformName}`);
  }

  if (platformName === "macos" && archName === "x86_64") {
    throw new Error("only arm64 macOS is supported for now".);
  }

  return `lib/${archName}-${platformName}.${extension}`;
}

const libraryPath = getPlatformSpecificPath();

// Load the native library
const lib = dlopen(libraryPath, {
  getBatteryPercentage: {
    args: [], // No arguments
    returns: float,
  },
});

/**
 * Gets the current battery percentage
 * @returns Battery percentage between 0 and 100, or -1 if there was an error
 */
export function getBatteryPercentage(): number {
  return lib.symbols.getBatteryPercentage();
}

// Optional: Add a default export
export default {
  getBatteryPercentage,
};
