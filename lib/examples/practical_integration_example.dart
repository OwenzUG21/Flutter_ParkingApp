import 'package:flutter/material.dart';
import '../services/notification_service.dart';

/// This file shows practical examples of integrating notifications
/// into your existing ParkFlex screens

/// Example 1: Integration in Mobile Money Payment Screen
/// Add this to your MobileMoneyPaymentScreen class
class PaymentScreenIntegration {
  final NotificationService _notificationService = NotificationService();

  /// Call this method after successful payment
  Future<void> onPaymentSuccess({
    required BuildContext context,
    required double totalAmount,
    required String parkingName,
    required String parkingLocation,
    String? slotNumber,
    bool isImmediateParking = true,
  }) async {
    try {
      // 1. Show payment success notification
      await _notificationService.showPaymentCompletedNotification(
        amount: totalAmount,
        parkingName: parkingName,
      );

      // 2. If immediate parking, show parking started notification
      if (isImmediateParking) {
        await _notificationService.showParkingStartedNotification(
          parkingName: parkingName,
          slotNumber: slotNumber,
        );
      }

      // 3. Navigate to dashboard or success screen
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false,
        );
      }
    } catch (e) {
      print('Error showing payment notification: $e');
    }
  }

  /// Example usage in your payment button handler:
  ///
  /// ElevatedButton(
  ///   onPressed: () async {
  ///     // Process payment
  ///     bool paymentSuccess = await processPayment();
  ///
  ///     if (paymentSuccess) {
  ///       await onPaymentSuccess(
  ///         context: context,
  ///         totalAmount: widget.totalAmount,
  ///         parkingName: widget.parkingName,
  ///         parkingLocation: widget.parkingLocation,
  ///         slotNumber: 'A-12',
  ///       );
  ///     }
  ///   },
  ///   child: Text('Complete Payment'),
  /// )
}

/// Example 2: Integration in Booking Screen
/// Add this to your BookingScreen class
class BookingScreenIntegration {
  final NotificationService _notificationService = NotificationService();

  /// Call this method when user confirms booking
  Future<void> onBookingConfirmed({
    required BuildContext context,
    required String parkingName,
    required String parkingLocation,
    required DateTime bookingDate,
    required TimeOfDay startTime,
    required int hours,
    String? slotNumber,
  }) async {
    try {
      // 1. Show booking confirmation notification
      await _notificationService.showBookingCompletedNotification(
        parkingName: parkingName,
        bookingDate: bookingDate,
        slotNumber: slotNumber,
      );

      // 2. Schedule notification for when booking becomes active
      final DateTime scheduledStartTime = DateTime(
        bookingDate.year,
        bookingDate.month,
        bookingDate.day,
        startTime.hour,
        startTime.minute,
      );

      // Only schedule if the time is in the future
      if (scheduledStartTime.isAfter(DateTime.now())) {
        await _notificationService.scheduleBookingActiveNotification(
          parkingName: parkingName,
          scheduledTime: scheduledStartTime,
          slotNumber: slotNumber,
          notificationId: scheduledStartTime.millisecondsSinceEpoch % 100000,
        );
      }

      // 3. Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Booking confirmed! You will be notified when it becomes active.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error showing booking notification: $e');
    }
  }

  /// Example usage in your "Proceed to Payment" button:
  ///
  /// ElevatedButton(
  ///   onPressed: () async {
  ///     await onBookingConfirmed(
  ///       context: context,
  ///       parkingName: widget.parkingName,
  ///       parkingLocation: widget.parkingLocation,
  ///       bookingDate: selectedDate,
  ///       startTime: selectedStartTime,
  ///       hours: selectedHours,
  ///       slotNumber: widget.slotNumber?.toString(),
  ///     );
  ///
  ///     // Navigate to payment screen
  ///     Navigator.pushNamed(context, '/mobile-money-payment', arguments: {...});
  ///   },
  ///   child: Text('Proceed to Payment'),
  /// )
}

/// Example 3: Integration in Reservation Details Screen
/// Add this to your ReservationDetailsScreen class
class ReservationScreenIntegration {
  final NotificationService _notificationService = NotificationService();

  /// Call this after payment is completed for a reservation
  Future<void> onReservationPaymentComplete({
    required BuildContext context,
    required String parkingName,
    required DateTime bookingDate,
    required TimeOfDay? startTime,
    required double totalCost,
    String? slotNumber,
  }) async {
    try {
      // 1. Show payment success notification
      await _notificationService.showPaymentCompletedNotification(
        amount: totalCost,
        parkingName: parkingName,
      );

      // 2. Show booking confirmation
      await _notificationService.showBookingCompletedNotification(
        parkingName: parkingName,
        bookingDate: bookingDate,
        slotNumber: slotNumber,
      );

      // 3. Schedule active notification if start time is provided
      if (startTime != null) {
        final DateTime scheduledTime = DateTime(
          bookingDate.year,
          bookingDate.month,
          bookingDate.day,
          startTime.hour,
          startTime.minute,
        );

        if (scheduledTime.isAfter(DateTime.now())) {
          await _notificationService.scheduleBookingActiveNotification(
            parkingName: parkingName,
            scheduledTime: scheduledTime,
            slotNumber: slotNumber,
            notificationId: scheduledTime.millisecondsSinceEpoch % 100000,
          );
        }
      }

      // 4. Navigate to dashboard
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false,
        );
      }
    } catch (e) {
      print('Error showing reservation notification: $e');
    }
  }
}

/// Example 4: Complete Payment Flow with Error Handling
class CompletePaymentFlowExample extends StatefulWidget {
  final double totalAmount;
  final String parkingName;
  final String parkingLocation;
  final String? slotNumber;

  const CompletePaymentFlowExample({
    super.key,
    required this.totalAmount,
    required this.parkingName,
    required this.parkingLocation,
    this.slotNumber,
  });

  @override
  State<CompletePaymentFlowExample> createState() =>
      _CompletePaymentFlowExampleState();
}

class _CompletePaymentFlowExampleState
    extends State<CompletePaymentFlowExample> {
  final NotificationService _notificationService = NotificationService();
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      // Simulate payment processing
      await Future.delayed(Duration(seconds: 2));

      // Payment successful - show notifications
      await _notificationService.showPaymentCompletedNotification(
        amount: widget.totalAmount,
        parkingName: widget.parkingName,
      );

      await _notificationService.showParkingStartedNotification(
        parkingName: widget.parkingName,
        slotNumber: widget.slotNumber,
      );

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Text('Payment Successful'),
              ],
            ),
            content: Text(
              'Your parking payment has been confirmed. You will receive notifications about your parking session.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/dashboard',
                    (route) => false,
                  );
                },
                child: Text('Go to Dashboard'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle payment error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${e.toString()}'),
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
      body: Center(
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _processPayment,
          child: _isProcessing
              ? CircularProgressIndicator()
              : Text('Complete Payment'),
        ),
      ),
    );
  }
}

/// Example 5: Booking with Future Date/Time
class FutureBookingExample {
  final NotificationService _notificationService = NotificationService();

  Future<void> bookParkingForFutureDateTime({
    required BuildContext context,
    required String parkingName,
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
    required int durationHours,
    String? slotNumber,
  }) async {
    try {
      // Combine date and time
      final DateTime bookingDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // Validate future time
      if (bookingDateTime.isBefore(DateTime.now())) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot book for past time'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Save booking to database
      // ... your database save logic ...

      // Show immediate booking confirmation
      await _notificationService.showBookingCompletedNotification(
        parkingName: parkingName,
        bookingDate: selectedDate,
        slotNumber: slotNumber,
      );

      // Schedule notification for when booking becomes active
      await _notificationService.scheduleBookingActiveNotification(
        parkingName: parkingName,
        scheduledTime: bookingDateTime,
        slotNumber: slotNumber,
        notificationId: bookingDateTime.millisecondsSinceEpoch % 100000,
      );

      // Optionally schedule a reminder 15 minutes before
      final DateTime reminderTime = bookingDateTime.subtract(
        Duration(minutes: 15),
      );

      if (reminderTime.isAfter(DateTime.now())) {
        await _notificationService.scheduleBookingActiveNotification(
          parkingName: parkingName,
          scheduledTime: reminderTime,
          slotNumber: slotNumber,
          notificationId: (reminderTime.millisecondsSinceEpoch % 100000) + 1,
        );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Booking confirmed! You will be notified 15 minutes before and when it becomes active.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      print('Error booking parking: $e');
    }
  }
}

/// Example 6: Quick Integration Snippet for Existing Code
/// 
/// Add this to your existing payment success handler:
/// 
/// ```dart
/// // After successful payment
/// final notificationService = NotificationService();
/// 
/// await notificationService.showPaymentCompletedNotification(
///   amount: totalAmount,
///   parkingName: parkingName,
/// );
/// 
/// await notificationService.showParkingStartedNotification(
///   parkingName: parkingName,
///   slotNumber: slotNumber,
/// );
/// ```
/// 
/// Add this to your booking confirmation handler:
/// 
/// ```dart
/// // After booking is saved
/// final notificationService = NotificationService();
/// 
/// await notificationService.showBookingCompletedNotification(
///   parkingName: parkingName,
///   bookingDate: bookingDate,
///   slotNumber: slotNumber,
/// );
/// 
/// // Schedule future notification
/// final scheduledTime = DateTime(
///   bookingDate.year,
///   bookingDate.month,
///   bookingDate.day,
///   startTime.hour,
///   startTime.minute,
/// );
/// 
/// if (scheduledTime.isAfter(DateTime.now())) {
///   await notificationService.scheduleBookingActiveNotification(
///     parkingName: parkingName,
///     scheduledTime: scheduledTime,
///     slotNumber: slotNumber,
///     notificationId: scheduledTime.millisecondsSinceEpoch % 100000,
///   );
/// }
/// ```
