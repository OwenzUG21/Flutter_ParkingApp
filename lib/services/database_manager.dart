import 'drift_service.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  final DriftService _driftService = DriftService();

  bool _isInitialized = false;

  // Initialize database
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _driftService.init();
      _isInitialized = true;
      print('✅ Database initialized successfully');
    } catch (e) {
      print('❌ Database initialization failed: $e');
      rethrow;
    }
  }

  // Getter for service
  DriftService get drift => _driftService;

  // Check if initialized
  bool get isInitialized => _isInitialized;

  // Close database
  Future<void> close() async {
    await _driftService.close();
    _isInitialized = false;
  }

  // Clear all data (use with caution!)
  Future<void> clearAllData() async {
    await _driftService.clearAllData();
  }
}
