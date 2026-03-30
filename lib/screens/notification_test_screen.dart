import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../services/notification_service.dart';

/// Test screen to manually trigger and test all notification types
/// Add this to your app routes to test notifications easily
class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  final _notificationService = NotificationService();
  String _statusMessage = 'Ready to test notifications';
  String _oneSignalStatus = 'Checking OneSignal...';

  @override
  void initState() {
    super.initState();
    _checkOneSignalStatus();
  }

  void _checkOneSignalStatus() {
    // Add observer to track OneSignal registration
    OneSignal.User.pushSubscription.addObserver((state) {
      final id = state.current.id;
      final token = state.current.token;
      final optedIn = state.current.optedIn;

      if (mounted) {
        setState(() {
          if (id != null) {
            _oneSignalStatus =
                '✅ Registered\nID: $id\nToken: ${token?.substring(0, 20)}...\nOpted In: $optedIn';
          } else {
            _oneSignalStatus = '❌ Not registered yet';
          }
        });
      }

      print('OneSignal Subscription State Changed:');
      print('  ID: $id');
      print('  Token: $token');
      print('  Opted In: $optedIn');
    });

    // Also check current status immediately
    final currentId = OneSignal.User.pushSubscription.id;
    final currentToken = OneSignal.User.pushSubscription.token;
    final currentOptedIn = OneSignal.User.pushSubscription.optedIn;

    setState(() {
      if (currentId != null) {
        _oneSignalStatus =
            '✅ Registered\nID: $currentId\nToken: ${currentToken?.substring(0, 20)}...\nOpted In: $currentOptedIn';
      } else {
        _oneSignalStatus = '❌ Not registered yet';
      }
    });
  }

  void _showStatus(String message) {
    setState(() {
      _statusMessage = message;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // OneSignal Status Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cloud_done, color: Colors.green.shade700),
                        const SizedBox(width: 12),
                        const Text(
                          'OneSignal Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _oneSignalStatus,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Status Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _statusMessage,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'OneSignal Setup',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),

              // Request Permission Button
              _buildTestButton(
                icon: Icons.notifications_active,
                label: 'Request OneSignal Permission',
                color: Colors.deepPurple,
                onPressed: () async {
                  _showStatus('Requesting permission...');
                  try {
                    final granted =
                        await OneSignal.Notifications.requestPermission(true);
                    _showStatus(
                      granted ? '✅ Permission granted!' : '❌ Permission denied',
                    );

                    // Refresh status after permission request
                    await Future.delayed(const Duration(seconds: 1));
                    _checkOneSignalStatus();
                  } catch (e) {
                    _showStatus('Error: $e');
                  }
                },
              ),

              const SizedBox(height: 12),

              // Check Current Status Button
              _buildTestButton(
                icon: Icons.refresh,
                label: 'Refresh OneSignal Status',
                color: Colors.cyan,
                onPressed: () {
                  _checkOneSignalStatus();
                  _showStatus('Status refreshed!');
                },
              ),

              const SizedBox(height: 24),

              const Text(
                'Immediate Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),

              // Payment Completed
              _buildTestButton(
                icon: Icons.payment,
                label: 'Payment Completed',
                color: Colors.green,
                onPressed: () async {
                  await _notificationService.showPaymentCompletedNotification(
                    amount: 15000.0,
                    parkingName: 'Test Parking Location',
                  );
                  _showStatus('Payment notification sent!');
                },
              ),

              const SizedBox(height: 12),

              // Parking Started
              _buildTestButton(
                icon: Icons.local_parking,
                label: 'Parking Started',
                color: Colors.blue,
                onPressed: () async {
                  await _notificationService.showParkingStartedNotification(
                    parkingName: 'Test Parking Location',
                    slotNumber: 'A-12',
                  );
                  _showStatus('Parking started notification sent!');
                },
              ),

              const SizedBox(height: 12),

              // Booking Completed
              _buildTestButton(
                icon: Icons.check_circle,
                label: 'Booking Completed',
                color: Colors.purple,
                onPressed: () async {
                  await _notificationService.showBookingCompletedNotification(
                    parkingName: 'Test Parking Location',
                    bookingDate: DateTime.now().add(const Duration(days: 1)),
                    slotNumber: 'B-05',
                  );
                  _showStatus('Booking completed notification sent!');
                },
              ),

              const SizedBox(height: 12),

              // Parking Expiring
              _buildTestButton(
                icon: Icons.warning,
                label: 'Parking Expiring Soon',
                color: Colors.orange,
                onPressed: () async {
                  await _notificationService
                      .showParkingExpiringSoonNotification(
                        parkingName: 'Test Parking Location',
                        minutesLeft: 15,
                      );
                  _showStatus('Expiring notification sent!');
                },
              ),

              const SizedBox(height: 24),

              const Text(
                'Scheduled Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),

              // Schedule in 10 seconds
              _buildTestButton(
                icon: Icons.schedule,
                label: 'Schedule in 10 Seconds',
                color: Colors.teal,
                onPressed: () async {
                  final scheduledTime = DateTime.now().add(
                    const Duration(seconds: 10),
                  );
                  await _notificationService.scheduleBookingActiveNotification(
                    parkingName: 'Test Parking Location',
                    scheduledTime: scheduledTime,
                    slotNumber: 'C-20',
                    notificationId: 9999,
                  );
                  _showStatus(
                    'Notification scheduled for 10 seconds from now!',
                  );
                },
              ),

              const SizedBox(height: 12),

              // Schedule in 1 minute
              _buildTestButton(
                icon: Icons.schedule,
                label: 'Schedule in 1 Minute',
                color: Colors.indigo,
                onPressed: () async {
                  final scheduledTime = DateTime.now().add(
                    const Duration(minutes: 1),
                  );
                  await _notificationService.scheduleBookingActiveNotification(
                    parkingName: 'Test Parking Location',
                    scheduledTime: scheduledTime,
                    slotNumber: 'D-15',
                    notificationId: 9998,
                  );
                  _showStatus('Notification scheduled for 1 minute from now!');
                },
              ),

              const SizedBox(height: 24),

              const Text(
                'Notification Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),

              // Check Pending
              _buildTestButton(
                icon: Icons.list,
                label: 'Check Pending Notifications',
                color: Colors.grey,
                onPressed: () async {
                  final pending = await _notificationService
                      .getPendingNotifications();
                  _showStatus('Pending notifications: ${pending.length}');

                  if (pending.isNotEmpty) {
                    // Show dialog with pending notifications
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Pending Notifications'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: pending.map((n) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(
                                  'ID: ${n.id} - ${n.title ?? "No title"}',
                                ),
                              );
                            }).toList(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),

              const SizedBox(height: 12),

              // Cancel All
              _buildTestButton(
                icon: Icons.clear_all,
                label: 'Cancel All Notifications',
                color: Colors.red,
                onPressed: () async {
                  await _notificationService.cancelAllNotifications();
                  _showStatus('All notifications cancelled!');
                },
              ),

              const SizedBox(height: 24),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Testing Tips',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Immediate notifications appear instantly\n'
                      '• Scheduled notifications appear at set time\n'
                      '• Check your notification bar at the top\n'
                      '• Ensure notifications are enabled in settings\n'
                      '• Test scheduled notifications with short delays',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
