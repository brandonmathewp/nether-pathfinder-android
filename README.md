# nether-pathfinder-android

Android AArch64 native library build for [nether-pathfinder](https://github.com/babbaj/nether-pathfinder) v1.4.1.

Uses the Android NDK's Clang toolchain to produce a Bionic-linked `libnether_pathfinder-aarch64.so` that works on Android devices.

## Building

Requires:
- Android NDK (r28 or later)
- JDK 8+ (for JNI headers)
- CMake + Ninja

```bash
# Set NDK location
export ANDROID_NDK_HOME=/path/to/android-ndk

# Build the native library
./build.sh

# Package into a JAR (downloads official v1.4.1 JAR, swaps .so)
./package.sh

# Install to local maven (~/.m2) for use in Baritone builds
./publish.sh
```

## How it works

1. `build.sh` - Compiles the v1.4.1 native source using the Android NDK CMake toolchain, targeting `arm64-v8a` / API 26
2. `package.sh` - Downloads the official v1.4.1 JAR from `babbaj.github.io/maven`, replaces `libnether_pathfinder-aarch64.so` inside `natives.zip.xz` with the Bionic-linked one
3. `publish.sh` - Places the modified JAR in `~/.m2` as `dev.babbaj:nether-pathfinder:1.4.1` for use in Gradle/Maven builds

The output JAR is API-compatible with the official v1.4.1 — Baritone's Java code works unchanged.
