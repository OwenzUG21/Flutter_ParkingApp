import 'package:shared_preferences/shared_preferences.dart';

/// Service class for managing SharedPreferences
/// Handles all simple key-value storage operations
class PreferencesService {
  static PreferencesService? _instance;
  static SharedPreferences? _preferences;

  // Private constructor for singleton pattern
  PreferencesService._();

  /// Get singleton instance
  static Future<PreferencesService> getInstance() async {
    _instance ??= PreferencesService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Keys for stored data
  static const String _keyUsername = 'username';
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyThemeMode = 'themeMode';
  static const String _keyLastScreen = 'lastScreen';
  static const String _keyUserEmail = 'userEmail';
  static const String _keyMtnNumber = 'mtnPaymentNumber';
  static const String _keyAirtelNumber = 'airtelPaymentNumber';
  static const String _keyMastercardNumber = 'mastercardNumber';

  // ==================== USERNAME ====================

  /// Save username
  Future<bool> saveUsername(String username) async {
    try {
      return await _preferences!.setString(_keyUsername, username);
    } catch (e) {
      print('Error saving username: $e');
      return false;
    }
  }

  /// Get username
  String? getUsername() {
    try {
      return _preferences!.getString(_keyUsername);
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }

  // ==================== EMAIL ====================

  /// Save user email
  Future<bool> saveUserEmail(String email) async {
    try {
      return await _preferences!.setString(_keyUserEmail, email);
    } catch (e) {
      print('Error saving email: $e');
      return false;
    }
  }

  /// Get user email
  String? getUserEmail() {
    try {
      return _preferences!.getString(_keyUserEmail);
    } catch (e) {
      print('Error getting email: $e');
      return null;
    }
  }

  // ==================== LOGIN STATUS ====================

  /// Save login status
  Future<bool> saveLoginStatus(bool isLoggedIn) async {
    try {
      return await _preferences!.setBool(_keyIsLoggedIn, isLoggedIn);
    } catch (e) {
      print('Error saving login status: $e');
      return false;
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    try {
      return _preferences!.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // ==================== THEME MODE ====================

  /// Save theme mode (dark or light)
  Future<bool> saveThemeMode(String themeMode) async {
    try {
      if (themeMode != 'dark' && themeMode != 'light') {
        print('Invalid theme mode: $themeMode. Use "dark" or "light"');
        return false;
      }
      return await _preferences!.setString(_keyThemeMode, themeMode);
    } catch (e) {
      print('Error saving theme mode: $e');
      return false;
    }
  }

  /// Get theme mode (returns 'dark' by default)
  String getThemeMode() {
    try {
      return _preferences!.getString(_keyThemeMode) ?? 'dark';
    } catch (e) {
      print('Error getting theme mode: $e');
      return 'dark';
    }
  }

  /// Check if dark mode is enabled
  bool isDarkMode() {
    return getThemeMode() == 'dark';
  }

  // ==================== LAST SCREEN ====================

  /// Save last opened screen
  Future<bool> saveLastScreen(String screenRoute) async {
    try {
      return await _preferences!.setString(_keyLastScreen, screenRoute);
    } catch (e) {
      print('Error saving last screen: $e');
      return false;
    }
  }

  /// Get last opened screen
  String? getLastScreen() {
    try {
      return _preferences!.getString(_keyLastScreen);
    } catch (e) {
      print('Error getting last screen: $e');
      return null;
    }
  }

  // ==================== UPDATE OPERATIONS ====================

  /// Update username
  Future<bool> updateUsername(String newUsername) async {
    return await saveUsername(newUsername);
  }

  /// Update theme mode
  Future<bool> updateThemeMode(String newThemeMode) async {
    return await saveThemeMode(newThemeMode);
  }

  // ==================== CLEAR DATA ====================

  /// Clear all user data (call on logout)
  Future<bool> clearUserData() async {
    try {
      await _preferences!.remove(_keyUsername);
      await _preferences!.remove(_keyUserEmail);
      await _preferences!.remove(_keyIsLoggedIn);
      await _preferences!.remove(_keyLastScreen);
      // Note: Theme mode is preserved across logout
      return true;
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }

  /// Clear all preferences (including theme)
  Future<bool> clearAll() async {
    try {
      return await _preferences!.clear();
    } catch (e) {
      print('Error clearing all preferences: $e');
      return false;
    }
  }

  // ==================== UTILITY ====================

  /// Check if preferences are initialized
  bool isInitialized() {
    return _preferences != null;
  }

  /// Get all stored keys (for debugging)
  Set<String> getAllKeys() {
    try {
      return _preferences!.getKeys();
    } catch (e) {
      print('Error getting all keys: $e');
      return {};
    }
  }

  // ==================== PAYMENT METHODS ====================

  /// Save MTN payment number
  Future<bool> saveMtnNumber(String phoneNumber) async {
    try {
      return await _preferences!.setString(_keyMtnNumber, phoneNumber);
    } catch (e) {
      print('Error saving MTN number: $e');
      return false;
    }
  }

  /// Get MTN payment number
  String? getMtnNumber() {
    try {
      return _preferences!.getString(_keyMtnNumber);
    } catch (e) {
      print('Error getting MTN number: $e');
      return null;
    }
  }

  /// Save Airtel payment number
  Future<bool> saveAirtelNumber(String phoneNumber) async {
    try {
      return await _preferences!.setString(_keyAirtelNumber, phoneNumber);
    } catch (e) {
      print('Error saving Airtel number: $e');
      return false;
    }
  }

  /// Get Airtel payment number
  String? getAirtelNumber() {
    try {
      return _preferences!.getString(_keyAirtelNumber);
    } catch (e) {
      print('Error getting Airtel number: $e');
      return null;
    }
  }

  /// Save Mastercard number
  Future<bool> saveMastercardNumber(String cardNumber) async {
    try {
      return await _preferences!.setString(_keyMastercardNumber, cardNumber);
    } catch (e) {
      print('Error saving Mastercard number: $e');
      return false;
    }
  }

  /// Get Mastercard number
  String? getMastercardNumber() {
    try {
      return _preferences!.getString(_keyMastercardNumber);
    } catch (e) {
      print('Error getting Mastercard number: $e');
      return null;
    }
  }
}
