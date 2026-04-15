# Android Splash Screen Hang Bug Condition Exploration Test

## Overview

This integration test validates the bug condition for the Android splash screen hang issue. The test is designed to **FAIL on unfixed code** to confirm the bug exists.

## Test File

- `android_splash_screen_hang_test.dart` - Bug condition exploration test

## What the Test Validates

**Property 1: Bug Condition** - Android Splash Screen Hang Detection

The test verifies that:
1. Flutter engine successfully initializes and renders the first frame
2. SplashScreen widget is displayed after app launch
3. Navigation to '/auth' occurs after the 1200ms timer

## Expected Behavior

### On UNFIXED Code (with `installSplashScreen()` in MainActivity.kt)

The test will **FAIL** because:
- The Flutter engine fails to initialize (blocked by `installSplashScreen()` called before `super.onCreate()`)
- The SplashScreen widget is never displayed
- Navigation to '/auth' never occurs
- The test will timeout waiting for the Flutter UI to render

**Expected counterexample**: "App hangs on native splash screen, Flutter UI never renders"

### On FIXED Code (after removing `installSplashScreen()`)

The test will **PASS** because:
- The Flutter engine initializes successfully
- The SplashScreen widget is displayed
- Navigation to '/auth' occurs after the timer completes

## Running the Test

### Prerequisites

1. Android device or emulator running Android 12+ (API level 31+)
2. Flutter SDK installed
3. Android SDK and tools configured

### Run Command

```bash
# Run the integration test on Android
flutter test integration_test/android_splash_screen_hang_test.dart

# Or use the test driver
flutter drive \
  --driver=integration_test_driver/android_splash_screen_hang_test_driver.dart \
  --target=integration_test/android_splash_screen_hang_test.dart \
  -d <device_id>
```

### Check Available Devices

```bash
flutter devices
```

## Test Status

- **Current Status**: Test written, ready to run on unfixed code
- **Expected Result on Unfixed Code**: FAIL (confirms bug exists)
- **Expected Result on Fixed Code**: PASS (confirms bug is fixed)

## Requirements Validated

- **Requirement 1.1**: App displays native splash screen and never transitions to Flutter UI
- **Requirement 1.2**: Flutter engine fails to render the Flutter SplashScreen widget
- **Requirement 1.3**: Navigation to '/auth' route never occurs

## Notes

- This is a **bug condition exploration test** - failure is the expected outcome on unfixed code
- The test encodes the expected behavior, so it will validate the fix when it passes after implementation
- Do NOT attempt to fix the test or the code when it fails - document the failure as proof the bug exists
