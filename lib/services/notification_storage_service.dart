import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import 'notification_badge_notifier.dart';

class NotificationStorageService {
  static final NotificationStorageService _instance =
      NotificationStorageService._internal();
  factory NotificationStorageService() => _instance;
  NotificationStorageService._internal();

  static const String _notificationsKey = 'app_notifications';
  static const int _maxNotifications = 100;
  final NotificationBadgeNotifier _badgeNotifier = NotificationBadgeNotifier();

  /// Save a notification to storage
  Future<void> saveNotification(NotificationModel notification) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getAllNotifications();

    // Add new notification at the beginning
    notifications.insert(0, notification);

    // Keep only the latest notifications
    if (notifications.length > _maxNotifications) {
      notifications.removeRange(_maxNotifications, notifications.length);
    }

    final jsonList = notifications.map((n) => n.toJson()).toList();
    await prefs.setString(_notificationsKey, jsonEncode(jsonList));

    // Notify badge to refresh after saving new notification
    _badgeNotifier.notifyBadgeUpdate();
  }

  /// Get all notifications
  Future<List<NotificationModel>> getAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_notificationsKey);

    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
  }

  /// Get unread notifications count
  Future<int> getUnreadCount() async {
    final notifications = await getAllNotifications();
    return notifications.where((n) => !n.isRead).length;
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getAllNotifications();

    final updatedNotifications =
        notifications.map((n) => n.copyWith(isRead: true)).toList();

    final jsonList = updatedNotifications.map((n) => n.toJson()).toList();
    await prefs.setString(_notificationsKey, jsonEncode(jsonList));

    // Notify badge to refresh after marking all as read
    _badgeNotifier.notifyBadgeUpdate();
  }

  /// Mark a specific notification as read
  Future<void> markAsRead(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getAllNotifications();

    final updatedNotifications = notifications.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    final jsonList = updatedNotifications.map((n) => n.toJson()).toList();
    await prefs.setString(_notificationsKey, jsonEncode(jsonList));

    // Notify badge to refresh after marking as read
    _badgeNotifier.notifyBadgeUpdate();
  }

  /// Delete a notification
  Future<void> deleteNotification(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = await getAllNotifications();

    notifications.removeWhere((n) => n.id == id);

    final jsonList = notifications.map((n) => n.toJson()).toList();
    await prefs.setString(_notificationsKey, jsonEncode(jsonList));

    // Notify badge to refresh after deletion
    _badgeNotifier.notifyBadgeUpdate();
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);

    // Notify badge to refresh after clearing all
    _badgeNotifier.notifyBadgeUpdate();
  }
}
