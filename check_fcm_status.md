# Check FCM Status

## Quick Links for Your Project

### Check if FCM API is Enabled
https://console.cloud.google.com/apis/dashboard?project=parking-auth-3113b

Look for "Firebase Cloud Messaging API" in the list. If you see it with a checkmark, it's enabled.

### Enable FCM API (if not enabled)
https://console.cloud.google.com/apis/library/fcm.googleapis.com?project=parking-auth-3113b

Click "ENABLE" button.

### Get Firebase Server Key
https://console.firebase.google.com/project/parking-auth-3113b/settings/cloudmessaging

Copy the "Server key" under "Cloud Messaging API (Legacy)".

### Configure OneSignal Platform
https://app.onesignal.com/apps/c50bd364-9db8-4cc6-a060-d71cd9c55c82/settings/platforms

Add your Firebase Server Key and Sender ID (501404852685).

## Your Project Info

- **Firebase Project ID**: parking-auth-3113b
- **Firebase Project Number (Sender ID)**: 501404852685
- **OneSignal App ID**: c50bd364-9db8-4cc6-a060-d71cd9c55c82
- **Android Package**: com.example.project8

## After Enabling FCM

Run this simple test:
```bash
flutter run test_onesignal_simple.dart
```

This will show you exactly if FCM is working. Look for:
- ✅ Push Token: [long string] = FCM is working
- ❌ Push Token: NULL = FCM is still not working

## Checklist

- [ ] FCM API enabled in Google Cloud Console
- [ ] Firebase Server Key copied
- [ ] Server Key added to OneSignal dashboard
- [ ] Sender ID (501404852685) added to OneSignal dashboard
- [ ] App rebuilt with `flutter clean && flutter pub get && flutter run`
- [ ] Console shows Push Token (not NULL)
- [ ] Console shows Subscription ID (not NULL)
- [ ] Device appears in OneSignal dashboard "All Users"
- [ ] Test notification sent and received

Once all checkboxes are ✅, notifications will work!
