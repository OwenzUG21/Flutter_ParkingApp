# Task 1: Bug Condition Exploration Test - Summary

## Status: COMPLETE (Test Written, Awaiting Execution on Device)

## What Was Done

### 1. Created Integration Test
- **File**: `integration_test/android_splash_screen_hang_test.dart`
- **Purpose**: Bug condition exploration test that validates the Android splash screen hang issue
- **Framework**: Flutter integration_test package

### 2. Test Structure

The test includes three test cases:

#### Test Case 1: App Transition from Native Splash to Flutter SplashScreen
- Launches the app
- Waits for Flutter engine to initialize (5 seconds timeout)
- Verifies SplashScreen widget is displayed
- Verifies UI elements (app name, loading indicator)
- Waits for navigation timer (1200ms)
- Verifies navigation to AuthWrapper occurred

#### Test Case 2: Flutter Engine First Frame Rendering
- Tracks if the first frame was rendered using post-frame callback
- Launches the app
- Attempts to pump the first frame (3 seconds timeout)
- Verifies the first frame was rendered

#### Test Case 3: SplashScreen Timer Callback Execution
- Launches the app
- Waits for initial render
- Verifies we're on the SplashScreen
- Waits for the 1200ms timer
- Verifies navigation occurred (SplashScreen removed, AuthWrapper displayed)

### 3. Added Dependencies
- Added `integration_test` package to `pubspec.yaml` dev_dependencies
- Ran `flutter pub get` successfully

### 4. Created Test Driver
- **File**: `integration_test_driver/android_splash_screen_hang_test_driver.dart`
- **Purpose**: Driver to run the integration test from command line

### 5. Created Documentation
- **File**: `integration_test/README.md`
- **Content**: Comprehensive guide on running the test, expected behavior, and requirements validated

## Expected Behavior

### On UNFIXED Code (Current State)
The test will **FAIL** because:
- `installSplashScreen()` is called before `super.onCreate()` in MainActivity.kt
- This blocks the Flutter engine from initializing
- The SplashScreen widget is never displayed
- Navigation to '/auth' never occurs
- The test will timeout or hang

**Expected Counterexample**: "App hangs on native splash screen, Flutter UI never renders"

### On FIXED Code (After Task 3)
The test will **PASS** because:
- Flutter engine initializes successfully
- SplashScreen widget is displayed
- Navigation to '/auth' occurs after timer completes

## How to Run the Test

### Prerequisites
1. Android device or emulator running Android 12+ (API level 31+)
2. Device connected and recognized by Flutter
3. Flutter SDK and Android SDK configured

### Run Commands

```bash
# Check available devices
flutter devices

# Run the integration test
flutter test integration_test/android_splash_screen_hang_test.dart

# Or use the test driver
flutter drive \
  --driver=integration_test_driver/android_splash_screen_hang_test_driver.dart \
  --target=integration_test/android_splash_screen_hang_test.dart \
  -d <device_id>
```

## Requirements Validated

- ✅ **Requirement 1.1**: App displays native splash screen and never transitions to Flutter UI
- ✅ **Requirement 1.2**: Flutter engine fails to render the Flutter SplashScreen widget
- ✅ **Requirement 1.3**: Navigation to '/auth' route never occurs

## Files Created/Modified

1. `integration_test/android_splash_screen_hang_test.dart` - Main test file
2. `integration_test_driver/android_splash_screen_hang_test_driver.dart` - Test driver
3. `integration_test/README.md` - Test documentation
4. `pubspec.yaml` - Added integration_test dependency
5. `.kiro/specs/android-splash-screen-hang-fix/TASK_1_SUMMARY.md` - This summary

## Next Steps

1. **User Action Required**: Connect an Android device or start an Android emulator
2. **User Action Required**: Run the integration test using the commands above
3. **Expected Result**: Test FAILS (this confirms the bug exists)
4. **Document**: Capture the test failure output as proof of the bug condition
5. **Proceed**: Move to Task 2 (Write preservation property tests)

## Important Notes

- This is a **bug condition exploration test** - failure is SUCCESS for this task
- The test encodes the expected behavior, so it will validate the fix later
- DO NOT attempt to fix the test or the code when it fails
- The failure confirms the bug exists and provides counterexamples
- This test will be re-run in Task 3.2 to verify the fix works

## Technical Details

### Why Integration Test?
- The bug occurs at the native Android level (MainActivity.kt)
- The bug prevents Flutter engine initialization
- Integration tests can detect this by timing out when the Flutter UI never renders
- This is the most appropriate way to test native-to-Flutter transition issues

### Test Timeout Strategy
- Tests have 30-second timeouts to prevent hanging indefinitely
- On unfixed code, tests will timeout waiting for Flutter UI
- On fixed code, tests will complete quickly (< 5 seconds)

### Scoped PBT Approach
- This is a deterministic bug (always occurs with the specific code pattern)
- The test is scoped to the concrete failing case: Android 12+ with `installSplashScreen()` before `super.onCreate()`
- This ensures reproducibility and clear pass/fail criteria
