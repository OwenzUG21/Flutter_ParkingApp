import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../themes/colors.dart';
import '../firebase_options.dart';
import '../services/theme_service.dart';
import '../services/database_manager.dart';
import '../services/notification_service.dart';
import '../services/onesignal_service.dart';
import '../services/onesignal_diagnostic.dart';
import '../services/favorites_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();

    // Initialize progress animation controller
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _startApp();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _updateProgress(double progress, String message) {
    if (!mounted) return;
    setState(() {
      _statusMessage = message;
    });
    _progressController.animateTo(
      progress,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _startApp() async {
    try {
      // Step 1: Initialize Firebase (14%)
      _updateProgress(0.14, 'Connecting to Firebase...');
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Step 2: Initialize databases (28%)
      _updateProgress(0.28, 'Setting up databases...');
      await DatabaseManager().initialize();

      // Step 3: Initialize notification service (42%)
      _updateProgress(0.42, 'Configuring notifications...');
      await NotificationService().initialize();

      // Step 4: Initialize OneSignal (56%)
      _updateProgress(0.56, 'Initializing push notifications...');
      await OneSignalService().initialize();

      // Step 5: Run diagnostics (70%) - removed delay, just run it
      _updateProgress(0.70, 'Running diagnostics...');
      await OneSignalDiagnostic.runDiagnostics();

      // Step 6: Initialize theme service (85%)
      _updateProgress(0.85, 'Loading theme...');
      await ThemeService().initialize();

      // Step 7: Initialize favorites service (95%)
      _updateProgress(0.95, 'Loading preferences...');
      await FavoritesService().initialize();

      // Step 8: Complete (100%)
      _updateProgress(1.0, 'Ready!');
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      debugPrint('Startup error: $e');
      _updateProgress(1.0, 'Error occurred, continuing...');
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Blue background
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Logo (static)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/launcher_icon/pk.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// App Name Text
                  const Text(
                    "ParkFlexApp",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Progressive Loading Indicator at the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0, left: 40, right: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressController.value,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                      minHeight: 4,
                    );
                  },
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _statusMessage,
                    key: ValueKey(_statusMessage),
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
