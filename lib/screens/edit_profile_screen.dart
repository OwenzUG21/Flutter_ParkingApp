import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final _profileService = UserProfileService();

  File? _profileImage;
  File? _backgroundImage;
  bool _isLoading = false;
  String? _existingProfilePath;
  String? _existingBackgroundPath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = AuthService().currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';

      // Load profile data from database
      final username = user.email?.split('@')[0] ?? 'user';
      final profile = await _profileService.getUserProfile(username);

      if (profile != null && mounted) {
        setState(() {
          _nameController.text = profile.fullName ?? '';
          _emailController.text = profile.email ?? '';
          _phoneController.text = profile.phoneNumber ?? '';
          _existingProfilePath = profile.profileImagePath;
          _existingBackgroundPath = profile.backgroundImagePath;
        });

        // Load existing images
        if (profile.profileImagePath != null) {
          final file = await _profileService.getProfileImageFile(username);
          if (file != null && mounted) {
            setState(() => _profileImage = file);
          }
        }

        if (profile.backgroundImagePath != null) {
          final file = await _profileService.getBackgroundImageFile(username);
          if (file != null && mounted) {
            setState(() => _backgroundImage = file);
          }
        }
      }
    }
  }

  Future<void> _pickImage(ImageSource source, bool isProfile) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          if (isProfile) {
            _profileImage = File(image.path);
          } else {
            _backgroundImage = File(image.path);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(
          'Failed to pick image. Please check app permissions in settings.',
          isError: true,
        );
      }
    }
  }

  void _showImageSourceDialog(bool isProfile) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isProfile
                    ? 'Choose Profile Picture'
                    : 'Choose Background Image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.camera_alt, color: primaryColor),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, isProfile);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: primaryColor),
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, isProfile);
                },
              ),
              if ((isProfile && _profileImage != null) ||
                  (!isProfile && _backgroundImage != null))
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Remove Image',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      if (isProfile) {
                        _profileImage = null;
                      } else {
                        _backgroundImage = null;
                      }
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = AuthService().currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      final username = user.email?.split('@')[0] ?? 'user';

      // Save profile with file storage integration
      await _profileService.saveUserProfile(
        username: username,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        role: 'user',
        profileImage:
            _profileImage != null && _profileImage!.path != _existingProfilePath
            ? _profileImage
            : null,
        backgroundImage:
            _backgroundImage != null &&
                _backgroundImage!.path != _existingBackgroundPath
            ? _backgroundImage
            : null,
      );

      if (mounted) {
        _showSnackBar('Profile updated successfully!');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error updating profile: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: primaryColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  if (_isLoading)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primaryColor,
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Background and Profile Image Section
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Background Image
                        GestureDetector(
                          onTap: () => _showImageSourceDialog(false),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              gradient: _backgroundImage == null
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: isDark
                                          ? [
                                              const Color(0xFF00A884),
                                              const Color(0xFF008069),
                                            ]
                                          : [
                                              const Color(0xFF5B6B9E),
                                              const Color(0xFF6B7AB8),
                                            ],
                                    )
                                  : null,
                              image: _backgroundImage != null
                                  ? DecorationImage(
                                      image: FileImage(_backgroundImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: Stack(
                              children: [
                                // Edit Background Icon
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.5,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Profile Picture
                        Positioned(
                          bottom: -50,
                          left: MediaQuery.of(context).size.width / 2 - 60,
                          child: GestureDetector(
                            onTap: () => _showImageSourceDialog(true),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: surfaceColor,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: surfaceColor,
                                    backgroundImage: _profileImage != null
                                        ? FileImage(_profileImage!)
                                        : null,
                                    child: _profileImage == null
                                        ? Icon(
                                            Icons.person,
                                            size: 60,
                                            color: primaryColor,
                                          )
                                        : null,
                                  ),
                                ),
                                // Edit Profile Icon
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: surfaceColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: isDark
                                          ? Colors.black
                                          : Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 70),

                    // Form Section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Name Field
                            _buildTextField(
                              controller: _nameController,
                              label: 'Full Name',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Email Field
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Phone Field
                            _buildTextField(
                              controller: _phoneController,
                              label: 'Phone Number (Optional)',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),

                            const SizedBox(height: 32),

                            // Save Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: isDark
                                      ? Colors.black
                                      : Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _isLoading ? null : _saveProfile,
                                child: _isLoading
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: isDark
                                              ? Colors.black
                                              : Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Cancel Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primaryColor,
                                  side: BorderSide(color: primaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: surfaceColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
