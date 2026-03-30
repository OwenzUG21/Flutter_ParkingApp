# Enable Firebase Cloud Messaging (FCM)

## CRITICAL: This is Likely Your Issue!

If notifications are enabled in system settings but you still have no push token, it means **Firebase Cloud Messaging (FCM) is not properly configured**.

## Step-by-Step: Enable FCM in Firebase Console

### 1. Go to Firebase Console
Visit: https://console.firebase.google.com

### 2. Select Your Project
- Click on your project: **parking-auth-3113b**

### 3. Enable Cloud Messaging API

**Option A: Through Firebase Console**
1. In the left sidebar, click the **gear icon** (⚙️) next to "Project Overview"
2. Click **"Project settings"**
3. Go to the **"Cloud Messaging"** tab
4. You should see:
   - Server key
   - Sender ID
   - Cloud Messaging API status

**If Cloud Messaging API is disabled:**
1. Click **"Enable Cloud Messaging API"**
2. Or click the link to Google Cloud Console
3. Enable the **"Firebase Cloud Messaging API"**

**Option B: Through Google Cloud Console**
1. Go to: https://console.cloud.google.com
2. Select project: **parking-auth-3113b**
3. In the search bar, type: **"Firebase Cloud Messaging API"**
4. Click on the API
5. Click **"Enable"** button
6. Wait for it to enable (takes a few seconds)

### 4. Get Your Server Key (for OneSignal)

1. In Firebase Console > Project Settings > Cloud Messaging tab
2. Under **"Cloud Messaging API (Legacy)"**, find:
   - **Server key**: Copy this
   - **Sender ID**: Copy this

### 5. Add Server Key to OneSignal

1. Go to [OneSignal Dashboard](https://app.onesignal.com)
2. Select your app
3. Go to **Settings** > **Platforms**
4. Click **"Google Android (FCM)"**
5. Paste your **Firebase Server Key**
6. Paste your **Firebase Sender ID**
7. Click **"Save"**

### 6. Download Updated google-services.json

After enabling FCM:
1. Go back to Firebase Console
2. Project Settings > General tab
3. Scroll down to "Your apps"
4. Find your Android app
5. Click the **"google-services.json"** download button
6. Replace the file in: `android/app/google-services.json`

## After Enabling FCM

### Rebuild Your App
```bash
flutter clean
flutter pub get
flutter run
```

### Check Console Output
You should now see:
```
✅ Device is subscribed and ready!
📋 Subscription ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
📋 Token: [long FCM token - this should NOT be null anymore]
```

## Alternative: Use OneSignal Without FCM (Not Recommended)

If you can't enable FCM, OneSignal can work with their own push service, but it's less reliable. This is not recommended.

## Verify FCM is Working

### Test 1: Check Console Logs
After enabling FCM and rebuilding, look for:
```
🔔 Subscription changed:
   ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   Token: [long token string - NOT NULL]
   Opted In: true
```

### Test 2: Check Test Screen
- Go to Settings > OneSignal Debug
- Push Token should show a long string (not "Not available")
- Subscription ID should show a UUID

### Test 3: Check Firebase Console
1. Firebase Console > Cloud Messaging
2. Click "Send your first message"
3. Enter a test message
4. Click "Send test message"
5. Enter your FCM token (from test screen)
6. Click "Test"

If this works, OneSignal will work too!

## Common FCM Issues

### Issue: "Cloud Messaging API is disabled"
**Solution:** Enable it in Google Cloud Console (see steps above)

### Issue: "google-services.json is outdated"
**Solution:** Download fresh copy from Firebase Console

### Issue: "No sender ID in google-services.json"
**Solution:** 
- Your current file shows project_number: "501404852685"
- This IS your sender ID
- Make sure it's added to OneSignal dashboard

### Issue: Testing on emulator without Google Play
**Solution:** 
- Use an emulator with Play Store
- Or test on a real device

## Quick Check: Is FCM Enabled?

Run this command to check if FCM is working:
```bash
flutter run
```

Then check console for:
- ✅ "Token: [long string]" = FCM is working
- ❌ "Token: NULL" = FCM is NOT working

## Your Firebase Project Info

- Project ID: `parking-auth-3113b`
- Project Number (Sender ID): `501404852685`
- Package Name: `com.example.project8`

Use these when configuring OneSignal!
