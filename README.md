# nether-pathfinder-android

Android AArch64 native library build for [nether-pathfinder](https://github.com/babbaj/nether-pathfinder) v1.4.1.

Uses the Android NDK's Clang toolchain to produce a Bionic-linked `libnether_pathfinder-aarch64.so` that works on Android devices. The output JAR replaces the desktop `libnether_pathfinder-aarch64.so` inside the official JAR's `natives.zip.xz`.

## Building

Requires:
- Android NDK (r28 or later)
- JDK 8+ (for JNI headers)
- CMake + Ninja

```bash
git clone https://github.com/brandonmathewp/nether-pathfinder-android.git
cd nether-pathfinder-android

# Set NDK location
export ANDROID_NDK_HOME=/path/to/android-ndk

# Build
./build.sh

# Package (downloads official v1.4.1 JAR, swaps .so)
./package.sh

# Publish to GitHub Pages Maven repo
./publish.sh
```

## How it works

1. `build.sh` - Compiles the v1.4.1 native source using the Android NDK CMake toolchain, targeting `arm64-v8a` / API 26
2. `package.sh` - Downloads the official v1.4.1 JAR from `babbaj.github.io/maven`, replaces `libnether_pathfinder-aarch64.so` inside `natives.zip.xz` with the Bionic-linked one
3. `publish.sh` - Pushes the modified JAR to the `maven-repo` branch, served via GitHub Pages at `https://brandonmathewp.github.io/nether-pathfinder-android`

The output JAR is API-compatible with the official v1.4.1 — Baritone's Java code works unchanged.

## Maven Repo

GitHub Pages at: `https://brandonmathewp.github.io/nether-pathfinder-android`

Add to Gradle:
```groovy
maven {
    name = 'nether-pathfinder-android'
    url = 'https://brandonmathewp.github.io/nether-pathfinder-android'
}
```
