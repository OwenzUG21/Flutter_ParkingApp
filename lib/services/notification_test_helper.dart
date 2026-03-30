import 'notification_service.dart';
import 'notification_storage_service.dart';
import '../models/notification_model.dart';

class NotificationTestHelper {
  static final NotificationService _notificationService = NotificationService();
  static final NotificationStorageService _storageService =
      NotificationStorageService();

  /// Generate sample notifications for testing
  static Future<void> generateSampleNotifications() async {
    // Sample payment notification
    await _storageService.saveNotification(
      NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Payment Successful',
        body:
            'Your parking payment of UGX 11,500 has been confirmed for Acacia Mall Parking.',
        type: 'payment',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        payload: 'payment_completed',
      ),
    );

    // Sample booking notification
    await _storageService.saveNotification(
      NotificationModel(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        title: 'Booking Confirmed',
        body:
            'Your parking slot has been successfully booked at Garden City Parking for 28/03/2026 (Slot B-05).',
        type: 'booking',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        payload: 'booking_completed',
      ),
    );

    // Sample parking started notification
    await _storageService.saveNotification(
      NotificationModel(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        title: 'Parking Started',
        body:
            'Your parking session is now active at Kampala Road Parking (Slot C-08).',
        type: 'parking',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        payload: 'parking_started',
      ),
    );

    // Sample expiry warning notification
    await _storageService.saveNotification(
      NotificationModel(
        id: (DateTime.now().millisecondsSinceEpoch + 3).toString(),
        title: 'Parking Expiring Soon',
        body: 'Your parking at Acacia Mall Parking expires in 15 minutes.',
        type: 'expiry',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        payload: 'parking_expiring',
      ),
    );
  }

  /// Send a test notification
  static Future<void> sendTestNotification() async {
    await _notificationService.showPaymentCompletedNotification(
      amount: 11500,
      parkingName: 'Test Parking',
    );
  }
}
