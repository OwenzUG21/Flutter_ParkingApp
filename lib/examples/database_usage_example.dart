import 'package:flutter/material.dart';
import '../services/database_manager.dart';
import '../services/parking_service.dart';
import '../models/hive/app_settings.dart';
import '../models/hive/user_session.dart';

/// Example demonstrating how to use Isar and Hive databases
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
          _buildSection('Hive Examples (Settings & Session)'),
          _buildButton('Save App Settings', _saveSettings),
          _buildButton('Get App Settings', _getSettings),
          _buildButton('Save User Session', _saveSession),
          _buildButton('Check Login Status', _checkLogin),
          _buildButton('Cache Data', _cacheExample),

          const SizedBox(height: 20),
          _buildSection('Isar Examples (Parking Data)'),
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

  // ========== HIVE EXAMPLES ==========

  void _saveSettings() {
    final settings = AppSettings(
      themeMode: 'dark',
      language: 'en',
      notificationsEnabled: true,
      currency: 'UGX',
      defaultParkingRate: 5000.0,
    );
    _db.hive.saveSettings(settings);
    _showMessage('Settings saved!');
  }

  void _getSettings() {
    final settings = _db.hive.getSettings();
    _showMessage(
      'Theme: ${settings.themeMode}\nCurrency: ${settings.currency}',
    );
  }

  void _saveSession() {
    final session = UserSession(
      userId: 'user123',
      username: 'john_doe',
      role: 'attendant',
      email: 'john@example.com',
      loginTime: DateTime.now(),
      rememberMe: true,
    );
    _db.hive.saveSession(session);
    _showMessage('Session saved!');
  }

  void _checkLogin() {
    final isLoggedIn = _db.hive.isLoggedIn();
    final session = _db.hive.getSession();
    _showMessage(
      isLoggedIn ? 'Logged in as: ${session?.username}' : 'Not logged in',
    );
  }

  void _cacheExample() async {
    // Cache data with 1 hour expiry
    await _db.hive.cacheData(
      'parking_rates',
      '{"regular": 5000, "vip": 10000}',
      expiry: const Duration(hours: 1),
    );

    final cached = _db.hive.getCachedData('parking_rates');
    _showMessage('Cached data: $cached');
  }

  // ========== ISAR EXAMPLES ==========

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
