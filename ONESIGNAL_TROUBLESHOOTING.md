# OneSignal Push Notifications - Troubleshooting Guide

## Quick Checklist

### 1. Check Console Logs
When you run the app, look for these messages in the console:

```
🚀 Starting OneSignal initialization...
✅ OneSignal.initialize() called with app ID: c50bd364-9db8-4cc6-a060-d71cd9c55c82
🔔 Permission request result: true
📡 Setting up OneSignal notification handlers...
✅ Notification handlers set up complete
✅ OneSignal initialized successfully
📱 App ID: c50bd364-9db8-4cc6-a060-d71cd9c55c82
🔔 Subscription ID: [YOUR-DEVICE-ID]
🔔 Opted In: true
🔔 Permission: true
```

### 2. Access Test Screen
Navigate to the test screen to see your device info:
```dart
Navigator.pushNamed(context, '/onesignal-test');
```

Or add this button temporarily to your dashboard:
```dart
FloatingActionButton(
  onPressed: () => Navigator.pushNamed(context, '/onesignal-test'),
  child: Icon(Icons.bug_report),
)
```

### 3. Common Issues & Solutions

#### Issue: Subscription ID is null
**Causes:**
- No internet connection
- Google Play Services not installed (Android)
- App ID is incorrect
- OneSignal servers are unreachable

**Solutions:**
- Check internet connection
- Verify Google Play Services on Android device
- Confirm app ID: `c50bd364-9db8-4cc6-a060-d71cd9c55c82`
- Try on a different device

#### Issue: Permission denied
**Solutions:**
- Go to device Settings > Apps > ParkFlex > Notifications
- Enable notifications manually
- Restart the app after enabling

#### Issue: Notifications not showing when app is in foreground
**Status:** Fixed! The foreground handler now allows notifications to display.

#### Issue: Notifications not showing when app is in background
**Causes:**
- Device is not subscribed (check Subscription ID)
- Sending to wrong audience in OneSignal dashboard
- Battery optimization killing the app

**Solutions:**
- Copy Subscription ID from test screen
- In OneSignal dashboard, use "Send to Test Users" and paste Subscription ID
- Disable battery optimization for ParkFlex app

### 4. How to Send Test Notification

**From OneSignal Dashboard:**

1. Go to Messages > New Push
2. Enter your message title and content
3. Under "Audience", select "Send to Test Users"
4. Click "Add Test User"
5. Paste your Subscription ID (from test screen)
6. Click "Send to Test Users"

**Important:** Don't use "Send to All Users" for testing - use "Test Users" with your Subscription ID!

### 5. Verify Device Registration

Run this in your app to check registration:
```dart
final subscriptionId = OneSignal.User.pushSubscription.id;
final optedIn = OneSignal.User.pushSubscription.optedIn;
final permission = OneSignal.Notifications.permission;

print('Subscription ID: $subscriptionId');
print('Opted In: $optedIn');
print('Permission: $permission');
```

All three should be true/non-null for notifications to work.

### 6. Android 13+ Specific

If testing on Android 13 or higher:
- Runtime notification permission is required
- The app will show a permission dialog on first launch
- If denied, you must enable manually in Settings

### 7. Test Scenarios

**Test 1: App in Foreground**
- Open the app
- Send notification from OneSignal
- Should see notification in system tray

**Test 2: App in Background**
- Press home button (don't close app)
- Send notification from OneSignal
- Should see notification immediately

**Test 3: App Closed**
- Close the app completely
- Send notification from OneSignal
- Should see notification
- Tap it to open the app

### 8. Debug Commands

Check if the app is running:
```bash
flutter run
```

View detailed logs:
```bash
flutter logs
```

Clear app data and reinstall:
```bash
flutter clean
flutter pub get
flutter run
```

### 9. OneSignal Dashboard Checks

- Verify your app ID matches: `c50bd364-9db8-4cc6-a060-d71cd9c55c82`
- Check "Audience" > "All Users" to see if your device is subscribed
- Look for your Subscription ID in the list
- Check "Delivery" > "Message Reports" to see if messages were delivered

### 10. Still Not Working?

If notifications still don't show:
1. Check the console logs for errors
2. Use the test screen to verify Subscription ID exists
3. Try sending to "All Subscribed Users" instead of test users
4. Restart the app completely
5. Try on a different device
6. Check OneSignal dashboard for delivery status
