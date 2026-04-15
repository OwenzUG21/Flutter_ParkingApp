import 'package:flutter/material.dart';
import '../services/notification_storage_service.dart';
import '../services/notification_badge_notifier.dart';

class NotificationBadge extends StatefulWidget {
  final VoidCallback onTap;

  const NotificationBadge({super.key, required this.onTap});

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  final NotificationStorageService _notificationService =
      NotificationStorageService();
  final NotificationBadgeNotifier _badgeNotifier = NotificationBadgeNotifier();
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
    // Listen for badge update notifications
    _badgeNotifier.addListener(_loadUnreadCount);
  }

  @override
  void dispose() {
    _badgeNotifier.removeListener(_loadUnreadCount);
    super.dispose();
  }

  @override
  void didUpdateWidget(NotificationBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh count when widget rebuilds
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    final count = await _notificationService.getUnreadCount();
    if (mounted) {
      setState(() {
        _unreadCount = count;
      });
    }
  }

  // Call this method to refresh the badge count
  void refresh() {
    _loadUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_outlined,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          if (_unreadCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Center(
                  child: Text(
                    _unreadCount > 99 ? '99+' : _unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
