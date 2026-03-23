import '../services/notification_service.dart';
import 'package:flutter/material.dart';

/// Helper class to simplify notification integration
/// Use this in your existing screens for quick integration
class NotificationHelper {
  static final NotificationService _service = NotificationService();

  /// Call this after successful payment
  ///
  /// Example:
  /// ```dart
  /// await NotificationHelper.onPaymentSuccess(
  ///   amount: 11500,
  ///   parkingName: 'Acacia Mall Parking',
  ///   slotNumber: 'A-12',
  /// );
  /// ```
  static Future<void> onPaymentSuccess({
    required double amount,
    required String parkingName,
    String? slotNumber,
    bool startParkingImmediately = true,
  }) async {
    try {
      // Show payment success notification
      await _service.showPaymentCompletedNotification(
        amount: amount,
        parkingName: parkingName,
      );

      // If immediate parking, show parking started notification
      if (startParkingImmediately) {
        await _service.showParkingStartedNotification(
          parkingName: parkingName,
          slotNumber: slotNumber,
        );
      }
    } catch (e) {
      debugPrint('Error showing payment notification: $e');
    }
  }

  /// Call this after booking is confirmed
  ///
  /// Example:
  /// ```dart
  /// await NotificationHelper.onBookingConfirmed(
  ///   parkingName: 'Acacia Mall Parking',
  ///   bookingDate: DateTime.now(),
  ///   startTime: TimeOfDay(hour: 14, minute: 30),
  ///   slotNumber: 'B-05',
  /// );
  /// ```
  static Future<void> onBookingConfirmed({
    required String parkingName,
    required DateTime bookingDate,
    TimeOfDay? startTime,
    String? slotNumber,
  }) async {
    try {
      // Show booking confirmation
      await _service.showBookingCompletedNotification(
        parkingName: parkingName,
        bookingDate: bookingDate,
        slotNumber: slotNumber,
      );

      // Schedule notification for when booking becomes active
      if (startTime != null) {
        final scheduledTime = DateTime(
          bookingDate.year,
          bookingDate.month,
          bookingDate.day,
          startTime.hour,
          startTime.minute,
        );

        if (scheduledTime.isAfter(DateTime.now())) {
          await _service.scheduleBookingActiveNotification(
            parkingName: parkingName,
            scheduledTime: scheduledTime,
            slotNumber: slotNumber,
            notificationId: scheduledTime.millisecondsSinceEpoch % 100000,
          );
        }
      }
    } catch (e) {
      debugPrint('Error showing booking notification: $e');
    }
  }

  /// Call this when parking session starts (without payment)
  ///
  /// Example:
  /// ```dart
  /// await NotificationHelper.onParkingStarted(
  ///   parkingName: 'Acacia Mall Parking',
  ///   slotNumber: 'C-08',
  /// );
  /// ```
  static Future<void> onParkingStarted({
    required String parkingName,
    String? slotNumber,
  }) async {
    try {
      await _service.showParkingStartedNotification(
        parkingName: parkingName,
        slotNumber: slotNumber,
      );
    } catch (e) {
      debugPrint('Error showing parking started notification: $e');
    }
  }

  /// Call this to schedule a notification for future booking
  ///
  /// Example:
  /// ```dart
  /// await NotificationHelper.scheduleFutureBooking(
  ///   parkingName: 'Acacia Mall Parking',
  ///   scheduledTime: DateTime(2026, 3, 18, 14, 30),
  ///   slotNumber: 'D-12',
  /// );
  /// ```
  static Future<void> scheduleFutureBooking({
    required String parkingName,
    required DateTime scheduledTime,
    String? slotNumber,
  }) async {
    try {
      if (scheduledTime.isAfter(DateTime.now())) {
        await _service.scheduleBookingActiveNotification(
          parkingName: parkingName,
          scheduledTime: scheduledTime,
          slotNumber: slotNumber,
          notificationId: scheduledTime.millisecondsSinceEpoch % 100000,
        );
      } else {
        debugPrint('Cannot schedule notification for past time');
      }
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  /// Call this to warn user about parking expiring soon
  ///
  /// Example:
  /// ```dart
  /// await NotificationHelper.warnParkingExpiring(
  ///   parkingName: 'Acacia Mall Parking',
  ///   minutesLeft: 15,
  /// );
  /// ```
  static Future<void> warnParkingExpiring({
    required String parkingName,
    required int minutesLeft,
  }) async {
    try {
      await _service.showParkingExpiringSoonNotification(
        parkingName: parkingName,
        minutesLeft: minutesLeft,
      );
    } catch (e) {
      debugPrint('Error showing expiry warning: $e');
    }
  }

  /// Cancel a specific notification by ID
  static Future<void> cancelNotification(int id) async {
    try {
      await _service.cancelNotification(id);
    } catch (e) {
      debugPrint('Error cancelling notification: $e');
    }
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    try {
      await _service.cancelAllNotifications();
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
    }
  }
}
