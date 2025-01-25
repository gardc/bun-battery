import { expect, test, describe } from "bun:test";
import { getBatteryPercentage, getPlatformSpecificPath } from "./index";

describe("Battery API", () => {
  test("platform specific logic", () => {
    const libraryPath = getPlatformSpecificPath();
    expect(libraryPath).toBeDefined();
    console.log(libraryPath);
  });

  test("getBatteryPercentage returns a valid number", () => {
    const battery = getBatteryPercentage();

    // Should return a number
    expect(typeof battery).toBe("number");

    // Should be either -1 (error) or between 0 and 100
    expect(battery === -1 || (battery >= 0 && battery <= 100)).toBe(true);

    console.log(battery);
  });
});
