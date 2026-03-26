import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'drift_service.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final DriftService _driftService = DriftService();
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> initialize() async {
    final settings = await _driftService.getSettings();
    if (settings != null) {
      _themeMode = settings.themeMode == 'dark'
          ? ThemeMode.dark
          : ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    await _driftService.saveSettings(
      AppSettingsTableCompanion(
        id: const Value(1),
        themeMode: Value(_themeMode == ThemeMode.dark ? 'dark' : 'light'),
      ),
    );

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    await _driftService.saveSettings(
      AppSettingsTableCompanion(
        id: const Value(1),
        themeMode: Value(mode == ThemeMode.dark ? 'dark' : 'light'),
      ),
    );

    notifyListeners();
  }
}
