import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../services/database_manager.dart';
import '../services/parking_service.dart';
import '../database/app_database.dart';

/// Example demonstrating how to use Drift database
class DatabaseUsageExample extends StatefulWidget {
  const DatabaseUsageExample({super.key});

  @override
  State<DatabaseUsageExample> createState() => _DatabaseUsageExampleState();
}

class _DatabaseUsageExampleState extends State<DatabaseUsageExample> {
  final _db = DatabaseManager();
  final _parkingService = ParkingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Usage Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Settings & Session Examples'),
          _buildButton('Save App Settings', _saveSettings),
          _buildButton('Get App Settings', _getSettings),
          _buildButton('Save User Session', _saveSession),
          _buildButton('Check Login Status', _checkLogin),
          _buildButton('Cache Data', _cacheExample),

          const SizedBox(height: 20),
          _buildSection('Parking Data Examples'),
          _buildButton('Vehicle Entry', _vehicleEntry),
          _buildButton('Vehicle Exit', _vehicleExit),
          _buildButton('Find Parked Vehicle', _findVehicle),
          _buildButton('Get Available Slots', _getAvailableSlots),
          _buildButton('Today\'s Revenue', _getTodayRevenue),
          _buildButton('Vehicle History', _getVehicleHistory),
          _buildButton('Initialize Slots', _initializeSlots),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }

  // ========== SETTINGS EXAMPLES ==========

  void _saveSettings() async {
    await _db.drift.saveSettings(
      AppSettingsTableCompanion.insert(
        themeMode: const Value('dark'),
        language: const Value('en'),
        notificationsEnabled: const Value(true),
        currency: const Value('UGX'),
        defaultParkingRate: const Value(5000.0),
      ),
    );
    _showMessage('Settings saved!');
  }

  void _getSettings() async {
    final settings = await _db.drift.getSettings();
    _showMessage(
      'Theme: ${settings?.themeMode ?? 'N/A'}\nCurrency: ${settings?.currency ?? 'N/A'}',
    );
  }

  void _saveSession() async {
    await _db.drift.saveSession(
      UserSessionsCompanion.insert(
        userId: 'user123',
        username: 'john_doe',
        role: 'attendant',
        email: const Value('john@example.com'),
        loginTime: DateTime.now(),
        rememberMe: const Value(true),
      ),
    );
    _showMessage('Session saved!');
  }

  void _checkLogin() async {
    final isLoggedIn = await _db.drift.isLoggedIn();
    final session = await _db.drift.getSession();
    _showMessage(
      isLoggedIn ? 'Logged in as: ${session?.username}' : 'Not logged in',
    );
  }

  void _cacheExample() async {
    // Cache data with 1 hour expiry
    await _db.drift.cacheData(
      'parking_rates',
      '{"regular": 5000, "vip": 10000}',
      expiry: const Duration(hours: 1),
    );

    final cached = await _db.drift.getCachedData('parking_rates');
    _showMessage('Cached data: $cached');
  }

  // ========== PARKING EXAMPLES ==========

  void _vehicleEntry() async {
    try {
      final record = await _parkingService.vehicleEntry(
        plateNumber: 'UAH123X',
        slotNumber: 'A001',
        vehicleType: 'car',
        attendantId: 'ATT001',
      );
      _showMessage(
        'Vehicle entered!\nSlot: ${record.parkingSlot}\nTime: ${record.entryTime}',
      );
    } catch (e) {
      _showMessage('Error: $e');
    }
  }

  void _vehicleExit() async {
    try {
      final transaction = await _parkingService.vehicleExit(
        plateNumber: 'UAH123X',
        paymentMethod: 'mobile_money',
        phoneNumber: '256700000000',
        attendantId: 'ATT001',
      );
      _showMessage(
        'Vehicle exited!\nFee: ${transaction.feePaid} UGX\nDuration: ${transaction.durationMinutes} min',
      );
    } catch (e) {
      _showMessage('Error: $e');
    }
  }

  void _findVehicle() async {
    final record = await _parkingService.findParkedVehicle('UAH123X');
    if (record != null) {
      _showMessage(
        'Found!\nSlot: ${record.parkingSlot}\nEntry: ${record.entryTime}',
      );
    } else {
      _showMessage('Vehicle not found');
    }
  }

  void _getAvailableSlots() async {
    final slots = await _parkingService.getAvailableSlots();
    _showMessage('Available slots: ${slots.length}');
  }

  void _getTodayRevenue() async {
    final revenue = await _parkingService.getTodayRevenue();
    _showMessage('Today\'s revenue: ${revenue.toStringAsFixed(0)} UGX');
  }

  void _getVehicleHistory() async {
    final history = await _parkingService.getVehicleHistory('UAH123X');
    _showMessage('Total activities: ${history.length}');
  }

  void _initializeSlots() async {
    await _parkingService.initializeParkingSlots(50);
    _showMessage('50 parking slots initialized!');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
