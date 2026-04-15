# Implementation Plan

- [x] 1. Write bug condition exploration test
  - **Property 1: Bug Condition** - Android Splash Screen Hang Detection
  - **CRITICAL**: This test MUST FAIL on unfixed code - failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior - it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples that demonstrate the bug exists
  - **Scoped PBT Approach**: For deterministic bugs, scope the property to the concrete failing case(s) to ensure reproducibility
  - Test that app launch on Android 12+ with `installSplashScreen()` called before `super.onCreate()` results in Flutter engine initialization failure
  - The test assertions should verify: (1) Flutter engine fails to render first frame, (2) SplashScreen widget is never displayed, (3) Navigation to '/auth' never occurs
  - Run test on UNFIXED code (with `installSplashScreen()` present in MainActivity.kt)
  - **EXPECTED OUTCOME**: Test FAILS (this is correct - it proves the bug exists)
  - Document counterexamples found: "App hangs on native splash screen, Flutter UI never renders"
  - Mark task complete when test is written, run, and failure is documented
  - _Requirements: 1.1, 1.2, 1.3_

- [-] 2. Write preservation property tests (BEFORE implementing fix)
  - **Property 2: Preservation** - Non-Android Platform Behavior and Service Initialization
  - **IMPORTANT**: Follow observation-first methodology
  - Observe behavior on UNFIXED code for non-buggy inputs (iOS, web, other platforms)
  - Write property-based tests capturing observed behavior patterns:
    - Firebase initialization completes before runApp() on all platforms
    - ThemeService loads preferences from database successfully
    - Background services (DatabaseManager, NotificationService, OneSignalService, FavoritesService) initialize asynchronously
    - iOS and other platforms launch successfully and display Flutter UI
    - AuthWrapper navigation logic works correctly after SplashScreen
  - Property-based testing generates many test cases for stronger guarantees
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests PASS (this confirms baseline behavior to preserve)
  - Mark task complete when tests are written, run, and passing on unfixed code
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [ ] 3. Fix for Android splash screen hang

  - [ ] 3.1 Remove installSplashScreen() call from MainActivity.kt
    - Remove the `installSplashScreen()` call that blocks Flutter engine initialization
    - Keep `super.onCreate(savedInstanceState)` as the first call in onCreate()
    - Preserve edge-to-edge window configuration
    - _Bug_Condition: isBugCondition(platform, splashScreenCall) where platform == "Android 12+" AND splashScreenCall == "installSplashScreen() before super.onCreate()"_
    - _Expected_Behavior: Flutter engine initializes successfully, renders SplashScreen widget, and navigates to '/auth' after 1200ms_
    - _Preservation: Firebase initialization, ThemeService, background services, iOS/other platforms, and AuthWrapper navigation remain unchanged_
    - _Requirements: 1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 3.3, 3.4, 3.5_

  - [ ] 3.2 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - Android Splash Screen Transition Success
    - **IMPORTANT**: Re-run the SAME test from task 1 - do NOT write a new test
    - The test from task 1 encodes the expected behavior
    - When this test passes, it confirms the expected behavior is satisfied
    - Run bug condition exploration test from step 1
    - **EXPECTED OUTCOME**: Test PASSES (confirms bug is fixed)
    - _Requirements: 2.1, 2.2, 2.3_

  - [ ] 3.3 Verify preservation tests still pass
    - **Property 2: Preservation** - Non-Android Platform Behavior and Service Initialization
    - **IMPORTANT**: Re-run the SAME tests from task 2 - do NOT write new tests
    - Run preservation property tests from step 2
    - **EXPECTED OUTCOME**: Tests PASS (confirms no regressions)
    - Confirm all tests still pass after fix (no regressions)

- [ ] 4. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.
