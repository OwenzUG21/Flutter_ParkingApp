import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive/app_settings.dart';
import '../models/hive/user_session.dart';
import '../models/hive/cache_data.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  static const String settingsBox = 'settings';
  static const String sessionBox = 'session';
  static const String cacheBox = 'cache';

  // Initialize Hive
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserSessionAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(CacheDataAdapter());
    }

    // Open boxes
    await Hive.openBox<AppSettings>(settingsBox);
    await Hive.openBox<UserSession>(sessionBox);
    await Hive.openBox<CacheData>(cacheBox);
  }

  // ========== APP SETTINGS ==========

  Future<void> saveSettings(AppSettings settings) async {
    final box = Hive.box<AppSettings>(settingsBox);
    await box.put('app_settings', settings);
  }

  AppSettings getSettings() {
    final box = Hive.box<AppSettings>(settingsBox);
    return box.get('app_settings', defaultValue: AppSettings())!;
  }

  Future<void> updateTheme(String theme) async {
    final settings = getSettings();
    settings.themeMode = theme;
    await saveSettings(settings);
  }

  Future<void> updateLanguage(String language) async {
    final settings = getSettings();
    settings.language = language;
    await saveSettings(settings);
  }

  Future<void> toggleNotifications(bool enabled) async {
    final settings = getSettings();
    settings.notificationsEnabled = enabled;
    await saveSettings(settings);
  }

  // ========== USER SESSION ==========

  Future<void> saveSession(UserSession session) async {
    final box = Hive.box<UserSession>(sessionBox);
    await box.put('current_session', session);
  }

  UserSession? getSession() {
    final box = Hive.box<UserSession>(sessionBox);
    return box.get('current_session');
  }

  Future<void> clearSession() async {
    final box = Hive.box<UserSession>(sessionBox);
    await box.delete('current_session');
  }

  bool isLoggedIn() {
    return getSession() != null;
  }

  // ========== CACHE ==========

  Future<void> cacheData(String key, String value, {Duration? expiry}) async {
    final box = Hive.box<CacheData>(cacheBox);
    final cacheData = CacheData(
      key: key,
      value: value,
      cachedAt: DateTime.now(),
      expiresAt: expiry != null ? DateTime.now().add(expiry) : null,
    );
    await box.put(key, cacheData);
  }

  String? getCachedData(String key) {
    final box = Hive.box<CacheData>(cacheBox);
    final cache = box.get(key);

    if (cache == null) return null;
    if (cache.isExpired) {
      box.delete(key);
      return null;
    }

    return cache.value;
  }

  Future<void> clearCache() async {
    final box = Hive.box<CacheData>(cacheBox);
    await box.clear();
  }

  Future<void> clearExpiredCache() async {
    final box = Hive.box<CacheData>(cacheBox);
    final expiredKeys = box.values
        .where((cache) => cache.isExpired)
        .map((cache) => cache.key)
        .toList();

    for (final key in expiredKeys) {
      await box.delete(key);
    }
  }

  // ========== UTILITY ==========

  Future<void> clearAllData() async {
    await Hive.box<AppSettings>(settingsBox).clear();
    await Hive.box<UserSession>(sessionBox).clear();
    await Hive.box<CacheData>(cacheBox).clear();
  }

  Future<void> close() async {
    await Hive.close();
  }
}
