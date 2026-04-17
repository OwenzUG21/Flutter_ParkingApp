import 'package:flutter/material.dart';
import 'lib/screens/admin_support_bot.dart';

/// Simple test widget to verify the support bot is working
class SupportBotTest extends StatefulWidget {
  const SupportBotTest({super.key});

  @override
  State<SupportBotTest> createState() => _SupportBotTestState();
}

class _SupportBotTestState extends State<SupportBotTest> {
  final TextEditingController _testController = TextEditingController();
  String _response = '';

  // Test queries to verify the bot is working
  final List<String> testQueries = [
    'hello',
    'how to book parking',
    'payment methods',
    'my payment failed',
    'find parking slots',
    'login problems',
    'app not working',
    'booking history',
    'help me',
  ];

  void _testQuery(String query) {
    setState(() {
      _response = ParkFlexSupportBot.getResponse(query);
    });
  }

  void _testCustomQuery() {
    final query = _testController.text.trim();
    if (query.isNotEmpty) {
      _testQuery(query);
      _testController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Bot Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _testController,
                    decoration: const InputDecoration(
                      hintText: 'Type your test message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _testCustomQuery(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _testCustomQuery,
                  child: const Text('Test'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Quick test buttons
            const Text(
              'Quick Tests:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: testQueries.map((query) {
                return ElevatedButton(
                  onPressed: () => _testQuery(query),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.blue.shade800,
                  ),
                  child: Text(query),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Response display
            const Text(
              'Bot Response:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _response.isEmpty
                        ? 'No response yet. Try a test query above.'
                        : _response,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Open full chat button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SupportBotWidget(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Open Full Chat Interface',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _testController.dispose();
    super.dispose();
  }
}

/// Quick function to test the bot from anywhere in your app
void testSupportBot() {
  print('🤖 Testing Support Bot...');

  final testCases = [
    'hello',
    'how to book parking',
    'payment failed',
    'find slots',
    'login help',
    'app problems',
  ];

  for (String testCase in testCases) {
    print('\n📝 Query: "$testCase"');
    final response = ParkFlexSupportBot.getResponse(testCase);
    print(
        '🤖 Response: ${response.substring(0, response.length > 100 ? 100 : response.length)}...');
  }
}
