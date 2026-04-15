import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'notification_storage_service.dart';
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final NotificationStorageService _storageService =
      NotificationStorageService();

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone data
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize the plugin
    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    await _requestPermissions();

    _isInitialized = true;
  }

  /// Request notification permissions (mainly for iOS)
  Future<void> _requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Store the payload for navigation
    _lastNotificationPayload = response.payload;
  }

  String? _lastNotificationPayload;

  /// Get and clear the last notification payload
  String? getAndClearLastPayload() {
    final payload = _lastNotificationPayload;
    _lastNotificationPayload = null;
    return payload;
  }

  /// Show Payment Completed notification
  Future<void> showPaymentCompletedNotification({
    required double amount,
    String? parkingName,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'payment_channel',
      'Payment Notifications',
      channelDescription: 'Notifications for payment confirmations',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      showWhen: true,
      styleInformation: BigTextStyleInformation(''),
      visibility: NotificationVisibility.public,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = 'Payment Successful';
    final body =
        'Your parking payment of UGX ${amount.toStringAsFixed(0)} has been confirmed${parkingName != null ? ' for $parkingName' : ''}.';

    await _notifications.show(
      id: 1, // Notification ID
      title: title,
      body: body,
      notificationDetails: details,
      payload: 'payment_completed',
    );

    // Save to storage
    await _storageService.saveNotification(
      NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        type: 'payment',
        timestamp: DateTime.now(),
        payload: 'payment_completed',
      ),
    );
  }

  /// Show Parking Time Started notification
  Future<void> showParkingStartedNotification({
    required String parkingName,
    String? slotNumber,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'parking_channel',
      'Parking Notifications',
      channelDescription: 'Notifications for parking session updates',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      showWhen: true,
      styleInformation: BigTextStyleInformation(''),
      visibility: NotificationVisibility.public,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = 'Parking Started';
    final body =
        'Your parking session is now active at $parkingName${slotNumber != null ? ' (Slot $slotNumber)' : ''}.';

    await _notifications.show(
      id: 2, // Notification ID
      title: title,
      body: body,
      notificationDetails: details,
      payload: 'parking_started',
    );

    // Save to storage
    await _storageService.saveNotification(
      NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        type: 'parking',
        timestamp: DateTime.now(),
        payload: 'parking_started',
      ),
    );
  }

  /// Show Booking Completed notification
  Future<void> showBookingCompletedNotification({
    required String parkingName,
    required DateTime bookingDate,
    String? slotNumber,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'booking_channel',
      'Booking Notifications',
      channelDescription: 'Notifications for booking confirmations',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      showWhen: true,
      styleInformation: BigTextStyleInformation(''),
      visibility: NotificationVisibility.public,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final String dateStr =
        '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
    final title = 'Booking Confirmed';
    final body =
        'Your parking slot has been successfully booked at $parkingName for $dateStr${slotNumber != null ? ' (Slot $slotNumber)' : ''}.';

    await _notifications.show(
      id: 3, // Notification ID
      title: title,
      body: body,
      notificationDetails: details,
      payload: 'booking_completed',
    );

    // Save to storage
    await _storageService.saveNotification(
      NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        type: 'booking',
        timestamp: DateTime.now(),
        payload: 'booking_completed',
      ),
    );
  }

  /// Schedule Booked Time Now Active notification
  Future<void> scheduleBookingActiveNotification({
    required String parkingName,
    required DateTime scheduledTime,
    String? slotNumber,
    int? notificationId,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'booking_active_channel',
      'Active Booking Notifications',
      channelDescription:
          'Notifications when booked parking time becomes active',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      showWhen: true,
      styleInformation: BigTextStyleInformation(''),
      visibility: NotificationVisibility.public,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Convert DateTime to TZDateTime
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    await _notifications.zonedSchedule(
      id: notificationId ?? 4, // Notification ID
      title: 'Booking Active',
      body:
          'Your reserved parking time is now active at $parkingName${slotNumber != null ? ' (Slot $slotNumber)' : ''}.',
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'booking_active',
    );
  }

  /// Show Parking Expiring Soon notification
  Future<void> showParkingExpiringSoonNotification({
    required String parkingName,
    required int minutesLeft,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'parking_expiry_channel',
      'Parking Expiry Notifications',
      channelDescription: 'Notifications for parking time expiring soon',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      showWhen: true,
      styleInformation: BigTextStyleInformation(''),
      visibility: NotificationVisibility.public,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = 'Parking Expiring Soon';
    final body =
        'Your parking at $parkingName expires in $minutesLeft minutes.';

    await _notifications.show(
      id: 5, // Notification ID
      title: title,
      body: body,
      notificationDetails: details,
      payload: 'parking_expiring',
    );

    // Save to storage
    await _storageService.saveNotification(
      NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        type: 'expiry',
        timestamp: DateTime.now(),
        payload: 'parking_expiring',
      ),
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
