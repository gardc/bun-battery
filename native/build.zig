const std = @import("std");
const builtin = @import("builtin");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const shared = b.addSharedLibrary(.{
        .name = "battery",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    if (target.result.os.tag == .macos) {
        std.debug.print("Building for macOS\n", .{});
        shared.linkLibC();
        shared.linkFramework("IOKit");
        shared.linkFramework("Foundation");

        shared.addCSourceFile(.{
            .file = .{ .cwd_relative = "src/platform/macos/battery.m" },
        });
    }
    if (target.result.os.tag == .windows) {
        std.debug.print("Building for Windows\n", .{});

        shared.addCSourceFile(.{
            .file = .{ .cwd_relative = "src/platform/windows/battery.c" },
        });

        shared.linkLibC();
    }

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(shared);

    const standalone_debug = b.addExecutable(.{
        .name = "standalone-debug",
        .root_source_file = b.path("src/standalone-debug.zig"),
        .target = target,
        .optimize = optimize,
    });

    if (target.result.os.tag == .macos) {
        std.debug.print("Building for macOS\n", .{});
        standalone_debug.linkLibC();
        standalone_debug.linkFramework("IOKit");
        standalone_debug.linkFramework("Foundation");

        standalone_debug.addCSourceFile(.{
            .file = .{ .cwd_relative = "src/platform/macos/battery.m" },
        });
    }
    if (target.result.os.tag == .windows) {
        std.debug.print("Building for Windows\n", .{});

        standalone_debug.addCSourceFile(.{
            .file = .{ .cwd_relative = "src/platform/windows/battery.c" },
        });

        standalone_debug.linkLibC();
    }

    b.installArtifact(standalone_debug);

    // tests

    const shared_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    if (target.result.os.tag == .macos) {
        shared_unit_tests.linkLibC();
        shared_unit_tests.linkFramework("IOKit");
        shared_unit_tests.linkFramework("Foundation");

        shared_unit_tests.addCSourceFile(.{
            .file = .{ .cwd_relative = "src/platform/macos/battery.m" },
        });
    }

    if (target.result.os.tag == .windows) {
        shared_unit_tests.linkLibC();
    }

    const run_shared_unit_tests = b.addRunArtifact(shared_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_shared_unit_tests.step);
}
