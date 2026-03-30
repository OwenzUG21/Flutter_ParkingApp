import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../services/onesignal_service.dart';
import '../services/onesignal_diagnostic.dart';
import '../themes/colors.dart';

class OneSignalTestScreen extends StatefulWidget {
  const OneSignalTestScreen({super.key});

  @override
  State<OneSignalTestScreen> createState() => _OneSignalTestScreenState();
}

class _OneSignalTestScreenState extends State<OneSignalTestScreen> {
  String _subscriptionId = 'Loading...';
  String _token = 'Loading...';
  bool _permissionGranted = false;
  bool _optedIn = false;
  String _status = 'Checking...';

  @override
  void initState() {
    super.initState();
    _loadOneSignalInfo();
  }

  Future<void> _loadOneSignalInfo() async {
    try {
      // Wait a bit for OneSignal to be ready
      await Future.delayed(const Duration(milliseconds: 500));

      final subscriptionId = OneSignal.User.pushSubscription.id;
      final token = OneSignal.User.pushSubscription.token;
      final permission = OneSignal.Notifications.permission;
      final optedIn = OneSignal.User.pushSubscription.optedIn;

      setState(() {
        _subscriptionId = subscriptionId ?? 'Not available';
        _token = token ?? 'Not available';
        _permissionGranted = permission;
        _optedIn = optedIn ?? false;

        if (!permission) {
          _status = '❌ Permission Denied';
        } else if (subscriptionId == null) {
          _status = '⚠️ Not Subscribed';
        } else {
          _status = '✅ Ready to Receive';
        }
      });

      print('📊 Test Screen - Current Status:');
      print('   Permission: $permission');
      print('   Subscription ID: $subscriptionId');
      print('   Token: $token');
      print('   Opted In: $optedIn');
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
      });
      print('❌ Error loading OneSignal info: $e');
    }
  }

  Future<void> _requestPermission() async {
    print('🔔 User tapped Request Permission button');

    final granted = await OneSignalService().promptForPushNotifications();

    // Wait for subscription to be created
    await Future.delayed(const Duration(seconds: 2));
    await _loadOneSignalInfo();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            granted
                ? 'Permission granted! Check if Subscription ID appears above.'
                : 'Permission denied. Please enable notifications in device settings.',
          ),
          backgroundColor: granted ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text('OneSignal Debug'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOneSignalInfo,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _permissionGranted
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _permissionGranted
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.orange.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _status,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        _permissionGranted ? Icons.check_circle : Icons.cancel,
                        color: _permissionGranted
                            ? Colors.green
                            : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Permission: ${_permissionGranted ? "Granted" : "Denied"}',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _optedIn ? Icons.check_circle : Icons.cancel,
                        color: _optedIn ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Opted In: ${_optedIn ? "Yes" : "No"}',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Subscription ID
            _buildInfoCard(
              title: 'Subscription ID',
              value: _subscriptionId,
              subtitle: 'Use this to send test notifications',
              onCopy:
                  _subscriptionId != 'Not available' &&
                      _subscriptionId != 'Loading...'
                  ? () => _copyToClipboard(_subscriptionId)
                  : null,
              theme: theme,
            ),

            const SizedBox(height: 16),

            // Push Token
            _buildInfoCard(
              title: 'Push Token',
              value: _token,
              subtitle: 'Device push notification token',
              onCopy: _token != 'Not available' && _token != 'Loading...'
                  ? () => _copyToClipboard(_token)
                  : null,
              theme: theme,
            ),

            const SizedBox(height: 16),

            // App ID
            _buildInfoCard(
              title: 'OneSignal App ID',
              value: OneSignalService.appId,
              subtitle: 'Your OneSignal application ID',
              onCopy: () => _copyToClipboard(OneSignalService.appId),
              theme: theme,
            ),

            const SizedBox(height: 32),

            // Action Buttons
            if (!_permissionGranted) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _requestPermission,
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('Request Permission'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redButton,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Enable Notifications'),
                        content: const Text(
                          'Please enable notifications in your device settings:\n\n'
                          '1. Go to Settings\n'
                          '2. Apps > ParkFlex\n'
                          '3. Notifications\n'
                          '4. Enable all notifications\n'
                          '5. Come back and tap Refresh',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('How to Enable in Settings'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loadOneSignalInfo,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Status'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.surface,
                  foregroundColor: theme.colorScheme.onSurface,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  print('\n🔍 Running diagnostics from test screen...\n');
                  await OneSignalDiagnostic.runDiagnostics();
                  await _loadOneSignalInfo();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Diagnostics complete! Check console logs.',
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.bug_report),
                label: const Text('Run Diagnostics'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'How to Fix Permission Denied',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '1. Tap "Request Permission" above\n'
                    '2. If dialog appears, tap "Allow"\n'
                    '3. If no dialog, go to device Settings\n'
                    '4. Find Apps > ParkFlex > Notifications\n'
                    '5. Enable "Show notifications"\n'
                    '6. Come back and tap "Refresh Status"\n'
                    '7. Subscription ID should appear',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Testing Instructions
            if (_subscriptionId != 'Not available' &&
                _subscriptionId != 'Loading...') ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.send, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Send Test Notification',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '1. Go to OneSignal Dashboard\n'
                      '2. Messages > New Push\n'
                      '3. Enter title and message\n'
                      '4. Select "Send to Test Users"\n'
                      '5. Paste your Subscription ID\n'
                      '6. Click "Send to Test Users"',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required String subtitle,
    required ThemeData theme,
    VoidCallback? onCopy,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (onCopy != null)
                IconButton(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy, size: 16),
                  color: AppColors.redButton,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Copy',
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
