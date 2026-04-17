import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/notification_storage_service.dart';
import '../services/notification_badge_notifier.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationStorageService _notificationService =
      NotificationStorageService();
  final NotificationBadgeNotifier _badgeNotifier = NotificationBadgeNotifier();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final notifications = await _notificationService.getAllNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading notifications: $e');
    }
  }

  Future<void> _deleteNotification(String id) async {
    await _notificationService.deleteNotification(id);
    _loadNotifications();
    // Notify badge to refresh after deletion
    _badgeNotifier.notifyBadgeUpdate();
  }

  Future<void> _clearAll() async {
    await _notificationService.clearAllNotifications();
    _loadNotifications();
    // Notify badge to refresh after clearing all
    _badgeNotifier.notifyBadgeUpdate();
  }

  Future<void> _markAllAsRead() async {
    await _notificationService.markAllAsRead();
    _loadNotifications();
    // Notify badge to refresh after marking all as read
    _badgeNotifier.notifyBadgeUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                if (value == 'mark_read') {
                  _markAllAsRead();
                } else if (value == 'clear_all') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('Clear All'),
                      content: const Text(
                        'Are you sure you want to clear all notifications?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _clearAll();
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'mark_read',
                  child: Row(
                    children: [
                      Icon(
                        Icons.done_all,
                        size: 20,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Mark all as read',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_sweep,
                        size: 20,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Clear all',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmptyState(theme)
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(
                          _notifications[index], theme);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    NotificationModel notification,
    ThemeData theme,
  ) {
    IconData icon;
    Color iconColor;

    switch (notification.type) {
      case 'payment':
        icon = Icons.payment;
        iconColor = Colors.green;
        break;
      case 'booking':
        icon = Icons.event_available;
        iconColor = Colors.blue;
        break;
      case 'parking':
        icon = Icons.local_parking;
        iconColor = Colors.orange;
        break;
      case 'expiry':
        icon = Icons.warning;
        iconColor = Colors.red;
        break;
      default:
        icon = Icons.notifications;
        iconColor = theme.colorScheme.primary;
    }

    // Define background colors for unread notifications
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color unreadBackgroundColor = isDarkMode
        ? const Color(0xFF1E3A5F) // Deep blue for dark mode
        : const Color(0xFFE3F2FD); // Light blue for light mode

    final Color readBackgroundColor = theme.colorScheme.surface;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _deleteNotification(notification.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color:
              notification.isRead ? readBackgroundColor : unreadBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: !notification.isRead
              ? Border.all(
                  color: isDarkMode
                      ? const Color(0xFF3D5A80)
                      : const Color(0xFF90CAF9),
                  width: 1.5,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          onTap: () async {
            // Mark notification as read when tapped
            if (!notification.isRead) {
              await _notificationService.markAsRead(notification.id);
              _loadNotifications();
              _badgeNotifier.notifyBadgeUpdate();
            }
          },
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  notification.isRead ? FontWeight.w600 : FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.body,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatTimestamp(notification.timestamp),
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          trailing: !notification.isRead
              ? Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFF1976D2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isDarkMode
                                ? const Color(0xFF64B5F6)
                                : const Color(0xFF1976D2))
                            .withValues(alpha: 0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                )
              : null,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }
}
