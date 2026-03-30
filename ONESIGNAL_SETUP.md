# OneSignal Push Notifications Setup

## Configuration Complete ✓

OneSignal has been integrated into your ParkFlex app with the following setup:

### App ID
```
c50bd364-9db8-4cc6-a060-d71cd9c55c82
```

### What's Been Done

1. **Added OneSignal Package** - `onesignal_flutter: ^5.2.7` to pubspec.yaml
2. **Created OneSignalService** - `lib/services/onesignal_service.dart`
3. **Initialized in main.dart** - OneSignal starts when the app launches
4. **User ID Tracking** - Sets external user ID on login, removes on logout
5. **Notification Handlers** - Handles foreground and click events

### How It Works

**On App Launch:**
- OneSignal initializes with your app ID
- Requests notification permissions (iOS)
- Sets up notification event handlers

**On User Login:**
- Sets the Firebase user UID as the external user ID in OneSignal
- This allows you to send targeted notifications to specific users

**On User Logout:**
- Removes the external user ID from OneSignal

### Available Methods

```dart
// Get device/player ID
final playerId = await OneSignalService().getPlayerId();

// Send tags for user segmentation
await OneSignalService().sendTags({
  'user_type': 'premium',
  'city': 'Kampala',
});

// Remove tags
await OneSignalService().removeTags(['user_type']);

// Check if notifications are enabled
bool enabled = OneSignalService().notificationsEnabled;

// Prompt for notifications
await OneSignalService().promptForPushNotifications();
```

### Testing

1. Run the app: `flutter run`
2. Sign in with a user account
3. Check the console for "OneSignal initialized successfully"
4. Send a test notification from OneSignal dashboard

### Sending Notifications

From your OneSignal dashboard:
- **To all users:** Send to "All Subscribed Users"
- **To specific user:** Use "External User ID" filter with Firebase UID
- **To segments:** Use tags you've set via `sendTags()`

### Next Steps

- Configure notification icons in OneSignal dashboard
- Set up notification categories/channels
- Add custom navigation logic in `_handleNotificationNavigation()`
- Test on both Android and iOS devices
