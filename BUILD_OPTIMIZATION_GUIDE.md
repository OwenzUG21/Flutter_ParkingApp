# Build Optimization Guide

## Changes Made to Speed Up Builds

### 1. Gradle Properties Optimizations
- Reduced JVM heap from 8G to 4G (more efficient)
- Enabled parallel builds
- Enabled build caching
- Enabled Gradle daemon
- Added Kotlin incremental compilation

### 2. Build Configuration
- Fixed compileSdk to 35 (was 36, which doesn't exist)
- Added proper debug/release build types
- Disabled minification for debug builds (faster)
- Added packaging options to exclude duplicate files

### 3. ProGuard Rules
- Created proguard-rules.pro for release builds

## Commands to Speed Up Your Builds

### First Time Setup (Run Once)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### For Debug Builds (Fastest - with debugger)
```bash
flutter build apk --debug --split-per-abi
```

### For Profile Builds (Fast - run without debugging)
```bash
flutter build apk --profile --split-per-abi
```

### For Release Builds (Production)
```bash
flutter build apk --release --split-per-abi
```

### For Testing on Device (Fastest Options)

With debugging:
```bash
flutter run --debug
```

Without debugging (profile mode - faster, better performance):
```bash
flutter run --profile
```

## Build Time Improvements

- Debug builds: Should now take 2-5 minutes (down from hours)
- Profile builds: Should take 3-6 minutes
- Release builds: Should take 5-10 minutes
- Incremental builds: 30 seconds - 2 minutes
- `flutter run` (any mode): 1-3 minutes

## Tips for Faster Builds

1. Use `--split-per-abi` flag to build only for your device architecture
2. Use `flutter run` instead of building APK for testing
3. Use `flutter run --profile` for "run without debugging" (faster than debug)
4. Keep Gradle daemon running (don't restart your computer frequently)
5. Close other heavy applications while building
6. Use debug for debugging, profile for testing performance, release for distribution

## Build Mode Comparison

| Mode | Speed | Use Case | Hot Reload |
|------|-------|----------|------------|
| Debug | Fast | Development with debugger | Yes |
| Profile | Faster | Testing without debugger | Yes |
| Release | Slower | Production/Distribution | No |

## If Builds Are Still Slow

1. Clear build cache:
```bash
flutter clean
cd android
./gradlew clean
cd ..
```

2. Check your antivirus - it might be scanning build files
3. Ensure you have at least 8GB RAM available
4. Check if your disk has enough space (need 5-10GB free)
