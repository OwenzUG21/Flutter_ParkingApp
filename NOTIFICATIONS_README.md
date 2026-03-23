# 🔔 ParkFlex Local Notification System

A complete local notification system for the ParkFlex car parking Flutter app using `flutter_local_notifications`.

## 📋 Table of Contents
- [Features](#features)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Documentation](#documentation)
- [Files Structure](#files-structure)
- [Testing](#testing)

---

## ✨ Features

### Notification Types
1. **Payment Completed** - Confirms successful parking payment
2. **Parking Started** - Notifies when parking session begins
3. **Booking Confirmed** - Confirms parking slot booking
4. **Booking Active** - Scheduled notification when booked time starts
5. **Parking Expiring** - Warns when parking time is about to expire

### Key Capabilities
- ✅ Immediate notifications
- ✅ Scheduled notifications for future events
- ✅ Timezone-aware scheduling
- ✅ Android 13+ permission handling
- ✅ iOS notification support
- ✅ Notification management (cancel individual/all)
- ✅ Custom notification channels
- ✅ Persistent across app restarts

---

## 🚀 Quick Start

### 1. Dependencies Already Installed
```yaml
flutter_local_notifications: ^17.2.3
timezone: ^0.9.4
```

### 2. Service Already Initialized
The notification service is initialized in `main.dart` automatically when the app starts.

### 3. Start Using Notifications

#### Simple Way (Using Helper)
```dart
import 'package:project8/helpers/notification_helper.dart';

// After payment success
await NotificationHelper.onPaymentSuccess(
  amount: 11500,
  parkingName: 'Acacia Mall Parking',
  slotNumber: 'A-12',
);

// After booking confirmation
await NotificationHelper.onBookingConfirmed(
  parkingName: 'Acacia Mall Parking',
  bookingDate: DateTime.now(),
  startTime: TimeOfDay(hour: 14, minute: 30),
  slotNumber: 'B-05',
);
```

#### Advanced Way (Using Service Directly)
```dart
import 'package:project8/services/notification_service.dart';

final notificationService = NotificationService();

await notificationService.showPaymentCompletedNotification(
  amount: 11500,
  parkingName: 'Acacia Mall Parking',
);
```

---

## 💡 Usage

### Payment Flow Integration

Add to your payment success handler:

```dart
// In MobileMoneyPaymentScreen or payment handler
Future<void> _handlePaymentSuccess() async {
  // Your payment processing code...
  
  // Add notification
  await NotificationHelper.onPaymentSuccess(
    amount: widget.totalAmount,
    parkingName: widget.parkingName,
    slotNumber: 'A-12', // Use actual slot number
  );
  
  // Navigate to dashboard
  Navigator.pushReplacementNamed(context, '/dashboard');
}
```

### Booking Flow Integration

Add to your booking confirmation handler:

```dart
// In BookingScreen or reservation handler
Future<void> _handleBookingConfirmation() async {
  // Your booking save code...
  
  // Add notification
  await NotificationHelper.onBookingConfirmed(
    parkingName: widget.parkingName,
    bookingDate: selectedDate,
    startTime: selectedStartTime,
    slotNumber: widget.slotNumber?.toString(),
  );
  
  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Booking confirmed!')),
  );
}
```

### Schedule Future Notification

```dart
// Schedule notification for tomorrow at 2:00 PM
final scheduledTime = DateTime.now().add(Duration(days: 1)).copyWith(
  hour: 14,
  minute: 0,
);

await NotificationHelper.scheduleFutureBooking(
  parkingName: 'Acacia Mall Parking',
  scheduledTime: scheduledTime,
  slotNumber: 'C-08',
);
```

---

## 📚 Documentation

### Quick References
- **[NOTIFICATION_QUICK_START.md](NOTIFICATION_QUICK_START.md)** - Quick reference guide (START HERE!)
- **[NOTIFICATION_INTEGRATION_GUIDE.md](NOTIFICATION_INTEGRATION_GUIDE.md)** - Complete integration guide
- **[NOTIFICATION_SYSTEM_SUMMARY.md](NOTIFICATION_SYSTEM_SUMMARY.md)** - Implementation summary

### Code Examples
- **[lib/examples/notification_usage_examples.dart](lib/examples/notification_usage_examples.dart)** - Usage examples & demo widget
- **[lib/examples/practical_integration_example.dart](lib/examples/practical_integration_example.dart)** - Real-world integration examples

---

## 📁 Files Structure

```
project8/
├── lib/
│   ├── services/
│   │   └── notification_service.dart          # Core notification service
│   ├── helpers/
│   │   └── notification_helper.dart           # Simplified helper methods
│   ├── examples/
│   │   ├── notification_usage_examples.dart   # Usage examples & demo
│   │   └── practical_integration_example.dart # Integration examples
│   └── main.dart                              # ✅ Already initialized
│
├── android/
│   └── app/src/main/AndroidManifest.xml       # ✅ Permissions configured
│
├── pubspec.yaml                                # ✅ Dependencies added
│
└── Documentation/
    ├── NOTIFICATIONS_README.md                 # This file
    ├── NOTIFICATION_QUICK_START.md             # Quick reference
    ├── NOTIFICATION_INTEGRATION_GUIDE.md       # Full guide
    └── NOTIFICATION_SYSTEM_SUMMARY.md          # Summary
```

---

## 🧪 Testing

### Test All Notifications
Use the built-in demo widget:

```dart
import 'package:project8/examples/notification_usage_examples.dart';

// Navigate to test screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NotificationDemoWidget(),
  ),
);
```

### Test Individual Notifications

```dart
import 'package:project8/helpers/notification_helper.dart';

// Test payment notification
await NotificationHelper.onPaymentSuccess(
  amount: 11500,
  parkingName: 'Test Parking',
);

// Test scheduled notification (10 seconds from now)
await NotificationHelper.scheduleFutureBooking(
  parkingName: 'Test Parking',
  scheduledTime: DateTime.now().add(Duration(seconds: 10)),
  slotNumber: 'TEST-01',
);
```

---

## 🎯 Integration Checklist

- [x] Dependencies installed (`flutter pub get` completed)
- [x] Service initialized in main.dart
- [x] Android permissions configured
- [x] iOS permissions configured
- [x] Helper class created for easy integration
- [x] Example code provided
- [x] Documentation created
- [ ] **TODO: Add to payment success handler** ⬅️ Your task
- [ ] **TODO: Add to booking confirmation handler** ⬅️ Your task
- [ ] **TODO: Test on Android device** ⬅️ Your task
- [ ] **TODO: Test on iOS device** ⬅️ Your task

---

## 🔧 API Reference

### NotificationHelper Methods

| Method | Description | Parameters |
|--------|-------------|------------|
| `onPaymentSuccess()` | Show payment success + parking started | amount, parkingName, slotNumber |
| `onBookingConfirmed()` | Show booking confirmation + schedule active | parkingName, bookingDate, startTime, slotNumber |
| `onParkingStarted()` | Show parking session started | parkingName, slotNumber |
| `scheduleFutureBooking()` | Schedule notification for future time | parkingName, scheduledTime, slotNumber |
| `warnParkingExpiring()` | Warn about parking expiring soon | parkingName, minutesLeft |
| `cancelNotification()` | Cancel specific notification | notificationId |
| `cancelAllNotifications()` | Cancel all notifications | - |

### NotificationService Methods

For advanced usage, access the service directly:

```dart
import 'package:project8/services/notification_service.dart';

final service = NotificationService();

// All methods available:
await service.showPaymentCompletedNotification(...);
await service.showParkingStartedNotification(...);
await service.showBookingCompletedNotification(...);
await service.scheduleBookingActiveNotification(...);
await service.showParkingExpiringSoonNotification(...);
await service.cancelNotification(id);
await service.cancelAllNotifications();
```

---

## 🎨 Customization

### Change Notification Messages
Edit messages in `lib/services/notification_service.dart`:

```dart
await _notifications.show(
  1,
  'Your Custom Title',  // ← Change this
  'Your custom message',  // ← Change this
  details,
);
```

### Change Notification Icons
Update icon in notification details:

```dart
const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
  'channel_id',
  'Channel Name',
  icon: '@mipmap/your_custom_icon',  // ← Change this
);
```

### Add Notification Actions
Extend notification details with actions:

```dart
const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
  'channel_id',
  'Channel Name',
  actions: <AndroidNotificationAction>[
    AndroidNotificationAction(
      'extend',
      'Extend Parking',
    ),
  ],
);
```

---

## ⚠️ Troubleshooting

### Notifications Not Showing?
1. Check app has notification permissions enabled
2. Test on a real device (emulator may have issues)
3. Verify AndroidManifest.xml has all permissions
4. Check notification channels are not disabled

### Scheduled Notifications Not Triggering?
1. Ensure scheduled time is in the future
2. Check `SCHEDULE_EXACT_ALARM` permission
3. Test with short delay (10 seconds) first
4. Verify timezone is correctly initialized

### Android 13+ Permission Issues?
1. App will automatically request permission on first launch
2. User can manage in Settings > Apps > ParkFlex > Notifications
3. Check `POST_NOTIFICATIONS` permission in manifest

### iOS Notifications Not Working?
1. Check Info.plist has required keys
2. Verify app has notification permissions in iOS Settings
3. Test on real device (simulator may have limitations)

---

## 📱 Platform Support

- **Android:** API 21+ (Android 5.0+)
- **iOS:** iOS 10.0+
- **Permissions:** Automatically handled

---

## 🎉 You're All Set!

The notification system is fully implemented and ready to use. Just add the notification calls to your existing payment and booking flows using the examples above.

### Next Steps:
1. Read **[NOTIFICATION_QUICK_START.md](NOTIFICATION_QUICK_START.md)** for quick integration
2. Add notifications to your payment success handler
3. Add notifications to your booking confirmation handler
4. Test on a real device
5. Customize messages and icons as needed

### Need Help?
- Check **[NOTIFICATION_INTEGRATION_GUIDE.md](NOTIFICATION_INTEGRATION_GUIDE.md)** for detailed documentation
- Review code examples in `lib/examples/` folder
- Test using the `NotificationDemoWidget`

---

## 📄 License

This notification system is part of the ParkFlex project.

---

**Happy Coding! 🚗💨**
