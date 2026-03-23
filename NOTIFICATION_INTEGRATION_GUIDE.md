# Local Notification System Integration Guide

## Overview
This guide explains how to integrate the local notification system into your ParkFlex parking app.

## Features Implemented

### 1. Payment Completed Notification
- Triggered when a user completes parking payment
- Shows payment amount and parking location
- Example: "Payment Successful - Your parking payment of UGX 11500 has been confirmed for Acacia Mall Parking."

### 2. Parking Started Notification
- Triggered when parking session begins
- Shows parking location and slot number
- Example: "Parking Started - Your parking session is now active at Acacia Mall Parking (Slot A-12)."

### 3. Booking Completed Notification
- Triggered when user finishes booking a parking slot
- Shows booking confirmation with date and location
- Example: "Booking Confirmed - Your parking slot has been successfully booked at Acacia Mall Parking for 17/03/2026 (Slot B-05)."

### 4. Booking Active Notification (Scheduled)
- Scheduled notification for when booked parking time starts
- Automatically triggers at the scheduled time
- Example: "Booking Active - Your reserved parking time is now active at Acacia Mall Parking (Slot C-08)."

### 5. Parking Expiring Soon Notification
- Warns users when parking time is about to expire
- Shows minutes remaining
- Example: "Parking Expiring Soon - Your parking at Acacia Mall Parking expires in 15 minutes."

## Installation Steps

### Step 1: Install Dependencies

Run the following command to install required packages:

```bash
flutter pub get
```

The following dependencies have been added to `pubspec.yaml`:
- `flutter_local_notifications: ^17.2.3`
- `timezone: ^0.9.4`

### Step 2: Android Configuration

Add the following permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Inside <manifest> tag, before <application> -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

<!-- Inside <application> tag -->
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" 
    android:exported="false" />
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
    android:exported="false">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

### Step 3: iOS Configuration

Add the following to `ios/Runner/Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

### Step 4: Initialization

The notification service is already initialized in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize databases
  await DatabaseManager().initialize();
  
  // Initialize notification service
  await NotificationService().initialize();
  
  runApp(const ParkFlexApp());
}
```

## Usage Examples

### Example 1: Payment Success Flow

```dart
import 'package:project8/services/notification_service.dart';

Future<void> handlePaymentSuccess() async {
  final notificationService = NotificationService();
  
  // After successful payment
  await notificationService.showPaymentCompletedNotification(
    amount: 11500,
    parkingName: 'Acacia Mall Parking',
  );
  
  // Start parking session
  await notificationService.showParkingStartedNotification(
    parkingName: 'Acacia Mall Parking',
    slotNumber: 'A-12',
  );
}
```

### Example 2: Booking Confirmation Flow

```dart
Future<void> handleBookingCompletion() async {
  final notificationService = NotificationService();
  
  final bookingDate = DateTime.now();
  
  // Show booking confirmation
  await notificationService.showBookingCompletedNotification(
    parkingName: 'Acacia Mall Parking',
    bookingDate: bookingDate,
    slotNumber: 'B-05',
  );
}
```

### Example 3: Schedule Future Booking Notification

```dart
Future<void> scheduleFutureBooking() async {
  final notificationService = NotificationService();
  
  // User books parking for tomorrow at 2:00 PM
  final scheduledTime = DateTime.now().add(Duration(days: 1)).copyWith(
    hour: 14,
    minute: 0,
  );
  
  // Schedule notification to trigger at booking time
  await notificationService.scheduleBookingActiveNotification(
    parkingName: 'Acacia Mall Parking',
    scheduledTime: scheduledTime,
    slotNumber: 'C-08',
    notificationId: scheduledTime.millisecondsSinceEpoch % 100000,
  );
}
```

### Example 4: Integration in Payment Screen

```dart
// In your MobileMoneyPaymentScreen or payment handler
Future<void> processPayment() async {
  try {
    // Process payment logic
    final paymentSuccess = await yourPaymentAPI.process();
    
    if (paymentSuccess) {
      final notificationService = NotificationService();
      
      // Show payment success notification
      await notificationService.showPaymentCompletedNotification(
        amount: totalAmount,
        parkingName: parkingName,
      );
      
      // If immediate parking, show parking started
      await notificationService.showParkingStartedNotification(
        parkingName: parkingName,
        slotNumber: slotNumber,
      );
      
      // Navigate to success screen
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  } catch (e) {
    print('Payment failed: $e');
  }
}
```

### Example 5: Integration in Booking Screen

```dart
// In your BookingScreen or reservation handler
Future<void> confirmBooking() async {
  try {
    final notificationService = NotificationService();
    
    // Save booking to database
    await saveBookingToDatabase();
    
    // Show booking confirmation
    await notificationService.showBookingCompletedNotification(
      parkingName: parkingName,
      bookingDate: selectedDate,
      slotNumber: slotNumber,
    );
    
    // Schedule notification for when booking becomes active
    final scheduledStartTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startTime.hour,
      startTime.minute,
    );
    
    await notificationService.scheduleBookingActiveNotification(
      parkingName: parkingName,
      scheduledTime: scheduledStartTime,
      slotNumber: slotNumber,
      notificationId: scheduledStartTime.millisecondsSinceEpoch % 100000,
    );
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking confirmed!')),
    );
  } catch (e) {
    print('Booking failed: $e');
  }
}
```

## Notification Service API Reference

### Methods

#### `initialize()`
Initializes the notification service. Must be called before using any other methods.

```dart
await NotificationService().initialize();
```

#### `showPaymentCompletedNotification()`
Shows immediate notification for payment completion.

```dart
await notificationService.showPaymentCompletedNotification(
  amount: 11500.0,
  parkingName: 'Acacia Mall Parking',
);
```

#### `showParkingStartedNotification()`
Shows immediate notification when parking session starts.

```dart
await notificationService.showParkingStartedNotification(
  parkingName: 'Acacia Mall Parking',
  slotNumber: 'A-12',
);
```

#### `showBookingCompletedNotification()`
Shows immediate notification for booking confirmation.

```dart
await notificationService.showBookingCompletedNotification(
  parkingName: 'Acacia Mall Parking',
  bookingDate: DateTime.now(),
  slotNumber: 'B-05',
);
```

#### `scheduleBookingActiveNotification()`
Schedules a notification for future time when booking becomes active.

```dart
await notificationService.scheduleBookingActiveNotification(
  parkingName: 'Acacia Mall Parking',
  scheduledTime: DateTime.now().add(Duration(hours: 2)),
  slotNumber: 'C-08',
  notificationId: 12345, // Unique ID for this notification
);
```

#### `showParkingExpiringSoonNotification()`
Shows warning when parking time is about to expire.

```dart
await notificationService.showParkingExpiringSoonNotification(
  parkingName: 'Acacia Mall Parking',
  minutesLeft: 15,
);
```

#### `cancelNotification()`
Cancels a specific scheduled notification.

```dart
await notificationService.cancelNotification(12345);
```

#### `cancelAllNotifications()`
Cancels all scheduled notifications.

```dart
await notificationService.cancelAllNotifications();
```

## Testing Notifications

A demo widget is provided in `lib/examples/notification_usage_examples.dart` to test all notification types:

```dart
import 'package:project8/examples/notification_usage_examples.dart';

// Navigate to demo screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NotificationDemoWidget()),
);
```

## Best Practices

1. **Unique Notification IDs**: Use unique IDs for scheduled notifications to avoid conflicts
   ```dart
   notificationId: DateTime.now().millisecondsSinceEpoch % 100000
   ```

2. **Check Time Before Scheduling**: Always verify the scheduled time is in the future
   ```dart
   if (scheduledTime.isAfter(DateTime.now())) {
     await scheduleNotification();
   }
   ```

3. **Handle Permissions**: The service automatically requests permissions, but you can check status
   ```dart
   // Permissions are requested during initialization
   ```

4. **Cancel Old Notifications**: Cancel notifications when booking is cancelled or modified
   ```dart
   await notificationService.cancelNotification(bookingId);
   ```

5. **Error Handling**: Wrap notification calls in try-catch blocks
   ```dart
   try {
     await notificationService.showPaymentCompletedNotification(...);
   } catch (e) {
     print('Notification error: $e');
   }
   ```

## Troubleshooting

### Notifications Not Showing on Android 13+
- Ensure `POST_NOTIFICATIONS` permission is added to AndroidManifest.xml
- The app will automatically request permission on first launch

### Scheduled Notifications Not Triggering
- Verify `SCHEDULE_EXACT_ALARM` permission is added
- Check that the scheduled time is in the future
- Ensure timezone package is properly initialized

### iOS Notifications Not Working
- Check that permissions are requested in Info.plist
- Verify the app has notification permissions enabled in iOS Settings

### Notifications Disappearing After App Restart
- Add `RECEIVE_BOOT_COMPLETED` permission for Android
- Scheduled notifications should persist across app restarts

## Next Steps

1. Integrate notifications into your existing payment flow
2. Add notifications to booking confirmation flow
3. Implement parking expiry warnings
4. Test on both Android and iOS devices
5. Customize notification icons and sounds as needed

## Support

For more information, refer to:
- [flutter_local_notifications documentation](https://pub.dev/packages/flutter_local_notifications)
- [timezone package documentation](https://pub.dev/packages/timezone)
