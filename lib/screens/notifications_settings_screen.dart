import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;

  // Notification Categories
  bool _bookingReminders = true;
  bool _paymentAlerts = true;
  bool _promotionalOffers = false;
  bool _parkingExpiry = true;
  bool _systemUpdates = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'Notification Channels'),
          _buildNotificationCard(
            context,
            icon: Icons.notifications_active,
            title: 'Push Notifications',
            subtitle: 'Receive notifications on this device',
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
          ),
          _buildNotificationCard(
            context,
            icon: Icons.email,
            title: 'Email Notifications',
            subtitle: 'Receive updates via email',
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
          ),
          _buildNotificationCard(
            context,
            icon: Icons.sms,
            title: 'SMS Notifications',
            subtitle: 'Receive text messages',
            value: _smsNotifications,
            onChanged: (value) => setState(() => _smsNotifications = value),
          ),

          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Notification Types'),
          _buildNotificationCard(
            context,
            icon: Icons.calendar_today,
            title: 'Booking Reminders',
            subtitle: 'Reminders about upcoming reservations',
            value: _bookingReminders,
            onChanged: (value) => setState(() => _bookingReminders = value),
          ),
          _buildNotificationCard(
            context,
            icon: Icons.payment,
            title: 'Payment Alerts',
            subtitle: 'Transaction confirmations and receipts',
            value: _paymentAlerts,
            onChanged: (value) => setState(() => _paymentAlerts = value),
          ),
          _buildNotificationCard(
            context,
            icon: Icons.local_offer,
            title: 'Promotional Offers',
            subtitle: 'Deals and special offers',
            value: _promotionalOffers,
            onChanged: (value) => setState(() => _promotionalOffers = value),
          ),
          _buildNotificationCard(
            context,
            icon: Icons.timer,
            title: 'Parking Expiry Alerts',
            subtitle: 'Warnings before parking time expires',
            value: _parkingExpiry,
            onChanged: (value) => setState(() => _parkingExpiry = value),
          ),
          _buildNotificationCard(
            context,
            icon: Icons.system_update,
            title: 'System Updates',
            subtitle: 'App updates and maintenance notices',
            value: _systemUpdates,
            onChanged: (value) => setState(() => _systemUpdates = value),
          ),

          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification preferences saved!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Preferences',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
