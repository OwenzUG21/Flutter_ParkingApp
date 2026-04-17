import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  Locale _locale = const Locale('en');
  static const String _languageKey = 'selected_language';

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;

  String get languageName {
    switch (_locale.languageCode) {
      case 'en':
        return 'English';
      case 'sw':
        return 'Swahili';
      case 'fr':
        return 'French';
      case 'es':
        return 'Spanish';
      case 'ar':
        return 'Arabic';
      case 'zh':
        return 'Chinese';
      case 'de':
        return 'German';
      default:
        return 'English';
    }
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  Future<void> setLanguage(String languageCode) async {
    if (_locale.languageCode == languageCode) return;

    _locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }

  // Supported languages (without Luganda)
  static const List<Map<String, String>> supportedLanguages = [
    {'name': 'English', 'native': 'English', 'code': 'en'},
    {'name': 'Swahili', 'native': 'Kiswahili', 'code': 'sw'},
    {'name': 'French', 'native': 'Français', 'code': 'fr'},
    {'name': 'Spanish', 'native': 'Español', 'code': 'es'},
    {'name': 'Arabic', 'native': 'العربية', 'code': 'ar'},
    {'name': 'Chinese', 'native': '中文', 'code': 'zh'},
    {'name': 'German', 'native': 'Deutsch', 'code': 'de'},
  ];
}
