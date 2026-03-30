# OneSignal Not Showing Notifications - Quick Fix

## What I Fixed

1. **Removed `event.preventDefault()`** - This was blocking notifications from displaying
2. **Added detailed logging** - You'll now see exactly what's happening
3. **Added test screen** - Access via Settings > OneSignal Debug
4. **Added subscription observer** - Tracks when device registers

## Steps to Test Right Now

### Step 1: Run the App
```bash
flutter run
```

### Step 2: Check Console Output
Look for these lines:
```
✅ OneSignal initialized successfully
🔔 Subscription ID: [YOUR-ID-HERE]
🔔 Permission: true
```

**If Subscription ID is null:**
- Check internet connection
- Make sure Google Play Services is installed (Android)
- Try restarting the app

### Step 3: Get Your Subscription ID

**Option A: From Console**
- Copy the Subscription ID from the console logs

**Option B: From Test Screen**
- Open app
- Go to Settings tab (bottom nav)
- Tap "OneSignal Debug"
- Copy the Subscription ID

### Step 4: Send Test Notification

1. Go to [OneSignal Dashboard](https://app.onesignal.com)
2. Select your app
3. Click "Messages" > "New Push"
4. Enter title and message
5. Under "Audience", click "Send to Test Users"
6. Click "Add Test User"
7. Paste your Subscription ID
8. Click "Send to Test Users"

### Step 5: Verify

**App in Foreground:**
- You should see the notification in the system tray
- Console will show: `🔔 Notification received in foreground!`

**App in Background:**
- Notification appears immediately in system tray

**App Closed:**
- Notification appears in system tray
- Tapping it opens the app

## Still Not Working?

### Check Permission
```dart
// In test screen, check if permission is granted
// If not, tap "Request Permission" button
```

### Check Device Registration
The Subscription ID must not be null. If it is:
1. Restart the app
2. Check internet connection
3. On Android, verify Google Play Services is working
4. Try on a different device

### Check OneSignal Dashboard
1. Go to "Audience" > "All Users"
2. Look for your device (search by Subscription ID)
3. If not listed, device is not registered

### Android 13+ Specific
- Runtime permission dialog should appear on first launch
- If you denied it, go to Settings > Apps > ParkFlex > Notifications
- Enable notifications manually
- Restart the app

## Testing Checklist

- [ ] App runs without errors
- [ ] Console shows "OneSignal initialized successfully"
- [ ] Subscription ID is not null
- [ ] Permission is granted
- [ ] Device appears in OneSignal dashboard
- [ ] Test notification sent to Subscription ID
- [ ] Notification appears in system tray

## Need More Help?

Check the full troubleshooting guide: `ONESIGNAL_TROUBLESHOOTING.md`
