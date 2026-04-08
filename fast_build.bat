@echo off
echo ========================================
echo Fast Release Build Script
echo ========================================
echo.

echo Step 1: Cleaning build cache...
flutter clean

echo.
echo Step 2: Getting dependencies...
flutter pub get

echo.
echo Step 3: Building Release APK (ARM64 - smaller and faster)...
flutter build apk --release --target-platform android-arm64

echo.
echo ========================================
echo Build Complete!
echo APK Location: build\app\outputs\flutter-apk\app-release.apk
echo ========================================
pause

