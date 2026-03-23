import 'isar_service.dart';
import 'hive_service.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  final IsarService _isarService = IsarService();
  final HiveService _hiveService = HiveService();

  bool _isInitialized = false;

  // Initialize both databases
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Hive first (faster, for app settings)
      await _hiveService.init();

      // Initialize Isar (for structured data)
      await _isarService.init();

      _isInitialized = true;
      print('✅ Databases initialized successfully');
    } catch (e) {
      print('❌ Database initialization failed: $e');
      rethrow;
    }
  }

  // Getters for services
  IsarService get isar => _isarService;
  HiveService get hive => _hiveService;

  // Check if initialized
  bool get isInitialized => _isInitialized;

  // Close all databases
  Future<void> close() async {
    await _isarService.close();
    await _hiveService.close();
    _isInitialized = false;
  }

  // Clear all data (use with caution!)
  Future<void> clearAllData() async {
    await _isarService.clearAllData();
    await _hiveService.clearAllData();
  }
}
