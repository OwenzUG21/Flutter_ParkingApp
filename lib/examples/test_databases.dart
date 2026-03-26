import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import '../services/database_manager.dart';
import '../services/parking_service.dart';
import '../database/app_database.dart';

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
            _buildTestButton('Test Settings', _testSettings),
            _buildTestButton('Test Parking', _testParking),
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

  void _testSettings() async {
    try {
      setState(() => _output = 'Testing Settings...\n');

      // Test settings
      await _db.drift.saveSettings(
        AppSettingsTableCompanion.insert(
          themeMode: const Value('dark'),
          currency: const Value('UGX'),
          defaultParkingRate: const Value(5000.0),
        ),
      );
      final saved = await _db.drift.getSettings();

      // Test session
      await _db.drift.saveSession(
        UserSessionsCompanion.insert(
          userId: 'test123',
          username: 'test_user',
          role: 'attendant',
          loginTime: DateTime.now(),
        ),
      );
      final isLoggedIn = await _db.drift.isLoggedIn();

      // Test cache
      await _db.drift.cacheData('test_key', 'test_value');
      final cached = await _db.drift.getCachedData('test_key');

      setState(() {
        _output =
            '''
✅ Settings Test Passed!

Settings:
- Theme: ${saved?.themeMode ?? 'N/A'}
- Currency: ${saved?.currency ?? 'N/A'}
- Rate: ${saved?.defaultParkingRate ?? 'N/A'}

Session:
- Logged in: $isLoggedIn

Cache:
- Cached value: $cached
''';
      });
    } catch (e) {
      setState(() => _output = '❌ Settings Test Failed:\n$e');
    }
  }

  void _testParking() async {
    try {
      setState(() => _output = 'Testing Parking...\n');

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
✅ Parking Test Passed!

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
      setState(() => _output = '❌ Parking Test Failed:\n$e');
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
