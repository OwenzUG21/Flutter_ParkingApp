import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../themes/colors.dart';

/// Example widget demonstrating SharedPreferences usage
class PreferencesExampleScreen extends StatefulWidget {
  const PreferencesExampleScreen({super.key});

  @override
  State<PreferencesExampleScreen> createState() =>
      _PreferencesExampleScreenState();
}

class _PreferencesExampleScreenState extends State<PreferencesExampleScreen> {
  PreferencesService? _prefsService;
  bool _isLoading = true;

  // Display values
  String? _username;
  String? _email;
  bool _isLoggedIn = false;
  String _themeMode = 'dark';
  String? _lastScreen;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Initialize SharedPreferences and load data
  Future<void> _initializePreferences() async {
    try {
      _prefsService = await PreferencesService.getInstance();
      _loadAllData();
    } catch (e) {
      _showMessage('Error initializing preferences: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Load all stored data
  void _loadAllData() {
    setState(() {
      _username = _prefsService!.getUsername();
      _email = _prefsService!.getUserEmail();
      _isLoggedIn = _prefsService!.isLoggedIn();
      _themeMode = _prefsService!.getThemeMode();
      _lastScreen = _prefsService!.getLastScreen();
    });
  }

  /// Save username
  Future<void> _saveUsername() async {
    if (_usernameController.text.trim().isEmpty) {
      _showMessage('Please enter a username', isError: true);
      return;
    }

    final success = await _prefsService!.saveUsername(
      _usernameController.text.trim(),
    );
    if (success) {
      _showMessage('Username saved successfully!');
      _loadAllData();
      _usernameController.clear();
    } else {
      _showMessage('Failed to save username', isError: true);
    }
  }

  /// Save email
  Future<void> _saveEmail() async {
    if (_emailController.text.trim().isEmpty) {
      _showMessage('Please enter an email', isError: true);
      return;
    }

    final success = await _prefsService!.saveUserEmail(
      _emailController.text.trim(),
    );
    if (success) {
      _showMessage('Email saved successfully!');
      _loadAllData();
      _emailController.clear();
    } else {
      _showMessage('Failed to save email', isError: true);
    }
  }

  /// Toggle login status
  Future<void> _toggleLoginStatus() async {
    final newStatus = !_isLoggedIn;
    final success = await _prefsService!.saveLoginStatus(newStatus);
    if (success) {
      _showMessage(
        'Login status updated to: ${newStatus ? "Logged In" : "Logged Out"}',
      );
      _loadAllData();
    } else {
      _showMessage('Failed to update login status', isError: true);
    }
  }

  /// Toggle theme mode
  Future<void> _toggleTheme() async {
    final newTheme = _themeMode == 'dark' ? 'light' : 'dark';
    final success = await _prefsService!.saveThemeMode(newTheme);
    if (success) {
      _showMessage('Theme changed to: $newTheme mode');
      _loadAllData();
    } else {
      _showMessage('Failed to change theme', isError: true);
    }
  }

  /// Save current screen as last screen
  Future<void> _saveLastScreen() async {
    final success = await _prefsService!.saveLastScreen('/preferences_example');
    if (success) {
      _showMessage('Last screen saved!');
      _loadAllData();
    } else {
      _showMessage('Failed to save last screen', isError: true);
    }
  }

  /// Clear all user data (simulate logout)
  Future<void> _clearUserData() async {
    final success = await _prefsService!.clearUserData();
    if (success) {
      _showMessage('User data cleared (logout)');
      _loadAllData();
    } else {
      _showMessage('Failed to clear user data', isError: true);
    }
  }

  /// Show message
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.redButton),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SharedPreferences Example'),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Stored Data Section
            _buildSectionTitle('Stored Data'),
            _buildDataCard(),
            const SizedBox(height: 24),

            // Save Username Section
            _buildSectionTitle('Save Username'),
            _buildInputField(
              controller: _usernameController,
              hint: 'Enter username',
              onSave: _saveUsername,
            ),
            const SizedBox(height: 24),

            // Save Email Section
            _buildSectionTitle('Save Email'),
            _buildInputField(
              controller: _emailController,
              hint: 'Enter email',
              onSave: _saveEmail,
            ),
            const SizedBox(height: 24),

            // Action Buttons
            _buildSectionTitle('Actions'),
            _buildActionButton(
              label: _isLoggedIn ? 'Logout' : 'Login',
              icon: _isLoggedIn ? Icons.logout : Icons.login,
              onPressed: _toggleLoginStatus,
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              label:
                  'Toggle Theme (${_themeMode == 'dark' ? 'Switch to Light' : 'Switch to Dark'})',
              icon: _themeMode == 'dark' ? Icons.light_mode : Icons.dark_mode,
              onPressed: _toggleTheme,
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              label: 'Save Last Screen',
              icon: Icons.save,
              onPressed: _saveLastScreen,
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              label: 'Clear User Data',
              icon: Icons.delete_forever,
              onPressed: _clearUserData,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDataCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDataRow('Username', _username ?? 'Not set'),
          _buildDataRow('Email', _email ?? 'Not set'),
          _buildDataRow(
            'Login Status',
            _isLoggedIn ? 'Logged In' : 'Logged Out',
          ),
          _buildDataRow('Theme Mode', _themeMode),
          _buildDataRow('Last Screen', _lastScreen ?? 'Not set', isLast: true),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 12),
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required VoidCallback onSave,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
              filled: true,
              fillColor: AppColors.cardBackground,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.redButton,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.redButton,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Save', style: TextStyle(fontSize: 15)),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive
              ? Colors.red.shade700
              : AppColors.cardBackground,
          foregroundColor: AppColors.primaryText,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            color: isDestructive
                ? Colors.red.shade900
                : Colors.white.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}
