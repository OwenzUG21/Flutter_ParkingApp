# Local Notification Implementation Guide

## Overview
This guide explains the complete local notification system implemented for the ParkFlex parking app using `flutter_local_notifications` plugin.

## ✅ What's Implemented

### 1. Notification Service (`lib/services/notification_service.dart`)
A comprehensive notification service with the following features:

#### Notification Types:
1. **Payment Completed** - Confirms successful parking payment
2. **Parking Started** - Notifies when parking session begins
3. **Booking Completed** - Confirms parking slot booking
4. **Booking Active** - Scheduled notification when booked time starts
5. **Parking Expiring Soon** - Warns when parking time is about to expire

### 2. Key Features
- ✅ Android notification channels configured
- ✅ iOS notification permissions handled
- ✅ Scheduled notifications for future bookings
- ✅ High priority notifications with sound and vibration
- ✅ Notifications appear in status bar
- ✅ Tap handling for notifications
- ✅ Cancel individual or all notifications

## 📱 Notification Behavior

### Android
- Notifications appear in the status bar at the top
- Sound and vibration enabled
- High priority ensures visibility
- Notifications persist until dismissed
- Works even when app is closed

### iOS
- Notifications appear as banners
- Sound enabled
- Badge count supported
- Requires user permission (requested on first launch)

## 🔧 Configuration

### Dependencies (Already Added)
```yaml
dependencies:
  flutter_local_notifications: ^17.2.3
  timezone: ^0.9.4
```

### Android Permissions (Already Configured)
Located in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

### Initialization (Already Done)
In `lib/main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await DatabaseManager().initialize();
  
  // Initialize notification service
  await NotificationService().initialize();
  
  runApp(const ParkFlexApp());
}
```

## 📝 Usage Examples

### 1. Payment Completed Notification
```dart
import '../services/notification_service.dart';

// After successful payment
await NotificationService().showPaymentCompletedNotification(
  amount: 15000.0,
  parkingName: 'Acacia Mall Parking',
);
```

**Result:**
- Title: "Payment Successful"
- Message: "Your parking payment of UGX 15000 has been confirmed for Acacia Mall Parking."

### 2. Parking Started Notification
```dart
// When parking session begins
await NotificationService().showParkingStartedNotification(
  parkingName: 'Garden City Parking',
  slotNumber: 'A-12',
);
```

**Result:**
- Title: "Parking Started"
- Message: "Your parking session is now active at Garden City Parking (Slot A-12)."

### 3. Booking Completed Notification
```dart
// After user completes booking
await NotificationService().showBookingCompletedNotification(
  parkingName: 'Oasis Mall Parking',
  bookingDate: DateTime.now().add(Duration(days: 2)),
  slotNumber: 'B-05',
);
```

**Result:**
- Title: "Booking Confirmed"
- Message: "Your parking slot has been successfully booked at Oasis Mall Parking for 19/3/2026 (Slot B-05)."

### 4. Schedule Booking Active Notification
```dart
// Schedule notification for when booking starts
final scheduledTime = DateTime(2026, 3, 20, 14, 30); // March 20, 2026 at 2:30 PM

await NotificationService().scheduleBookingActiveNotification(
  parkingName: 'Lugogo Mall Parking',
  scheduledTime: scheduledTime,
  slotNumber: 'C-20',
  notificationId: 1001,
);
```

**Result:**
- Notification will appear at the scheduled time
- Title: "Booking Active"
- Message: "Your reserved parking time is now active at Lugogo Mall Parking (Slot C-20)."

### 5. Parking Expiring Soon Notification
```dart
// Warn user parking is expiring
await NotificationService().showParkingExpiringSoonNotification(
  parkingName: 'City Square Parking',
  minutesLeft: 15,
);
```

**Result:**
- Title: "Parking Expiring Soon"
- Message: "Your parking at City Square Parking expires in 15 minutes."

## 🔄 Integration in Your App

### In Booking Screen (`lib/screens/bookingscreen.dart`)
Already integrated! After booking creation:
```dart
// Show booking confirmation
await NotificationService().showBookingCompletedNotification(
  parkingName: widget.parkingName,
  bookingDate: selectedDate,
  slotNumber: slotNumber,
);

// Schedule notification for when booking becomes active
if (bookingStartTime.isAfter(DateTime.now())) {
  await NotificationService().scheduleBookingActiveNotification(
    parkingName: widget.parkingName,
    scheduledTime: bookingStartTime,
    slotNumber: slotNumber,
    notificationId: DateTime.now().millisecondsSinceEpoch % 100000,
  );
} else {
  // If booking is for now, show parking started
  await NotificationService().showParkingStartedNotification(
    parkingName: widget.parkingName,
    slotNumber: slotNumber,
  );
}
```

### In Payment Screen (`lib/screens/mobile_money_payment.dart`)
Already integrated! After successful payment:
```dart
// Trigger payment success notification
await NotificationService().showPaymentCompletedNotification(
  amount: widget.totalAmount.toDouble(),
  parkingName: widget.parkingName,
);
```

## 🎯 Complete Booking Flow Example

```dart
Future<void> completeBookingWithNotifications({
  required String parkingName,
  required DateTime bookingDate,
  required TimeOfDay startTime,
  required String slotNumber,
}) async {
  try {
    // 1. Create booking in database
    // ... your booking logic ...

    // 2. Show immediate confirmation
    await NotificationService().showBookingCompletedNotification(
      parkingName: parkingName,
      bookingDate: bookingDate,
      slotNumber: slotNumber,
    );

    // 3. Schedule future notification
    final bookingStartTime = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      startTime.hour,
      startTime.minute,
    );

    if (bookingStartTime.isAfter(DateTime.now())) {
      await NotificationService().scheduleBookingActiveNotification(
        parkingName: parkingName,
        scheduledTime: bookingStartTime,
        slotNumber: slotNumber,
        notificationId: DateTime.now().millisecondsSinceEpoch % 100000,
      );
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

## 🎯 Complete Payment Flow Example

```dart
Future<void> completePaymentWithNotifications({
  required double amount,
  required String parkingName,
}) async {
  try {
    // 1. Process payment
    // ... your payment logic ...

    // 2. Show payment success notification
    await NotificationService().showPaymentCompletedNotification(
      amount: amount,
      parkingName: parkingName,
    );

    // 3. Show parking started notification
    await NotificationService().showParkingStartedNotification(
      parkingName: parkingName,
    );
  } catch (e) {
    print('Error: $e');
  }
}
```

## 🛠️ Advanced Features

### Cancel a Notification
```dart
// Cancel specific notification by ID
await NotificationService().cancelNotification(1001);
```

### Cancel All Notifications
```dart
// Cancel all pending notifications
await NotificationService().cancelAllNotifications();
```

### Check Pending Notifications
```dart
// Get list of scheduled notifications
final pending = await NotificationService().getPendingNotifications();
for (var notification in pending) {
  print('ID: ${notification.id}, Title: ${notification.title}');
}
```

## 🧪 Testing Notifications

### Test Button Widget
Add this to any screen to test notifications:
```dart
ElevatedButton(
  onPressed: () async {
    await NotificationService().showPaymentCompletedNotification(
      amount: 10000.0,
      parkingName: 'Test Parking',
    );
  },
  child: Text('Test Notification'),
)
```

### Testing Scheduled Notifications
```dart
// Schedule notification 10 seconds from now for testing
final testTime = DateTime.now().add(Duration(seconds: 10));

await NotificationService().scheduleBookingActiveNotification(
  parkingName: 'Test Parking',
  scheduledTime: testTime,
  slotNumber: 'TEST-01',
  notificationId: 9999,
);
```

## 📱 Notification Channels

The app uses separate channels for different notification types:

1. **payment_channel** - Payment confirmations
2. **parking_channel** - Parking session updates
3. **booking_channel** - Booking confirmations
4. **booking_active_channel** - Active booking alerts
5. **parking_expiry_channel** - Expiry warnings

Each channel has:
- High/Max importance
- Sound enabled
- Vibration enabled
- Visible in status bar

## ⚠️ Important Notes

### Android 13+ (API 33+)
- Users must grant notification permission
- Permission is requested automatically on first launch
- Users can disable notifications in system settings

### iOS
- Permission requested on first launch
- Users can disable in Settings > Notifications
- Notifications may not appear if permission denied

### Background Notifications
- Scheduled notifications work even when app is closed
- Android may kill app in battery saver mode
- iOS handles scheduled notifications reliably

### Notification IDs
- Use unique IDs for each scheduled notification
- Same ID will replace existing notification
- Use timestamp-based IDs for uniqueness:
  ```dart
  notificationId: DateTime.now().millisecondsSinceEpoch % 100000
  ```

## 🐛 Troubleshooting

### Notifications Not Appearing?

1. **Check Permissions**
   - Android: Settings > Apps > ParkFlex > Notifications
   - iOS: Settings > Notifications > ParkFlex

2. **Check Notification Channels**
   - Android: Settings > Apps > ParkFlex > Notifications > Categories
   - Ensure channels are enabled

3. **Check Do Not Disturb**
   - Disable Do Not Disturb mode
   - Check priority settings

4. **Verify Initialization**
   - Ensure `NotificationService().initialize()` is called in main.dart
   - Check for initialization errors in console

5. **Test with Immediate Notification**
   ```dart
   await NotificationService().showPaymentCompletedNotification(
     amount: 1000.0,
     parkingName: 'Test',
   );
   ```

### Scheduled Notifications Not Working?

1. **Check Time**
   - Ensure scheduled time is in the future
   - Verify timezone is correct

2. **Check Exact Alarm Permission**
   - Android 12+: Settings > Apps > ParkFlex > Alarms & reminders
   - Must be enabled for scheduled notifications

3. **Test with Short Delay**
   ```dart
   final testTime = DateTime.now().add(Duration(seconds: 30));
   await NotificationService().scheduleBookingActiveNotification(
     parkingName: 'Test',
     scheduledTime: testTime,
     slotNumber: 'TEST',
     notificationId: 9999,
   );
   ```

## 📚 Additional Resources

- [flutter_local_notifications Documentation](https://pub.dev/packages/flutter_local_notifications)
- [Android Notification Guide](https://developer.android.com/develop/ui/views/notifications)
- [iOS Notification Guide](https://developer.apple.com/documentation/usernotifications)

## ✅ Summary

Your parking app now has a complete notification system that:
- ✅ Shows notifications in the status bar
- ✅ Confirms payments immediately
- ✅ Notifies when parking starts
- ✅ Confirms bookings
- ✅ Schedules future notifications
- ✅ Warns about expiring parking
- ✅ Works when app is closed
- ✅ Fully integrated in booking and payment flows

All notifications are configured to appear prominently with sound, vibration, and high priority to ensure users never miss important parking updates!
