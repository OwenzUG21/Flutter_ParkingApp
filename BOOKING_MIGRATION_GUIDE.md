# Booking Screen Migration Guide

## Overview

This guide shows exactly how to update `bookingscreen.dart` to use the new `BookingService` for persistent storage instead of the in-memory `ReservationManager`.

## Current Problem

```dart
// Current code (line ~730 in bookingscreen.dart)
ReservationManager.instance.addReservation({
  'reservationId': reservationId,
  'parkingRecordId': record.id,
  'location': widget.parkingName,
  // ... more fields
});
```

**Issue**: Data stored in memory, lost when app closes.

## Solution

Replace with `BookingService` which stores in database.

## Step-by-Step Migration

### Step 1: Add BookingService Import

At the top of `lib/screens/bookingscreen.dart`, add:

```dart
import '../services/booking_service.dart';
```

### Step 2: Add BookingService Instance

In the `_BookingScreenState` class, add:

```dart
class _BookingScreenState extends State<BookingScreen> {
  // ... existing fields
  final _parkingService = ParkingService();
  final _bookingService = BookingService(); // ADD THIS LINE
  bool _isProcessing = false;
```

### Step 3: Replace Booking Creation

Find the "Proceed to Reserve" button's onPressed handler (around line 700-850).

**Replace this section**:

```dart
// OLD CODE - REMOVE THIS
final reservationId = 'RES-${DateTime.now().millisecondsSinceEpoch}';
final endTime = TimeOfDay(
  hour: (selectedTime!.hour + hours) % 24,
  minute: selectedTime!.minute,
);

ReservationManager.instance.addReservation({
  'reservationId': reservationId,
  'parkingRecordId': record.id,
  'location': widget.parkingName,
  'spot': plateNumber,
  'address': widget.parkingLocation,
  'date': '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
  'time': '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
  'timeRange': '${_formatTime(selectedTime!)} - ${_formatTime(endTime)}',
  'duration': selectedDuration,
  'cost': 'UGX ${totalCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
  'status': DateTime.now().isBefore(selectedDate) ? 'Upcoming' : 'Active',
  'paymentStatus': 'Payment pending',
  'imagePath': widget.imagePath ?? 'lib/assets/images/bd.jpg',
  'parkingRate': parkingRate,
  'serviceFee': serviceFee,
  'totalCost': totalCost,
  'slotNumber': slotNumber,
});
```

**With this NEW CODE**:

```dart
// NEW CODE - USE THIS
// The parking record is already created above by _parkingService.vehicleEntry()
// We just need to ensure it's properly set up as a booking

// Calculate the actual start time
final bookingStartTime = DateTime(
  selectedDate.year,
  selectedDate.month,
  selectedDate.day,
  selectedTime!.hour,
  selectedTime!.minute,
);

// Note: The booking is already in the database via the parking record
// created by _parkingService.vehicleEntry() above.
// The record.id is the booking ID we can use for tracking.

print('✅ Booking created with ID: ${record.id}');
print('   Plate: $plateNumber');
print('   Slot: $slotNumber');
print('   Start: $bookingStartTime');
print('   Duration: $hours hours');
print('   Total: UGX $totalCost');
```

### Step 4: Update Navigation Arguments

The navigation to dashboard should pass the booking ID:

```dart
if (mounted) {
  // Navigate to dashboard Reserve tab
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/dashboard',
    (route) => false,
    arguments: {
      'initialTab': 1, // Reserve tab index
      'bookingId': record.id, // ADD THIS - pass the booking ID
    },
  );
}
```

### Complete Updated Code Section

Here's the complete updated section for the "Proceed to Reserve" button:

```dart
onPressed: _isProcessing
    ? null
    : () async {
        // Validation
        if (_vehiclePlateController.text.trim().isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Please enter vehicle number plate'),
                backgroundColor: Colors.red.shade400,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
          return;
        }

        if (selectedTime == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Please select a time'),
                backgroundColor: Colors.red.shade400,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
          return;
        }

        setState(() => _isProcessing = true);

        try {
          // Calculate costs
          final hours = _durationHours();
          final parkingRate = widget.pricePerHour * hours;
          final serviceFee = (parkingRate * 0.15).round();
          final totalCost = parkingRate + serviceFee;
          final plateNumber = _vehiclePlateController.text.trim().toUpperCase();
          final slotNumber = widget.slotNumber?.toString() ?? 'A001';

          // Calculate booking start time
          final bookingStartTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime!.hour,
            selectedTime!.minute,
          );

          // Create booking in database
          final booking = await _bookingService.createBooking(
            plateNumber: plateNumber,
            slotNumber: slotNumber,
            startTime: bookingStartTime,
            durationHours: hours,
            parkingRate: parkingRate.toDouble(),
            serviceFee: serviceFee.toDouble(),
            vehicleType: 'car',
            notes: 'Booking from ${widget.parkingName}',
          );

          print('✅ Booking created: ID ${booking.id}');

          setState(() => _isProcessing = false);

          // Trigger notifications
          await NotificationService().showBookingCompletedNotification(
            parkingName: widget.parkingName,
            bookingDate: selectedDate,
            slotNumber: slotNumber,
          );

          if (bookingStartTime.isAfter(DateTime.now())) {
            await NotificationService().scheduleBookingActiveNotification(
              parkingName: widget.parkingName,
              scheduledTime: bookingStartTime,
              slotNumber: slotNumber,
              notificationId: DateTime.now().millisecondsSinceEpoch % 100000,
            );
          } else {
            await NotificationService().showParkingStartedNotification(
              parkingName: widget.parkingName,
              slotNumber: slotNumber,
            );
          }

          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (route) => false,
              arguments: {
                'initialTab': 1,
                'bookingId': booking.id,
              },
            );
          }
        } catch (e) {
          setState(() => _isProcessing = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error creating booking: $e'),
                backgroundColor: Colors.red.shade400,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
```

## Testing After Migration

1. **Create a booking**:
   - Fill in vehicle plate
   - Select date and time
   - Choose duration
   - Click "Proceed to Reserve"

2. **Verify in console**:
   ```
   ✅ Booking created: ID 1
   ```

3. **Close app completely**:
   - Swipe away from recent apps
   - Or force stop in settings

4. **Reopen app**:
   - Go to Reservations tab
   - Booking should be there ✅

## Dashboard Integration

Update `lib/screens/dashboard.dart` to load bookings:

```dart
class _DashboardScreenState extends State<DashboardScreen> {
  final _bookingService = BookingService();
  List<ParkingRecord> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final bookings = await _bookingService.getAllBookings();
    setState(() {
      _bookings = bookings;
    });
  }

  // In the Reserve tab, display bookings
  Widget _buildReserveTab() {
    return ListView.builder(
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        final booking = _bookings[index];
        return ListTile(
          title: Text(booking.plateNumber),
          subtitle: Text('Slot: ${booking.parkingSlot}'),
          trailing: Text('UGX ${booking.amountCharged}'),
        );
      },
    );
  }
}
```

## Benefits After Migration

✅ **Persistent Storage**: Bookings survive app restarts
✅ **Database Queries**: Can search, filter, sort bookings
✅ **Data Integrity**: Transactions ensure consistency
✅ **Scalability**: Handles thousands of bookings
✅ **Reporting**: Can generate statistics and reports

## Rollback Plan

If you need to rollback:

1. Keep the old code commented out
2. Test thoroughly before removing old code
3. Can switch back by uncommenting old code

## Summary

**Before**: In-memory storage (lost on restart)
**After**: Database storage (persists forever)

**Changes Required**:
1. Add `BookingService` import
2. Add `_bookingService` instance
3. Replace `ReservationManager.instance.addReservation()` with `_bookingService.createBooking()`
4. Update dashboard to load from database

**Time Required**: ~15 minutes
**Difficulty**: Easy (straightforward replacement)
**Risk**: Low (old code can be kept as backup)

You're all set! The migration is straightforward and will fix all persistence issues. 🚀
