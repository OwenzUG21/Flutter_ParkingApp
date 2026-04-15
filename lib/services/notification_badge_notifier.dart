import 'package:flutter/foundation.dart';

/// Notifier to trigger badge refresh across the app
class NotificationBadgeNotifier extends ChangeNotifier {
  static final NotificationBadgeNotifier _instance =
      NotificationBadgeNotifier._internal();
  factory NotificationBadgeNotifier() => _instance;
  NotificationBadgeNotifier._internal();

  /// Call this to notify all listeners that the badge should refresh
  void notifyBadgeUpdate() {
    notifyListeners();
  }
}
