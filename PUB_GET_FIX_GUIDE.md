# Flutter Pub Get Fix Guide

## Problems Fixed

### 1. SDK Version Constraint Issue
- Changed from `sdk: ^3.9.2` (too restrictive, might not exist)
- To `sdk: '>=3.0.0 <4.0.0'` (compatible with all Flutter 3.x versions)

### 2. Dependency Override Removed
- Moved `google_maps_flutter_android: 2.18.6` from dependency_overrides to main dependencies
- Dependency overrides can cause pub get to fail or require multiple attempts

### 3. Cache and Lock File Issues
- Created automated script to clean pub cache
- Removes stale lock files
- Repairs corrupted cache

## Why Pub Get Was Failing

Common causes:
1. **SDK version mismatch** - Your SDK constraint was too specific
2. **Corrupted pub cache** - Old/corrupted packages in cache
3. **Stale lock file** - pubspec.lock had conflicts
4. **Dependency overrides** - Can cause resolution conflicts
5. **Background processes** - Dart/Flutter processes holding locks

## How to Fix (Choose One Method)

### Method 1: Use the Fix Script (RECOMMENDED)
```bash
fix_pub_get.bat
```

This script will:
- Kill any hanging Dart/Flutter processes
- Clean pub cache completely
- Remove lock files
- Repair cache
- Run pub get with verbose output

### Method 2: Manual Fix
```bash
# Stop any Flutter processes first
taskkill /F /IM dart.exe
taskkill /F /IM flutter.exe

# Clean everything
flutter pub cache clean -f
flutter clean
del pubspec.lock

# Repair and get
flutter pub cache repair
flutter pub get --verbose
```

### Method 3: Quick Fix (if above methods worked once)
```bash
flutter pub get
```

## Prevention Tips

1. **Don't use overly specific SDK versions** - Use ranges like `>=3.0.0 <4.0.0`
2. **Avoid dependency_overrides** unless absolutely necessary
3. **Run pub get once** - Don't spam it multiple times
4. **Check your internet** - Slow/unstable connection causes failures
5. **Use --verbose flag** to see what's happening:
   ```bash
   flutter pub get --verbose
   ```

## If Still Having Issues

Run diagnostics:
```bash
flutter doctor -v
flutter pub cache repair
flutter pub get --verbose
```

Check for:
- Internet connectivity issues
- Firewall blocking pub.dev
- Antivirus blocking Dart processes
- Disk space issues
- Corrupted Flutter installation

## Network Issues?

If you're behind a proxy or firewall:
```bash
# Set proxy (if needed)
set HTTP_PROXY=http://your-proxy:port
set HTTPS_PROXY=http://your-proxy:port

# Then run
flutter pub get
```

## Expected Result

After running the fix script, `flutter pub get` should:
- Complete in 10-30 seconds (depending on internet speed)
- Work on the FIRST try
- Show "Got dependencies!" message
- Create a clean pubspec.lock file
