# OneSignal Testing - Follow These Steps

## The Problem Was Fixed! 🎉

The issue was `event.preventDefault()` in the foreground notification handler - it was blocking notifications from displaying. This has been removed.

## Test It Now - 3 Simple Steps

### Step 1: Run Your App
```bash
flutter run
```

Watch the console for:
```
✅ OneSignal initialized successfully
🔔 Subscription ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
🔔 Permission: true
```

### Step 2: Get Your Subscription ID

**Method 1: From Console (Easiest)**
- Look at the console output
- Find the line: `🔔 Subscription ID: ...`
- Copy that ID

**Method 2: From App**
- Open the app
- Go to Settings tab (bottom navigation)
- Tap "OneSignal Debug" (first item under App Settings)
- Tap the copy icon next to Subscription ID

### Step 3: Send Test Notification

1. Open [OneSignal Dashboard](https://app.onesignal.com)
2. Select your app (ID: `c50bd364-9db8-4cc6-a060-d71cd9c55c82`)
3. Click "Messages" in left sidebar
4. Click "New Push" button
5. Fill in:
   - Title: "Test Notification"
   - Message: "This is a test from OneSignal"
6. Scroll down to "Audience"
7. Select "Send to Test Users" (NOT "All Users")
8. Click "Add Test User"
9. Paste your Subscription ID
10. Click "Send to Test Users" button

## What Should Happen

**App in Foreground:**
- Notification appears in system tray
- Console shows: `🔔 Notification received in foreground!`

**App in Background:**
- Notification appears immediately

**App Closed:**
- Notification appears
- Tapping opens the app

## Troubleshooting

### No Subscription ID?
- Check internet connection
- Restart the app
- Check console for errors

### Permission Denied?
- Go to device Settings > Apps > ParkFlex > Notifications
- Enable notifications
- Restart app

### Still Not Working?
1. Try sending to "All Subscribed Users" instead
2. Check OneSignal dashboard > Audience > All Users
3. Verify your device is listed
4. Check Message Reports for delivery status

## Important Notes

- **Don't use "All Users" for testing** - Use "Test Users" with your Subscription ID
- **Android 13+** requires runtime permission - dialog shows on first launch
- **iOS** requires permission - dialog shows on first launch
- **Subscription ID** is your device identifier - you need this to send notifications

## Quick Debug

Add this temporarily to any screen to check status:
```dart
import '../widgets/onesignal_debug_fab.dart';

// In your Scaffold:
floatingActionButton: OneSignalDebugFAB(),
```

This shows a small orange button that displays your OneSignal status when tapped.
