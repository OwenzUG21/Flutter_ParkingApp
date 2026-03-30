import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/foundation.dart';

class OneSignalService {
  static final OneSignalService _instance = OneSignalService._internal();
  factory OneSignalService() => _instance;
  OneSignalService._internal();

  static const String appId = 'c50bd364-9db8-4cc6-a060-d71cd9c55c82';
  bool _isInitialized = false;

  /// Initialize OneSignal - SIMPLIFIED VERSION
  Future<void> initialize() async {
    if (_isInitialized) {
      print('⚠️ OneSignal already initialized');
      return;
    }

    try {
      print('\n🚀 ========== OneSignal Initialization ==========');
      print('📱 App ID: $appId');
      print('📱 Package: com.example.project8');

      // IMPORTANT: Set this BEFORE initialize
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      // Initialize OneSignal
      OneSignal.initialize(appId);
      print('✅ OneSignal.initialize() called');

      // Set up handlers BEFORE requesting permission
      _setupNotificationHandlers();
      print('✅ Handlers configured');

      // Wait a moment for initialization
      await Future.delayed(const Duration(seconds: 1));

      // Request permission - this should trigger the system dialog
      print('\n🔔 Requesting notification permission...');
      final granted = await OneSignal.Notifications.requestPermission(true);
      print('🔔 requestPermission() returned: $granted');

      // Wait for subscription to be created
      print('⏳ Waiting for subscription to be created...');
      await Future.delayed(const Duration(seconds: 3));

      // Check final status
      await _printStatus();

      _isInitialized = true;
      print('\n✅ ========== Initialization Complete ==========\n');
    } catch (e, stackTrace) {
      print('❌ Error initializing OneSignal: $e');
      print('Stack trace: $stackTrace');
    }
  }

  /// Print current status
  Future<void> _printStatus() async {
    try {
      final subscriptionId = OneSignal.User.pushSubscription.id;
      final token = OneSignal.User.pushSubscription.token;
      final optedIn = OneSignal.User.pushSubscription.optedIn;
      final permission = OneSignal.Notifications.permission;

      print('\n📊 ========== Current Status ==========');
      print('🔔 OneSignal Permission: $permission');
      print('🔔 Opted In: $optedIn');
      print('🔔 Subscription ID: ${subscriptionId ?? "❌ NULL"}');
      print('🔔 Push Token: ${token ?? "❌ NULL"}');

      if (subscriptionId != null && token != null) {
        print('\n✅ SUCCESS! Device is registered and ready!');
        print('📋 Use this Subscription ID to send test notifications:');
        print('   $subscriptionId');
      } else {
        print('\n❌ PROBLEM DETECTED:');
        if (token == null) {
          print('   ❌ Push Token is NULL - FCM is NOT working');
          print('   📝 Action Required:');
          print(
            '      1. Enable Firebase Cloud Messaging API in Google Cloud Console',
          );
          print('      2. Add Firebase Server Key to OneSignal dashboard');
          print('      3. Rebuild the app');
        }
        if (subscriptionId == null) {
          print('   ❌ Subscription ID is NULL - Device not registered');
        }
        if (!permission) {
          print('   ❌ OneSignal Permission is false');
          print(
            '   📝 Even though system settings show allowed, OneSignal doesn\'t see it',
          );
          print('      This usually means FCM is not working');
        }
      }
      print('=====================================\n');
    } catch (e) {
      print('❌ Error checking status: $e');
    }
  }

  /// Set up notification event handlers
  void _setupNotificationHandlers() {
    // Handle notification clicked
    OneSignal.Notifications.addClickListener((event) {
      print('🔔 Notification clicked: ${event.notification.notificationId}');
      print('📋 Title: ${event.notification.title}');
      print('📋 Body: ${event.notification.body}');
      _handleNotificationNavigation(event.notification.additionalData);
    });

    // Handle notification received in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('🔔 Notification received in foreground!');
      print('📋 Title: ${event.notification.title}');
      print('📋 Body: ${event.notification.body}');
      // Let notification display normally
    });

    // Handle permission changes
    OneSignal.Notifications.addPermissionObserver((state) {
      print('🔔 Permission observer triggered: $state');
      if (state) {
        print('✅ Permission granted via observer!');
        Future.delayed(const Duration(seconds: 2), _printStatus);
      } else {
        print('❌ Permission denied via observer');
      }
    });

    // Handle subscription changes
    OneSignal.User.pushSubscription.addObserver((state) {
      print('🔔 Subscription observer triggered:');
      print('   Previous ID: ${state.previous.id}');
      print('   Current ID: ${state.current.id}');
      print('   Token: ${state.current.token}');
      print('   Opted In: ${state.current.optedIn}');

      if (state.current.id != null) {
        print('✅ Device just got registered!');
      }
    });
  }

  /// Handle navigation
  void _handleNotificationNavigation(Map<String, dynamic>? data) {
    if (data == null) return;
    if (data.containsKey('screen')) {
      final screen = data['screen'];
      if (kDebugMode) {
        print('Navigate to screen: $screen');
      }
    }
  }

  /// Get subscription ID
  Future<String?> getSubscriptionId() async {
    final subscriptionId = OneSignal.User.pushSubscription.id;
    return subscriptionId;
  }

  /// Get player ID (alias)
  Future<String?> getPlayerId() async {
    return getSubscriptionId();
  }

  /// Set external user ID
  Future<void> setExternalUserId(String userId) async {
    try {
      OneSignal.login(userId);
      print('✅ External user ID set: $userId');
      await Future.delayed(const Duration(milliseconds: 500));
      await _printStatus();
    } catch (e) {
      print('❌ Error setting external user ID: $e');
    }
  }

  /// Remove external user ID
  Future<void> removeExternalUserId() async {
    try {
      OneSignal.logout();
      print('✅ External user ID removed');
    } catch (e) {
      print('❌ Error removing external user ID: $e');
    }
  }

  /// Send tags
  Future<void> sendTags(Map<String, String> tags) async {
    try {
      OneSignal.User.addTags(tags);
      if (kDebugMode) {
        print('✅ Tags sent: $tags');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error sending tags: $e');
      }
    }
  }

  /// Remove tags
  Future<void> removeTags(List<String> keys) async {
    try {
      OneSignal.User.removeTags(keys);
      if (kDebugMode) {
        print('✅ Tags removed: $keys');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error removing tags: $e');
      }
    }
  }

  /// Check if notifications are enabled
  bool get notificationsEnabled {
    return OneSignal.Notifications.permission;
  }

  /// Prompt for push notification permission
  Future<bool> promptForPushNotifications() async {
    try {
      print('🔔 Requesting push notification permission...');
      final result = await OneSignal.Notifications.requestPermission(true);
      print('🔔 Result: $result');

      if (result) {
        print('✅ Permission granted! Waiting for subscription...');
        await Future.delayed(const Duration(seconds: 3));
        await _printStatus();
      } else {
        print('❌ Permission denied');
      }

      return result;
    } catch (e) {
      print('❌ Error: $e');
      return false;
    }
  }
}
