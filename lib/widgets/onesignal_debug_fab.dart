import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

/// Temporary debug FAB to quickly check OneSignal status
/// Add this to any screen during testing
class OneSignalDebugFAB extends StatelessWidget {
  const OneSignalDebugFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.orange,
      onPressed: () {
        final subscriptionId = OneSignal.User.pushSubscription.id;
        final permission = OneSignal.Notifications.permission;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('OneSignal Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Permission: ${permission ? "✅ Granted" : "❌ Denied"}'),
                const SizedBox(height: 8),
                Text(
                  'Subscription ID:\n${subscriptionId ?? "❌ Not available"}',
                ),
                const SizedBox(height: 16),
                if (subscriptionId != null)
                  const Text(
                    'Copy this ID and use it in OneSignal dashboard to send test notifications!',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              if (subscriptionId != null)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/onesignal-test');
                  },
                  child: const Text('Open Test Screen'),
                ),
            ],
          ),
        );
      },
      child: const Icon(Icons.notifications_active, size: 20),
    );
  }
}
