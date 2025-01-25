targets=(
    "aarch64-linux"
    "aarch64-macos"
    "aarch64-windows"
    "x86_64-linux"
    "x86_64-macos"
    "x86_64-windows"
)

cd native

for target in "${targets[@]}"; do
    # Extract the OS from the target
    os="${target#*-}"
    
    # Skip -Dtarget for macOS builds
    if [ "$os" = "macos" ]; then
        zig build
    else
        zig build -Dtarget="$target"
    fi
    
    # Determine the correct library extension and source path
    case "$os" in
        "windows")
            cp "zig-out/lib/battery.lib" "../lib/$target.lib"
            ;;
        "macos")
            cp "zig-out/lib/libbattery.dylib" "../lib/$target.dylib"
            ;;
        "linux")
            cp "zig-out/lib/libbattery.so" "../lib/$target.so"
            ;;
    esac
done

cd ..
    