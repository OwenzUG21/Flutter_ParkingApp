import 'package:flutter/material.dart';
import '../services/notification_service.dart';

/// This file demonstrates how to use the NotificationService in your parking app.
/// The notification service is already initialized in main.dart.

class NotificationUsageExamples {
  final _notificationService = NotificationService();

  /// Example 1: Show Payment Completed Notification
  /// Call this after a successful payment transaction
  Future<void> examplePaymentCompleted() async {
    await _notificationService.showPaymentCompletedNotification(
      amount: 15000.0, // Payment amount in UGX
      parkingName: 'Acacia Mall Parking', // Optional parking location
    );
  }

  /// Example 2: Show Parking Started Notification
  /// Call this when a parking session begins
  Future<void> exampleParkingStarted() async {
    await _notificationService.showParkingStartedNotification(
      parkingName: 'Garden City Parking',
      slotNumber: 'A-12', // Optional slot number
    );
  }

  /// Example 3: Show Booking Completed Notification
  /// Call this immediately after user completes a booking
  Future<void> exampleBookingCompleted() async {
    await _notificationService.showBookingCompletedNotification(
      parkingName: 'Oasis Mall Parking',
      bookingDate: DateTime.now().add(const Duration(days: 2)),
      slotNumber: 'B-05', // Optional slot number
    );
  }

  /// Example 4: Schedule Booking Active Notification
  /// Call this to schedule a notification for when booked time starts
  Future<void> exampleScheduleBookingActive() async {
    // Schedule notification for 2 hours from now
    final scheduledTime = DateTime.now().add(const Duration(hours: 2));

    await _notificationService.scheduleBookingActiveNotification(
      parkingName: 'Lugogo Mall Parking',
      scheduledTime: scheduledTime,
      slotNumber: 'C-20',
      notificationId: 1001, // Unique ID for this notification
    );
  }

  /// Example 5: Show Parking Expiring Soon Notification
  /// Call this to warn users their parking time is about to expire
  Future<void> exampleParkingExpiring() async {
    await _notificationService.showParkingExpiringSoonNotification(
      parkingName: 'City Square Parking',
      minutesLeft: 15, // Minutes until parking expires
    );
  }

  /// Example 6: Complete Booking Flow with Notifications
  /// This shows how to integrate notifications in a complete booking flow
  Future<void> exampleCompleteBookingFlow({
    required BuildContext context,
    required String parkingName,
    required DateTime bookingDate,
    required TimeOfDay startTime,
    required String slotNumber,
  }) async {
    try {
      // Step 1: Create booking in database (your existing code)
      // ... your booking logic here ...

      // Step 2: Show booking confirmation notification
      await _notificationService.showBookingCompletedNotification(
        parkingName: parkingName,
        bookingDate: bookingDate,
        slotNumber: slotNumber,
      );

      // Step 3: Schedule notification for when booking becomes active
      final bookingStartTime = DateTime(
        bookingDate.year,
        bookingDate.month,
        bookingDate.day,
        startTime.hour,
        startTime.minute,
      );

      // Only schedule if booking is in the future
      if (bookingStartTime.isAfter(DateTime.now())) {
        await _notificationService.scheduleBookingActiveNotification(
          parkingName: parkingName,
          scheduledTime: bookingStartTime,
          slotNumber: slotNumber,
          notificationId: DateTime.now().millisecondsSinceEpoch % 100000,
        );
      } else {
        // If booking is for now, show parking started notification
        await _notificationService.showParkingStartedNotification(
          parkingName: parkingName,
          slotNumber: slotNumber,
        );
      }

      // Step 4: Show success message to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking confirmed! You will be notified.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Handle errors
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Example 7: Complete Payment Flow with Notifications
  /// This shows how to integrate notifications in a payment flow
  Future<void> exampleCompletePaymentFlow({
    required BuildContext context,
    required double amount,
    required String parkingName,
    required String phoneNumber,
  }) async {
    try {
      // Step 1: Process payment (your existing code)
      // ... your payment processing logic here ...
      await Future.delayed(const Duration(seconds: 2)); // Simulated payment

      // Step 2: Show payment success notification
      await _notificationService.showPaymentCompletedNotification(
        amount: amount,
        parkingName: parkingName,
      );

      // Step 3: Show parking started notification
      await _notificationService.showParkingStartedNotification(
        parkingName: parkingName,
      );

      // Step 4: Navigate to success screen
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      // Handle payment errors
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Example 8: Cancel a Scheduled Notification
  /// Call this if user cancels their booking
  Future<void> exampleCancelNotification(int notificationId) async {
    await _notificationService.cancelNotification(notificationId);
  }

  /// Example 9: Cancel All Notifications
  /// Call this when user logs out or clears all bookings
  Future<void> exampleCancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }

  /// Example 10: Check Pending Notifications
  /// Call this to see what notifications are scheduled
  Future<void> exampleCheckPendingNotifications() async {
    final pending = await _notificationService.getPendingNotifications();

    for (var notification in pending) {
      debugPrint(
        'Pending notification: ${notification.id} - ${notification.title}',
      );
    }
  }

  /// Example 11: Parking Session with Expiry Warning
  /// This shows how to set up expiry warnings for active parking sessions
  Future<void> exampleParkingSessionWithWarning({
    required String parkingName,
    required int durationHours,
  }) async {
    // Show parking started
    await _notificationService.showParkingStartedNotification(
      parkingName: parkingName,
    );

    // Schedule expiry warning 15 minutes before end
    // In a real app, you would use a background service or timer
    // This is just a demonstration
    final warningTime = DateTime.now().add(
      Duration(hours: durationHours, minutes: -15),
    );

    if (warningTime.isAfter(DateTime.now())) {
      // You could schedule this using a background task
      // For now, this shows the concept
      await Future.delayed(warningTime.difference(DateTime.now()));
      await _notificationService.showParkingExpiringSoonNotification(
        parkingName: parkingName,
        minutesLeft: 15,
      );
    }
  }
}

/// Widget Example: Button to Test Notifications
class NotificationTestButton extends StatelessWidget {
  const NotificationTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Test payment notification
        await NotificationService().showPaymentCompletedNotification(
          amount: 10000.0,
          parkingName: 'Test Parking',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test notification sent!')),
        );
      },
      child: const Text('Test Notification'),
    );
  }
}
