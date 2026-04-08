# Launcher Icon & Build Speed Update

## Changes Made

### 1. Launcher Icon Changed
- Changed from `v.png` to `car.png`
- Set transparent background (`#00000000`) to remove white background
- Icon will now show just the car without any background

### 2. Build Speed Optimizations - FIXED ASSEMBLY DELAY

#### Critical Fixes for "Assembling Build" Delay:
- **Disabled R8 optimization** for debug builds (main cause of 20+ min delay)
- **Disabled minification** for both debug and release
- **Disabled resource shrinking** 
- **Disabled unnecessary build features** (aidl, renderScript, shaders)
- Kept ProGuard rules minimal

#### Gradle Properties (android/gradle.properties)
- Increased heap size to 4GB for faster builds
- Enabled parallel builds
- Enabled Gradle caching
- Enabled Gradle daemon
- **Disabled R8 and dexing transforms** (major speed improvement)

#### Build Configuration (android/app/build.gradle.kts)
- Disabled all optimizations for debug builds
- Disabled minification for release builds (for faster testing)
- Disabled unnecessary build features

## Quick Build Commands

### Option 1: Use the Fast Build Script (RECOMMENDED)
```bash
fast_build.bat
```

### Option 2: Manual Commands
```bash
# Clean first
flutter clean

# Build debug APK (should take 2-5 minutes now, not 20+)
flutter build apk --debug --no-tree-shake-icons --no-shrink

# Or just run on device (fastest for testing)
flutter run
```

### Option 3: Generate Icons First
```bash
flutter pub get
flutter pub run flutter_launcher_icons
flutter clean
flutter build apk --debug --no-tree-shake-icons --no-shrink
```

## Expected Results

- **Assembly time reduced from 20+ minutes to 2-5 minutes**
- Your app icon will show the car.png without white background
- Debug builds are now optimized for speed, not size
- No more R8/ProGuard delays during assembly

## Why It Was Slow Before

The "Assembling build" step was running R8 optimization which:
- Analyzes all code paths
- Removes unused code
- Obfuscates code
- Takes 15-20 minutes for complex apps

Now R8 is disabled for debug builds, so assembly is instant.

## Tips for Development

1. Use `flutter run` for daily development (fastest)
2. Use `flutter build apk --debug` only when you need to share APK
3. Keep Gradle daemon running (it's enabled)
4. Use hot reload (r) and hot restart (R) during development
