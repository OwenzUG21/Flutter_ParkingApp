# 📍 Where to Add Notifications - Visual Guide

This guide shows you exactly where to add notification code in your existing ParkFlex screens.

---

## 🎯 Integration Points

### 1. Mobile Money Payment Screen
**File:** `lib/screens/mobile_money_payment.dart`

#### Where to Add:
In your payment success handler (after payment is confirmed)

#### Code to Add:
```dart
import 'package:project8/helpers/notification_helper.dart';

// Find your payment success method and add:
Future<void> _onPaymentSuccess() async {
  // Your existing payment processing code...
  
  // ✅ ADD THIS:
  await NotificationHelper.onPaymentSuccess(
    amount: widget.totalAmount,
    parkingName: widget.parkingName,
    slotNumber: 'A-12', // Use actual slot number if available
  );
  
  // Your existing navigation code...
  Navigator.pushReplacementNamed(context, '/dashboard');
}
```

#### Example Integration:
```dart
// BEFORE:
ElevatedButton(
  onPressed: () async {
    // Process payment
    bool success = await processPayment();
    if (success) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  },
  child: Text('Complete Payment'),
)

// AFTER:
ElevatedButton(
  onPressed: () async {
    // Process payment
    bool success = await processPayment();
    if (success) {
      // ✅ ADD NOTIFICATION
      await NotificationHelper.onPaymentSuccess(
        amount: widget.totalAmount,
        parkingName: widget.parkingName,
        slotNumber: 'A-12',
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  },
  child: Text('Complete Payment'),
)
```

---

### 2. Booking Screen
**File:** `lib/screens/bookingscreen.dart`

#### Where to Add:
In your "Proceed to Payment" or booking confirmation handler

#### Code to Add:
```dart
import 'package:project8/helpers/notification_helper.dart';

// Find your booking confirmation method and add:
Future<void> _onBookingConfirmed() async {
  // Your existing booking save code...
  
  // ✅ ADD THIS:
  await NotificationHelper.onBookingConfirmed(
    parkingName: widget.parkingName,
    bookingDate: selectedDate,
    startTime: selectedStartTime,
    slotNumber: widget.slotNumber?.toString(),
  );
  
  // Your existing code...
}
```

#### Example Integration:
```dart
// BEFORE:
ElevatedButton(
  onPressed: () {
    // Save booking
    saveBooking();
    
    // Navigate to payment
    Navigator.pushNamed(
      context,
      '/mobile-money-payment',
      arguments: {...},
    );
  },
  child: Text('Proceed to Payment'),
)

// AFTER:
ElevatedButton(
  onPressed: () async {
    // Save booking
    saveBooking();
    
    // ✅ ADD NOTIFICATION
    await NotificationHelper.onBookingConfirmed(
      parkingName: widget.parkingName,
      bookingDate: selectedDate,
      startTime: selectedStartTime,
      slotNumber: widget.slotNumber?.toString(),
    );
    
    // Navigate to payment
    Navigator.pushNamed(
      context,
      '/mobile-money-payment',
      arguments: {...},
    );
  },
  child: Text('Proceed to Payment'),
)
```

---

### 3. Reservation Details Screen
**File:** `lib/screens/reservationscreen.dart`

#### Where to Add:
After payment is completed for a reservation

#### Code to Add:
```dart
import 'package:project8/helpers/notification_helper.dart';

// In your payment completion handler:
Future<void> _onReservationPaymentComplete() async {
  // ✅ ADD THIS:
  await NotificationHelper.onPaymentSuccess(
    amount: widget.totalCost,
    parkingName: widget.parkingName,
    slotNumber: widget.slotNumber?.toString(),
  );
  
  await NotificationHelper.onBookingConfirmed(
    parkingName: widget.parkingName,
    bookingDate: widget.date,
    startTime: widget.startTime,
    slotNumber: widget.slotNumber?.toString(),
  );
  
  // Navigate to dashboard
  Navigator.pushReplacementNamed(context, '/dashboard');
}
```

---

### 4. Dashboard Screen (Optional)
**File:** `lib/screens/dashboard.dart`

#### Where to Add:
If you want to show parking expiry warnings

#### Code to Add:
```dart
import 'package:project8/helpers/notification_helper.dart';

// When parking is about to expire (e.g., 15 minutes before):
Future<void> _checkParkingExpiry() async {
  // Your logic to check if parking is expiring...
  
  if (minutesLeft <= 15) {
    // ✅ ADD THIS:
    await NotificationHelper.warnParkingExpiring(
      parkingName: currentParkingName,
      minutesLeft: minutesLeft,
    );
  }
}
```

---

## 🔍 Finding the Right Place

### Step 1: Identify the Event
Ask yourself: "When should the notification appear?"
- After payment? → Look for payment success handler
- After booking? → Look for booking save/confirm handler
- When parking starts? → Look for session start handler

### Step 2: Find the Method
Look for methods like:
- `_handlePaymentSuccess()`
- `_onPaymentComplete()`
- `_confirmBooking()`
- `_saveBooking()`
- `_processPayment()`

### Step 3: Add Notification Code
Add the notification call right after the main action succeeds:
```dart
// Main action (payment, booking, etc.)
await yourMainAction();

// ✅ Add notification here
await NotificationHelper.onPaymentSuccess(...);

// Continue with navigation or UI updates
Navigator.push(...);
```

---

## 📝 Complete Example: Payment Flow

Here's a complete example showing a typical payment flow with notifications:

```dart
import 'package:flutter/material.dart';
import 'package:project8/helpers/notification_helper.dart';

class MobileMoneyPaymentScreen extends StatefulWidget {
  final double totalAmount;
  final String parkingName;
  final String parkingLocation;

  const MobileMoneyPaymentScreen({
    super.key,
    required this.totalAmount,
    required this.parkingName,
    required this.parkingLocation,
  });

  @override
  State<MobileMoneyPaymentScreen> createState() =>
      _MobileMoneyPaymentScreenState();
}

class _MobileMoneyPaymentScreenState extends State<MobileMoneyPaymentScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      // 1. Process payment (your existing code)
      await Future.delayed(Duration(seconds: 2)); // Simulated payment
      
      // 2. ✅ ADD NOTIFICATIONS
      await NotificationHelper.onPaymentSuccess(
        amount: widget.totalAmount,
        parkingName: widget.parkingName,
        slotNumber: 'A-12', // Use actual slot if available
      );

      // 3. Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // 4. Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Column(
        children: [
          // Your payment UI...
          
          ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            child: _isProcessing
                ? CircularProgressIndicator()
                : Text('Complete Payment'),
          ),
        ],
      ),
    );
  }
}
```

---

## 📝 Complete Example: Booking Flow

Here's a complete example showing a typical booking flow with notifications:

```dart
import 'package:flutter/material.dart';
import 'package:project8/helpers/notification_helper.dart';

class BookingScreen extends StatefulWidget {
  final String parkingName;
  final String parkingLocation;
  final int? slotNumber;

  const BookingScreen({
    super.key,
    required this.parkingName,
    required this.parkingLocation,
    this.slotNumber,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _confirmBooking() async {
    try {
      // 1. Save booking (your existing code)
      // await saveBookingToDatabase();

      // 2. ✅ ADD NOTIFICATIONS
      await NotificationHelper.onBookingConfirmed(
        parkingName: widget.parkingName,
        bookingDate: selectedDate,
        startTime: selectedTime,
        slotNumber: widget.slotNumber?.toString(),
      );

      // 3. Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Booking confirmed! You will be notified when it becomes active.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      // 4. Navigate to payment
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/mobile-money-payment',
          arguments: {
            'totalAmount': 11500,
            'parkingName': widget.parkingName,
            'parkingLocation': widget.parkingLocation,
          },
        );
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Parking')),
      body: Column(
        children: [
          // Your booking UI (date picker, time picker, etc.)...
          
          ElevatedButton(
            onPressed: _confirmBooking,
            child: Text('Proceed to Payment'),
          ),
        ],
      ),
    );
  }
}
```

---

## ✅ Quick Checklist

Use this checklist to ensure you've added notifications everywhere:

### Payment Flow
- [ ] Import `notification_helper.dart` at the top of the file
- [ ] Find payment success handler method
- [ ] Add `await NotificationHelper.onPaymentSuccess(...)` after payment succeeds
- [ ] Test payment flow

### Booking Flow
- [ ] Import `notification_helper.dart` at the top of the file
- [ ] Find booking confirmation handler method
- [ ] Add `await NotificationHelper.onBookingConfirmed(...)` after booking is saved
- [ ] Test booking flow

### Reservation Flow
- [ ] Import `notification_helper.dart` at the top of the file
- [ ] Find reservation payment completion handler
- [ ] Add both payment and booking notifications
- [ ] Test reservation flow

---

## 🎯 Common Patterns

### Pattern 1: Payment → Immediate Parking
```dart
await NotificationHelper.onPaymentSuccess(
  amount: amount,
  parkingName: parkingName,
  slotNumber: slotNumber,
  startParkingImmediately: true, // Shows both payment + parking started
);
```

### Pattern 2: Payment → Future Booking
```dart
// Show payment success
await NotificationHelper.onPaymentSuccess(
  amount: amount,
  parkingName: parkingName,
  startParkingImmediately: false, // Only payment notification
);

// Schedule future notification
await NotificationHelper.onBookingConfirmed(
  parkingName: parkingName,
  bookingDate: futureDate,
  startTime: futureTime,
  slotNumber: slotNumber,
);
```

### Pattern 3: Booking → Payment → Parking
```dart
// 1. After booking is saved
await NotificationHelper.onBookingConfirmed(
  parkingName: parkingName,
  bookingDate: bookingDate,
  startTime: startTime,
  slotNumber: slotNumber,
);

// 2. After payment succeeds
await NotificationHelper.onPaymentSuccess(
  amount: amount,
  parkingName: parkingName,
  slotNumber: slotNumber,
);
```

---

## 🚨 Important Notes

1. **Always use `await`** - Notifications are async operations
2. **Import the helper** - Add `import 'package:project8/helpers/notification_helper.dart';`
3. **Handle errors** - Wrap in try-catch if needed
4. **Test on real device** - Emulators may not show notifications properly
5. **Check permissions** - App will request on first launch

---

## 🎉 You're Done!

Once you've added notifications to your payment and booking flows, you're all set! The notification system will automatically:
- Show immediate notifications when actions complete
- Schedule future notifications for bookings
- Handle permissions automatically
- Persist across app restarts

**Need help?** Check the other documentation files or the code examples in `lib/examples/`.
