import 'package:flutter/material.dart';
import 'lib/screens/admin_support_bot.dart';
import 'support_bot_test.dart';

/// Example of how to integrate the support bot into your dashboard
/// Add this to your existing dashboard.dart file

class DashboardWithSupport extends StatelessWidget {
  const DashboardWithSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParkFlex Dashboard'),
        actions: [
          // Add support button to app bar
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showSupportOptions(context),
            tooltip: 'Help & Support',
          ),
        ],
      ),
      body: const Center(
        child: Text('Your dashboard content here'),
      ),

      // Floating support button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openSupportChat(context),
        backgroundColor: Colors.blue,
        tooltip: 'Get Help',
        child: const Icon(Icons.support_agent, color: Colors.white),
      ),
    );
  }

  void _showSupportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Quick help options
            _buildQuickHelpTile(
              context,
              Icons.local_parking,
              'How to Book Parking',
              'Step-by-step booking guide',
              () => _showQuickHelp(context, 'how to book parking'),
            ),

            _buildQuickHelpTile(
              context,
              Icons.payment,
              'Payment Help',
              'Payment methods and troubleshooting',
              () => _showQuickHelp(context, 'payment methods'),
            ),

            _buildQuickHelpTile(
              context,
              Icons.bug_report,
              'App Problems',
              'Troubleshoot common issues',
              () => _showQuickHelp(context, 'app problems'),
            ),

            const SizedBox(height: 10),

            // Full chat button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _openSupportChat(context);
                },
                icon: const Icon(Icons.chat),
                label: const Text('Chat with Support'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Test button (remove in production)
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SupportBotTest()),
                );
              },
              child: const Text('Test Bot (Debug)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHelpTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showQuickHelp(BuildContext context, String query) {
    Navigator.pop(context); // Close bottom sheet

    final response = ParkFlexSupportBot.getResponse(query);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Help'),
        content: SingleChildScrollView(
          child: Text(response),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openSupportChat(context);
            },
            child: const Text('More Help'),
          ),
        ],
      ),
    );
  }

  void _openSupportChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SupportBotWidget(),
      ),
    );
  }
}

/// Add this method to your existing dashboard.dart file
/// Call this from your drawer or settings menu
void addSupportToExistingDashboard(BuildContext context) {
  // Add this to your drawer or app bar actions
  IconButton(
    icon: const Icon(Icons.help_outline),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SupportBotWidget(),
        ),
      );
    },
  );
}

/// Quick test function - call this to verify the bot works
void quickTestBot() {
  print('🧪 Quick Bot Test:');

  // Test basic queries
  final queries = [
    'hello',
    'book parking',
    'payment help',
    'app problems',
  ];

  for (String query in queries) {
    final response = ParkFlexSupportBot.getResponse(query);
    print(
        '\n📝 "$query" → ${response.length > 50 ? '${response.substring(0, 50)}...' : response}');
  }
}
