# Fix: OneSignal Permission Denied

## The Issue
Your device is denying notification permissions, which prevents OneSignal from creating a Subscription ID.

## Solution: Enable Notifications Manually

### For Android

#### Method 1: Through Device Settings
1. Open your device **Settings**
2. Go to **Apps** or **Applications**
3. Find and tap **ParkFlex**
4. Tap **Notifications**
5. Enable **"Show notifications"** or **"Allow notifications"**
6. Go back to the app
7. Tap **"Refresh Status"** in the test screen

#### Method 2: Long Press App Icon
1. Long press the **ParkFlex** app icon
2. Tap **App info** or the (i) icon
3. Tap **Notifications**
4. Enable notifications
5. Restart the app

#### Method 3: From Notification Shade (if you dismissed the permission dialog)
1. When you first ran the app, Android 13+ shows a permission dialog
2. If you tapped "Don't allow", you must enable it manually
3. Follow Method 1 or 2 above

### For iOS

1. Open **Settings** app
2. Scroll down and tap **ParkFlex**
3. Tap **Notifications**
4. Enable **"Allow Notifications"**
5. Restart the app

## After Enabling Permissions

1. **Completely close the app** (swipe it away from recent apps)
2. **Reopen the app**
3. Go to **Settings tab** > **OneSignal Debug**
4. Tap **"Refresh Status"**
5. You should now see:
   - ✅ Permission: Granted
   - ✅ Subscription ID: [a long ID string]

## Verify It's Working

### Step 1: Check Console
When you restart the app, look for:
```
✅ Device is subscribed and ready to receive notifications!
📋 Use this Subscription ID to send test notifications:
   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### Step 2: Copy Subscription ID
From the test screen, copy your Subscription ID

### Step 3: Send Test Notification
1. Go to [OneSignal Dashboard](https://app.onesignal.com)
2. Messages > New Push
3. Enter title: "Test"
4. Enter message: "Testing notifications"
5. Under Audience, select **"Send to Test Users"**
6. Click **"Add Test User"**
7. Paste your Subscription ID
8. Click **"Send to Test Users"**

### Step 4: Check Your Device
You should see the notification appear in your system tray!

## Still Not Working?

### Check These:

1. **Internet Connection**
   - OneSignal needs internet to register your device
   - Try on WiFi if using mobile data

2. **Google Play Services (Android)**
   - OneSignal requires Google Play Services
   - Update it from Play Store if needed

3. **App Was Uninstalled/Reinstalled**
   - Clear app data: Settings > Apps > ParkFlex > Storage > Clear Data
   - Uninstall and reinstall the app
   - Run again

4. **Battery Optimization**
   - Some devices kill background services
   - Settings > Apps > ParkFlex > Battery
   - Set to "Unrestricted" or "Don't optimize"

5. **Do Not Disturb Mode**
   - Check if your device is in DND mode
   - Disable it temporarily for testing

## Quick Test Commands

### Restart the app with fresh logs:
```bash
flutter clean
flutter pub get
flutter run
```

### Check detailed logs:
```bash
flutter logs | grep -i onesignal
```

## Expected Console Output (Success)

```
🚀 Starting OneSignal initialization...
📱 App ID: c50bd364-9db8-4cc6-a060-d71cd9c55c82
✅ OneSignal.initialize() called
📡 Setting up OneSignal notification handlers...
✅ Handlers configured
🔔 Requesting notification permission...
🔔 Permission granted: true
📊 Subscription Status:
   Subscription ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   Token: [long token string]
   Opted In: true
   Permission: true
✅ Device is subscribed and ready to receive notifications!
```

## If You See This (Permission Denied)

```
🔔 Permission granted: false
❌ Notifications disabled
⚠️ Device is NOT subscribed to push notifications
```

**Action Required:** Enable notifications in device settings (see instructions above)

## Need More Help?

1. Share the console output (copy everything from app start)
2. Share a screenshot of the test screen
3. Confirm your Android/iOS version
4. Confirm you enabled notifications in device settings
