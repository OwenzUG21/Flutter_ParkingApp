// Simple OneSignal Test - Run this to verify basic setup
// Run with: flutter run test_onesignal_simple.dart

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('\n🧪 ========== Simple OneSignal Test ==========\n');
  
  // Step 1: Set log level
  print('1️⃣ Setting log level...');
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  print('✅ Log level set\n');
  
  // Step 2: Initialize
  print('2️⃣ Initializing OneSignal...');
  OneSignal.initialize("c50bd364-9db8-4cc6-a060-d71cd9c55c82");
  print('✅ Initialize called\n');
  
  // Step 3: Wait for initialization
  print('3️⃣ Waiting 2 seconds for initialization...');
  await Future.delayed(const Duration(seconds: 2));
  print('✅ Wait complete\n');
  
  // Step 4: Request permission
  print('4️⃣ Requesting permission...');
  final granted = await OneSignal.Notifications.requestPermission(true);
  print('✅ Permission result: $granted\n');
  
  // Step 5: Wait for subscription
  print('5️⃣ Waiting 3 seconds for subscription...');
  await Future.delayed(const Duration(seconds: 3));
  print('✅ Wait complete\n');
  
  // Step 6: Check status
  print('6️⃣ Checking status...');
  final subscriptionId = OneSignal.User.pushSubscription.id;
  final token = OneSignal.User.pushSubscription.token;
  final optedIn = OneSignal.User.pushSubscription.optedIn;
  final permission = OneSignal.Notifications.permission;
  
  print('\n📊 ========== RESULTS ==========');
  print('Permission: $permission');
  print('Opted In: $optedIn');
  print('Subscription ID: ${subscriptionId ?? "NULL"}');
  print('Push Token: ${token ?? "NULL"}');
  print('================================\n');
  
  if (token == null) {
    print('❌ FAILED: Push Token is NULL');
    print('\n🔧 This means FCM is not working.');
    print('📝 Action Required:');
    print('   1. Enable Firebase Cloud Messaging API');
    print('   2. Add Firebase Server Key to OneSignal');
    print('   3. Run this test again\n');
  } else {
    print('✅ SUCCESS: Device is registered!');
    print('📋 Subscription ID: $subscriptionId');
    print('📋 You can now send notifications!\n');
  }
  
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text('Check console for test results'),
      ),
    ),
  ));
}
