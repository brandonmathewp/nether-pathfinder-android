#!/usr/bin/env bash
set -e

NDK_HOME="${ANDROID_NDK_HOME:-$ANDROID_SDK_ROOT/ndk/28.2.13676358}"
if [ ! -f "$NDK_HOME/build/cmake/android.toolchain.cmake" ]; then
    echo "Error: Android NDK not found at $NDK_HOME"
    echo "Set ANDROID_NDK_HOME or ANDROID_SDK_ROOT"
    exit 1
fi

ABI="${1:-arm64-v8a}"
API="${2:-26}"

echo "Building nether-pathfinder for Android $ABI (API $API)"
echo "NDK: $NDK_HOME"

cmake -G Ninja -B build \
    -DCMAKE_TOOLCHAIN_FILE="$NDK_HOME/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="$ABI" \
    -DANDROID_NATIVE_API_LEVEL="$API" \
    -DCMAKE_BUILD_TYPE=Release

ninja -C build -j "$(nproc)"

cp build/libnether_pathfinder.so ./
echo "Built: libnether_pathfinder.so ($(du -h libnether_pathfinder.so | cut -f1))"
