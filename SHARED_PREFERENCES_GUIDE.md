# SharedPreferences Implementation Guide

## Overview
This Flutter app uses SharedPreferences for storing simple key-value data like user preferences, login status, and theme settings.

## Files Created

### 1. Service Class: `lib/services/preferences_service.dart`
A singleton service that handles all SharedPreferences operations with proper error handling.

### 2. Example Widget: `lib/examples/preferences_example.dart`
A complete demonstration screen showing all SharedPreferences features in action.

## Stored Data

The app stores the following data:

| Key | Type | Description | Default |
|-----|------|-------------|---------|
| `username` | String | User's display name | null |
| `userEmail` | String | User's email address | null |
| `isLoggedIn` | bool | Login status | false |
| `themeMode` | String | Theme mode ("dark" or "light") | "dark" |
| `lastScreen` | String | Last opened screen route | null |

## Usage Examples

### Initialize SharedPreferences

```dart
import 'package:project8/services/preferences_service.dart';

// In your StatefulWidget
PreferencesService? _prefsService;

@override
void initState() {
  super.initState();
  _initializePreferences();
}

Future<void> _initializePreferences() async {
  _prefsService = await PreferencesService.getInstance();
}
```

### Save Data

```dart
// Save username
await _prefsService!.saveUsername('John Doe');

// Save email
await _prefsService!.saveUserEmail('john@example.com');

// Save login status
await _prefsService!.saveLoginStatus(true);

// Save theme mode
await _prefsService!.saveThemeMode('dark'); // or 'light'

// Save last screen
await _prefsService!.saveLastScreen('/dashboard');
```

### Read Data

```dart
// Get username
String? username = _prefsService!.getUsername();

// Get email
String? email = _prefsService!.getUserEmail();

// Check login status
bool isLoggedIn = _prefsService!.isLoggedIn();

// Get theme mode
String themeMode = _prefsService!.getThemeMode(); // Returns 'dark' by default

// Check if dark mode
bool isDark = _prefsService!.isDarkMode();

// Get last screen
String? lastScreen = _prefsService!.getLastScreen();
```

### Update Data

```dart
// Update username
await _prefsService!.updateUsername('Jane Doe');

// Update theme mode
await _prefsService!.updateThemeMode('light');
```

### Clear Data

```dart
// Clear user data on logout (preserves theme)
await _prefsService!.clearUserData();

// Clear all preferences including theme
await _prefsService!.clearAll();
```

## Integration in Login Screen

The login screen (`lib/screens/login.dart`) has been updated to save user data after successful login:

```dart
Future<void> _signIn() async {
  // ... validation code ...

  try {
    final userCredential = await _authService.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // Save user data to SharedPreferences
    if (_prefsService != null && userCredential.user != null) {
      await _prefsService!.saveUsername(userCredential.user!.displayName ?? 'User');
      await _prefsService!.saveUserEmail(_emailController.text.trim());
      await _prefsService!.saveLoginStatus(true);
      await _prefsService!.saveLastScreen('/dashboard');
    }

    // Navigate to dashboard
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
    }
  } catch (e) {
    _showError(e.toString());
  }
}
```

## Logout Implementation

To implement logout with SharedPreferences:

```dart
Future<void> _logout() async {
  try {
    // Clear user data from SharedPreferences
    await _prefsService!.clearUserData();
    
    // Sign out from Firebase
    await _authService.signOut();
    
    // Navigate to login
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  } catch (e) {
    print('Error during logout: $e');
  }
}
```

## Check Login Status on App Start

```dart
Future<void> _checkLoginStatus() async {
  final prefsService = await PreferencesService.getInstance();
  
  if (prefsService.isLoggedIn()) {
    // User is logged in, navigate to dashboard
    String? lastScreen = prefsService.getLastScreen();
    Navigator.pushReplacementNamed(context, lastScreen ?? '/dashboard');
  } else {
    // User is not logged in, show login screen
    Navigator.pushReplacementNamed(context, '/login');
  }
}
```

## Theme Persistence Example

```dart
Future<void> _loadTheme() async {
  final prefsService = await PreferencesService.getInstance();
  String themeMode = prefsService.getThemeMode();
  
  setState(() {
    _isDarkMode = themeMode == 'dark';
  });
}

Future<void> _toggleTheme() async {
  final newTheme = _isDarkMode ? 'light' : 'dark';
  await _prefsService!.saveThemeMode(newTheme);
  
  setState(() {
    _isDarkMode = !_isDarkMode;
  });
}
```

## Testing the Implementation

Run the example screen to test all features:

```dart
import 'package:project8/examples/preferences_example.dart';

// Navigate to the example screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const PreferencesExampleScreen(),
  ),
);
```

## Error Handling

All methods include try-catch blocks and return:
- `bool` for save/update/clear operations (true = success, false = failure)
- `null` or default values for read operations on error

## Best Practices

1. **Initialize Once**: Get the singleton instance once and reuse it
2. **Check Mounted**: Always check `mounted` before using context after async operations
3. **Preserve Theme**: Use `clearUserData()` instead of `clearAll()` on logout to preserve theme
4. **Validate Input**: Validate theme mode values ("dark" or "light" only)
5. **Error Logging**: All errors are logged to console for debugging

## Installation

The `shared_preferences` package has been added to `pubspec.yaml`:

```yaml
dependencies:
  shared_preferences: ^2.2.2
```

Run to install:
```bash
flutter pub get
```

## Notes

- SharedPreferences is for small, simple data only
- For complex data structures, use Drift database (already configured in this project)
- Data persists across app restarts
- Data is stored locally on the device
- Not encrypted by default - don't store sensitive data like passwords
