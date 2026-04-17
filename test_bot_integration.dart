import 'package:flutter/material.dart';
import 'lib/screens/admin_support_bot.dart';

/// Quick test to verify the bot is working
void main() {
  runApp(const BotTestApp());
}

class BotTestApp extends StatelessWidget {
  const BotTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bot Test',
      home: const BotTestScreen(),
    );
  }
}

class BotTestScreen extends StatefulWidget {
  const BotTestScreen({super.key});

  @override
  State<BotTestScreen> createState() => _BotTestScreenState();
}

class _BotTestScreenState extends State<BotTestScreen> {
  String _testResult = '';

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  void _runTests() {
    final testCases = [
      'hello',
      'how to book parking',
      'payment methods',
      'app is slow',
      'my payment failed',
      'find parking slots',
      'login problems',
      'booking history',
    ];

    String results = '🧪 Bot Test Results:\n\n';

    for (String testCase in testCases) {
      final response = ParkFlexSupportBot.getResponse(testCase);
      final isWorking = response.length > 100 &&
          !response.contains('ParkFlex Support Assistant');

      results += '📝 "$testCase"\n';
      results += '✅ ${isWorking ? 'WORKING' : 'DEFAULT RESPONSE'}\n';
      results +=
          '📄 ${response.substring(0, response.length > 80 ? 80 : response.length)}...\n\n';
    }

    setState(() {
      _testResult = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bot Integration Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
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
                    ),
                    child: const Text('Open Chat Bot'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _runTests,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Run Tests'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                    _testResult.isEmpty ? 'Running tests...' : _testResult,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick function to test individual responses
void quickTest() {
  print('🤖 Quick Bot Test:');

  final queries = [
    'hello',
    'book parking',
    'payment help',
    'app slow',
  ];

  for (String query in queries) {
    final response = ParkFlexSupportBot.getResponse(query);
    print(
        '\n"$query" → ${response.length > 50 ? '${response.substring(0, 50)}...' : response}');
  }
}
