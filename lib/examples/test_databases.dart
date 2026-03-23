import 'package:flutter/material.dart';
import '../services/database_manager.dart';
import '../services/parking_service.dart';
import '../models/hive/app_settings.dart';
import '../models/hive/user_session.dart';

/// Simple test screen to verify database setup
class TestDatabasesScreen extends StatefulWidget {
  const TestDatabasesScreen({super.key});

  @override
  State<TestDatabasesScreen> createState() => _TestDatabasesScreenState();
}

class _TestDatabasesScreenState extends State<TestDatabasesScreen> {
  final _db = DatabaseManager();
  final _parkingService = ParkingService();
  String _output = 'Ready to test databases...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Database Test'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _output,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTestButton('Test Hive (Settings)', _testHive),
            _buildTestButton('Test Isar (Parking)', _testIsar),
            _buildTestButton('Full Integration Test', _fullTest),
            _buildTestButton('Clear All Data', _clearData),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.all(16),
        ),
        child: Text(label),
      ),
    );
  }

  void _testHive() async {
    try {
      setState(() => _output = 'Testing Hive...\n');

      // Test settings
      final settings = AppSettings(
        themeMode: 'dark',
        currency: 'UGX',
        defaultParkingRate: 5000.0,
      );
      await _db.hive.saveSettings(settings);
      final saved = _db.hive.getSettings();

      // Test session
      final session = UserSession(
        userId: 'test123',
        username: 'test_user',
        role: 'attendant',
        loginTime: DateTime.now(),
      );
      await _db.hive.saveSession(session);
      final isLoggedIn = _db.hive.isLoggedIn();

      // Test cache
      await _db.hive.cacheData('test_key', 'test_value');
      final cached = _db.hive.getCachedData('test_key');

      setState(() {
        _output =
            '''
✅ Hive Test Passed!

Settings:
- Theme: ${saved.themeMode}
- Currency: ${saved.currency}
- Rate: ${saved.defaultParkingRate}

Session:
- Logged in: $isLoggedIn
- Username: ${session.username}

Cache:
- Cached value: $cached
''';
      });
    } catch (e) {
      setState(() => _output = '❌ Hive Test Failed:\n$e');
    }
  }

  void _testIsar() async {
    try {
      setState(() => _output = 'Testing Isar...\n');

      // Initialize some slots
      await _parkingService.initializeParkingSlots(10);

      // Test vehicle entry
      final record = await _parkingService.vehicleEntry(
        plateNumber: 'TEST123',
        slotNumber: 'A001',
        vehicleType: 'car',
        attendantId: 'ATT001',
      );

      // Check available slots
      final availableSlots = await _parkingService.getAvailableSlots();

      // Find the vehicle
      final found = await _parkingService.findParkedVehicle('TEST123');

      setState(() {
        _output =
            '''
✅ Isar Test Passed!

Vehicle Entry:
- Plate: ${record.plateNumber}
- Slot: ${record.parkingSlot}
- Entry: ${record.entryTime.toString().substring(0, 19)}

Parking Status:
- Available slots: ${availableSlots.length}
- Vehicle found: ${found != null}
''';
      });
    } catch (e) {
      setState(() => _output = '❌ Isar Test Failed:\n$e');
    }
  }

  void _fullTest() async {
    try {
      setState(() => _output = 'Running full integration test...\n');

      // 1. Setup
      await _parkingService.initializeParkingSlots(5);

      // 2. Vehicle entry
      final entry = await _parkingService.vehicleEntry(
        plateNumber: 'UAH456X',
        slotNumber: 'A002',
        vehicleType: 'car',
        attendantId: 'ATT001',
      );

      // Wait 2 seconds to simulate parking duration
      await Future.delayed(const Duration(seconds: 2));

      // 3. Vehicle exit
      final transaction = await _parkingService.vehicleExit(
        plateNumber: 'UAH456X',
        paymentMethod: 'mobile_money',
        phoneNumber: '256700000000',
        attendantId: 'ATT001',
      );

      // 4. Get revenue
      final revenue = await _parkingService.getTodayRevenue();

      // 5. Get history
      final history = await _parkingService.getVehicleHistory('UAH456X');

      setState(() {
        _output =
            '''
✅ Full Integration Test Passed!

Entry:
- Plate: ${entry.plateNumber}
- Slot: ${entry.parkingSlot}
- Time: ${entry.entryTime.toString().substring(11, 19)}

Exit:
- Duration: ${transaction.durationMinutes} minutes
- Fee: ${transaction.feePaid} UGX
- Method: ${transaction.paymentMethod}

Summary:
- Today's revenue: $revenue UGX
- Vehicle activities: ${history.length}
''';
      });
    } catch (e) {
      setState(() => _output = '❌ Full Test Failed:\n$e');
    }
  }

  void _clearData() async {
    try {
      await _db.clearAllData();
      setState(() => _output = '✅ All data cleared successfully!');
    } catch (e) {
      setState(() => _output = '❌ Clear failed:\n$e');
    }
  }
}
