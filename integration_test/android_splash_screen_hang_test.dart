import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project8/main.dart' as app;
import 'package:project8/screens/splash_screen.dart';
import 'package:project8/screens/auth_wrapper.dart';

/// **Validates: Requirements 1.1, 1.2, 1.3**
///
/// **Property 1: Bug Condition** - Android Splash Screen Hang Detection
///
/// **CRITICAL**: This test MUST FAIL on unfixed code - failure confirms the bug exists
/// **DO NOT attempt to fix the test or the code when it fails**
/// **NOTE**: This test encodes the expected behavior - it will validate the fix when it passes after implementation
/// **GOAL**: Surface counterexamples that demonstrate the bug exists
///
/// This test verifies that the app successfully transitions from the native splash screen
/// to the Flutter UI. On unfixed code (with installSplashScreen() called before super.onCreate()),
/// this test will FAIL because:
/// - The Flutter engine fails to initialize
/// - The SplashScreen widget is never displayed
/// - Navigation to '/auth' never occurs
///
/// Expected counterexample on unfixed code: "App hangs on native splash screen, Flutter UI never renders"
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Android Splash Screen Bug Condition Tests', () {
    testWidgets(
      'PROPERTY 1: App should transition from native splash to Flutter SplashScreen widget',
      (WidgetTester tester) async {
        // Launch the app
        app.main();

        // Wait for the app to initialize and render the first frame
        // On unfixed code, this will timeout because Flutter engine never initializes
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Verify that Flutter engine successfully rendered the SplashScreen widget
        // On unfixed code, this will FAIL - SplashScreen widget is never displayed
        expect(
          find.byType(SplashScreen),
          findsOneWidget,
          reason:
              'Flutter SplashScreen widget should be displayed after app launch. '
              'If this fails, the Flutter engine failed to initialize and render the first frame.',
        );

        // Verify that the SplashScreen contains the expected UI elements
        expect(
          find.text('ParkFlexApp'),
          findsOneWidget,
          reason: 'SplashScreen should display the app name',
        );

        expect(
          find.text('Loading...'),
          findsOneWidget,
          reason: 'SplashScreen should display the loading indicator',
        );

        // Wait for the navigation timer (1200ms) to complete
        await tester.pumpAndSettle(const Duration(milliseconds: 1500));

        // Verify that navigation to '/auth' occurred after the timer
        // On unfixed code, this will FAIL - navigation never occurs
        expect(
          find.byType(AuthWrapper),
          findsOneWidget,
          reason:
              'App should navigate to AuthWrapper after SplashScreen timer completes. '
              'If this fails, the navigation logic was never executed.',
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    testWidgets(
      'PROPERTY 1: Flutter engine should render first frame within reasonable time',
      (WidgetTester tester) async {
        // Track if the first frame was rendered
        bool firstFrameRendered = false;

        // Set up a callback to detect when the first frame is rendered
        tester.binding.addPostFrameCallback((_) {
          firstFrameRendered = true;
        });

        // Launch the app
        app.main();

        // Attempt to pump the first frame
        // On unfixed code, this will timeout or hang
        await tester.pump(const Duration(seconds: 3));

        // Verify that the first frame was rendered
        // On unfixed code, this will FAIL
        expect(
          firstFrameRendered,
          isTrue,
          reason:
              'Flutter engine should render the first frame within 3 seconds. '
              'If this fails, the Flutter engine is blocked and cannot initialize.',
        );
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    testWidgets(
      'PROPERTY 1: SplashScreen timer callback should execute and trigger navigation',
      (WidgetTester tester) async {
        // Launch the app
        app.main();

        // Wait for initial render
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Verify we're on the SplashScreen
        expect(find.byType(SplashScreen), findsOneWidget);

        // Wait for the 1200ms timer to complete
        await tester.pump(const Duration(milliseconds: 1200));

        // Pump frames to process the navigation
        await tester.pumpAndSettle();

        // Verify that navigation occurred
        // On unfixed code, this will FAIL - the timer callback never executes
        expect(
          find.byType(SplashScreen),
          findsNothing,
          reason: 'SplashScreen should be removed after navigation. '
              'If this fails, the Timer callback was never executed.',
        );

        expect(
          find.byType(AuthWrapper),
          findsOneWidget,
          reason:
              'AuthWrapper should be displayed after navigation from SplashScreen.',
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
