# nether-pathfinder-android

Android AArch64 native library build for [nether-pathfinder](https://github.com/babbaj/nether-pathfinder) v1.6.

Uses the Android NDK's Clang toolchain to produce a Bionic-linked `libnether_pathfinder-aarch64.so` that works on Android devices. The output JAR replaces the desktop `libnether_pathfinder-aarch64.so` inside the official JAR's `natives.zip.xz`.

## Building

Requires:
- Android NDK (r28 or later)
- JDK 8+ (for JNI headers)
- CMake + Ninja
- Git (submodules: zlib-ng)

```bash
git clone --recursive https://github.com/brandonmathewp/nether-pathfinder-android.git
cd nether-pathfinder-android

# Set NDK location
export ANDROID_NDK_HOME=/path/to/android-ndk

# Build
./build.sh

# Package (downloads official v1.6 JAR, swaps .so)
./package.sh

# Install to ~/.m2 for Gradle/Maven
./publish.sh
```

## How it works

1. `build.sh` - Compiles the v1.6 native source (with zlib-ng) using the Android NDK CMake toolchain, targeting `arm64-v8a` / API 26
2. `package.sh` - Downloads the official v1.6 JAR, replaces `libnether_pathfinder-aarch64.so` inside `natives.zip.xz` with the Bionic-linked one
3. `publish.sh` - Places the modified JAR in `~/.m2` as `dev.babbaj:nether-pathfinder:1.6`

## Using with Baritone

1. Run `./publish.sh` from this repo
2. Clone [baritone-android](https://github.com/brandonmathewp/baritone-android)
3. `./gradlew :fabric:build`

The `mavenLocal()` in baritone-android's build.gradle picks up the patched JAR automatically.
