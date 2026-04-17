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
import '../services/translation_service.dart';
import '../utils/onboarding_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _typewriterController;
  late Animation<double> _fadeAnimation;
  String _statusMessage = '';
  String _displayedText = '';
  final String _fullText = 'ParkFlexAPP';
  final int _typingSpeed = 100; // milliseconds per character

  @override
  void initState() {
    super.initState();
    _statusMessage = 'loading'.tr(context);

    // Initialize progress animation controller
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize typewriter animation controller
    final totalDuration = _fullText.length * _typingSpeed;
    _typewriterController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalDuration),
    );

    // Create fade-in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _typewriterController,
        curve: Curves.easeOut,
      ),
    );

    // Start typewriter animation
    _startTypewriterAnimation();

    _startApp();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _typewriterController.dispose();
    super.dispose();
  }

  void _startTypewriterAnimation() {
    _typewriterController.addListener(() {
      if (!mounted) return;

      final progress = _typewriterController.value;
      final currentLength = (_fullText.length * progress).floor();

      setState(() {
        _displayedText = _fullText.substring(0, currentLength);
      });
    });

    _typewriterController.forward();
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
      // Show "Loading..." during all initialization
      _updateProgress(0.1, 'loading'.tr(context));

      // Initialize Firebase
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Initialize databases
      _updateProgress(0.3, 'loading'.tr(context));
      await DatabaseManager().initialize();

      // Initialize notification service
      _updateProgress(0.5, 'loading'.tr(context));
      await NotificationService().initialize();

      // Initialize OneSignal
      _updateProgress(0.6, 'loading'.tr(context));
      await OneSignalService().initialize();

      // Run diagnostics
      _updateProgress(0.7, 'loading'.tr(context));
      await OneSignalDiagnostic.runDiagnostics();

      // Initialize theme service
      _updateProgress(0.85, 'loading'.tr(context));
      await ThemeService().initialize();

      // Initialize favorites service
      _updateProgress(0.95, 'loading'.tr(context));
      await FavoritesService().initialize();

      // Complete - show "Ready!"
      _updateProgress(1.0, 'Ready!');

      // Wait for typewriter animation to complete
      await _typewriterController.forward();

      // Wait 1 second after animation completes
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      debugPrint('Startup error: $e');
      _updateProgress(1.0, 'Ready!');

      // Wait for typewriter animation to complete
      await _typewriterController.forward();

      // Wait 1 second after animation completes
      await Future.delayed(const Duration(seconds: 1));
    }

    if (!mounted) return;

    // Check onboarding status
    final onboardingComplete = await OnboardingHelper.isOnboardingComplete();

    if (!mounted) return;

    if (!onboardingComplete) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      Navigator.pushReplacementNamed(context, '/auth');
    }
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

                  /// App Name Text with Typewriter Animation
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          _displayedText,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      );
                    },
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
