import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalDiagnostic {
  static Future<Map<String, dynamic>> runDiagnostics() async {
    final results = <String, dynamic>{};

    print('\n🔍 ========== OneSignal Diagnostics ==========\n');

    // 1. Check OneSignal permission
    try {
      final oneSignalPermission = OneSignal.Notifications.permission;
      results['onesignal_permission'] = oneSignalPermission;
      print('1️⃣ OneSignal Permission: $oneSignalPermission');

      if (oneSignalPermission) {
        print('   ✅ OneSignal sees permission as GRANTED');
      } else {
        print('   ❌ OneSignal sees permission as DENIED');
        print(
          '   📝 Even if system settings show allowed, OneSignal doesn\'t see it',
        );
        print('   📝 This usually means FCM is not working');
      }
    } catch (e) {
      print('   ❌ Error: $e');
      results['onesignal_permission_error'] = e.toString();
    }

    // 2. Check subscription status
    try {
      final subscriptionId = OneSignal.User.pushSubscription.id;
      final token = OneSignal.User.pushSubscription.token;
      final optedIn = OneSignal.User.pushSubscription.optedIn;

      results['subscription_id'] = subscriptionId;
      results['token'] = token;
      results['opted_in'] = optedIn;

      print('\n2️⃣ Subscription Status:');
      print('   Subscription ID: ${subscriptionId ?? "❌ NULL"}');
      print('   Push Token: ${token ?? "❌ NULL"}');
      print('   Opted In: ${optedIn ?? false}');

      if (subscriptionId == null) {
        print('\n   ⚠️ PROBLEM: Subscription ID is NULL');
        print('   This means the device is NOT registered with OneSignal');
      } else {
        print('\n   ✅ Device is registered!');
      }

      if (token == null) {
        print('\n   ⚠️ CRITICAL PROBLEM: Push Token is NULL');
        print('   This means FCM (Firebase Cloud Messaging) is NOT working');
        print('\n   🔧 SOLUTIONS:');
        print(
          '   1. Enable "Firebase Cloud Messaging API" in Google Cloud Console',
        );
        print('      → https://console.cloud.google.com');
        print('      → Search for "Firebase Cloud Messaging API"');
        print('      → Click ENABLE');
        print('\n   2. Add Firebase Server Key to OneSignal Dashboard');
        print('      → Firebase Console > Project Settings > Cloud Messaging');
        print('      → Copy Server Key');
        print(
          '      → OneSignal Dashboard > Settings > Platforms > Google Android',
        );
        print('      → Paste Server Key and Sender ID (501404852685)');
        print('\n   3. Check Google Play Services');
        print('      → Make sure it\'s installed and updated');
        print('      → Settings > Apps > Google Play Services');
        print('\n   4. Check Internet Connection');
        print('      → FCM requires internet to register device');
      }
    } catch (e) {
      print('   ❌ Error: $e');
      results['subscription_error'] = e.toString();
    }

    // 3. Check if we can get device state
    try {
      print('\n3️⃣ Checking OneSignal User State...');
      final hasUser = OneSignal.User.pushSubscription.id != null;
      print('   Has User: $hasUser');
      results['has_user'] = hasUser;
    } catch (e) {
      print('   ❌ Error: $e');
      results['user_state_error'] = e.toString();
    }

    // 4. Summary
    print('\n📊 ========== SUMMARY ==========\n');

    final permissionOk = results['onesignal_permission'] == true;
    final hasSubscriptionId = results['subscription_id'] != null;
    final hasToken = results['token'] != null;

    if (permissionOk && hasSubscriptionId && hasToken) {
      print('✅ Everything looks good! Device should receive notifications.');
      print('📋 Subscription ID: ${results['subscription_id']}');
    } else {
      print('❌ Issues detected:\n');

      if (!permissionOk) {
        print('   ❌ OneSignal permission is false');
        print('      → This is usually caused by FCM not working\n');
      }

      if (!hasToken) {
        print('   ❌ No Push Token (FCM not working) - THIS IS THE MAIN ISSUE');
        print('      → Enable Firebase Cloud Messaging API');
        print('      → Configure OneSignal with Firebase credentials\n');
      }

      if (!hasSubscriptionId) {
        print('   ❌ No Subscription ID (device not registered)');
        print('      → This happens when FCM token is missing\n');
      }

      print('🔧 IMMEDIATE ACTION REQUIRED:');
      print('   1. Go to https://console.cloud.google.com');
      print('   2. Select project: parking-auth-3113b');
      print('   3. Enable "Firebase Cloud Messaging API"');
      print('   4. Rebuild app: flutter clean && flutter run');
    }

    print('\n========================================\n');

    return results;
  }

  static Future<void> printDetailedInfo() async {
    print('\n🔍 ========== Detailed OneSignal Info ==========\n');

    try {
      print('App ID: c50bd364-9db8-4cc6-a060-d71cd9c55c82');
      print('Package: com.example.project8');
      print('Platform: ${defaultTargetPlatform.name}');

      final subscriptionId = OneSignal.User.pushSubscription.id;
      final token = OneSignal.User.pushSubscription.token;
      final optedIn = OneSignal.User.pushSubscription.optedIn;
      final permission = OneSignal.Notifications.permission;

      print('\nOneSignal State:');
      print('  Permission: $permission');
      print('  Opted In: $optedIn');
      print('  Subscription ID: $subscriptionId');
      print('  Token: $token');

      if (token == null) {
        print('\n⚠️ CRITICAL: Push Token is NULL');
        print('This indicates Firebase Cloud Messaging (FCM) is not working.');
        print('\nThis is THE problem preventing notifications from working.');
      }
    } catch (e) {
      print('Error getting info: $e');
    }

    print('\n===============================================\n');
  }
}
