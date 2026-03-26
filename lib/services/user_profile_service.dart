import 'dart:io';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'file_storage_service.dart';
import 'drift_service.dart';

/// Service for managing user profiles with file storage integration
/// Combines Drift database for structured data and file storage for images
class UserProfileService {
  static final UserProfileService _instance = UserProfileService._internal();
  factory UserProfileService() => _instance;
  UserProfileService._internal();

  final _fileStorage = FileStorageService();
  final _driftService = DriftService();

  // ========== PROFILE MANAGEMENT ==========

  /// Get user profile by username
  Future<UserDataTableData?> getUserProfile(String username) async {
    return await _driftService.getUserByUsername(username);
  }

  /// Create or update user profile
  Future<UserDataTableData> saveUserProfile({
    required String username,
    required String fullName,
    required String email,
    String? phoneNumber,
    String role = 'user',
    File? profileImage,
    File? backgroundImage,
  }) async {
    // Get existing user
    final existingUser = await _driftService.getUserByUsername(username);

    String? profileImagePath;
    String? backgroundImagePath;

    // Handle profile image
    if (profileImage != null) {
      // Delete old profile image if exists
      if (existingUser?.profileImagePath != null) {
        await _fileStorage.deleteProfileImage(existingUser!.profileImagePath!);
      }
      // Save new profile image
      profileImagePath = await _fileStorage.saveProfileImage(
        profileImage,
        username,
      );
    } else {
      // Keep existing path
      profileImagePath = existingUser?.profileImagePath;
    }

    // Handle background image
    if (backgroundImage != null) {
      // Delete old background image if exists
      if (existingUser?.backgroundImagePath != null) {
        await _fileStorage.deleteBackgroundImage(
          existingUser!.backgroundImagePath!,
        );
      }
      // Save new background image
      backgroundImagePath = await _fileStorage.saveBackgroundImage(
        backgroundImage,
        username,
      );
    } else {
      // Keep existing path
      backgroundImagePath = existingUser?.backgroundImagePath;
    }

    if (existingUser == null) {
      // Create new user
      await _driftService.addUser(
        UserDataTableCompanion.insert(
          username: username,
          role: role,
          fullName: Value(fullName),
          email: Value(email),
          phoneNumber: Value(phoneNumber),
          createdAt: DateTime.now(),
          profileImagePath: Value(profileImagePath),
          backgroundImagePath: Value(backgroundImagePath),
        ),
      );
      return (await _driftService.getUserByUsername(username))!;
    } else {
      // Update existing user
      await _driftService.updateUser(
        UserDataTableCompanion(
          id: Value(existingUser.id),
          fullName: Value(fullName),
          email: Value(email),
          phoneNumber: Value(phoneNumber),
          profileImagePath: Value(profileImagePath),
          backgroundImagePath: Value(backgroundImagePath),
          lastLogin: Value(DateTime.now()),
        ),
      );
      return (await _driftService.getUserByUsername(username))!;
    }
  }

  /// Update only profile image
  Future<void> updateProfileImage(String username, File imageFile) async {
    final user = await _driftService.getUserByUsername(username);
    if (user == null) {
      throw Exception('User not found');
    }

    // Delete old image
    if (user.profileImagePath != null) {
      await _fileStorage.deleteProfileImage(user.profileImagePath!);
    }

    // Save new image
    final imagePath = await _fileStorage.saveProfileImage(imageFile, username);

    // Update database
    await _driftService.updateUser(
      UserDataTableCompanion(
        id: Value(user.id),
        profileImagePath: Value(imagePath),
      ),
    );
  }

  /// Update only background image
  Future<void> updateBackgroundImage(String username, File imageFile) async {
    final user = await _driftService.getUserByUsername(username);
    if (user == null) {
      throw Exception('User not found');
    }

    // Delete old image
    if (user.backgroundImagePath != null) {
      await _fileStorage.deleteBackgroundImage(user.backgroundImagePath!);
    }

    // Save new image
    final imagePath = await _fileStorage.saveBackgroundImage(
      imageFile,
      username,
    );

    // Update database
    await _driftService.updateUser(
      UserDataTableCompanion(
        id: Value(user.id),
        backgroundImagePath: Value(imagePath),
      ),
    );
  }

  /// Remove profile image
  Future<void> removeProfileImage(String username) async {
    final user = await _driftService.getUserByUsername(username);
    if (user == null) return;

    // Delete image file
    if (user.profileImagePath != null) {
      await _fileStorage.deleteProfileImage(user.profileImagePath!);
    }

    // Update database
    await _driftService.updateUser(
      UserDataTableCompanion(
        id: Value(user.id),
        profileImagePath: const Value(null),
      ),
    );
  }

  /// Remove background image
  Future<void> removeBackgroundImage(String username) async {
    final user = await _driftService.getUserByUsername(username);
    if (user == null) return;

    // Delete image file
    if (user.backgroundImagePath != null) {
      await _fileStorage.deleteBackgroundImage(user.backgroundImagePath!);
    }

    // Update database
    await _driftService.updateUser(
      UserDataTableCompanion(
        id: Value(user.id),
        backgroundImagePath: const Value(null),
      ),
    );
  }

  /// Get profile image file
  Future<File?> getProfileImageFile(String username) async {
    final user = await _driftService.getUserByUsername(username);
    if (user?.profileImagePath == null) return null;

    return await _fileStorage.getProfileImage(user!.profileImagePath!);
  }

  /// Get background image file
  Future<File?> getBackgroundImageFile(String username) async {
    final user = await _driftService.getUserByUsername(username);
    if (user?.backgroundImagePath == null) return null;

    final file = File(user!.backgroundImagePath!);
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  /// Delete user profile and all associated files
  Future<void> deleteUserProfile(String username) async {
    final user = await _driftService.getUserByUsername(username);
    if (user == null) return;

    // Delete profile image
    if (user.profileImagePath != null) {
      await _fileStorage.deleteProfileImage(user.profileImagePath!);
    }

    // Delete background image
    if (user.backgroundImagePath != null) {
      await _fileStorage.deleteBackgroundImage(user.backgroundImagePath!);
    }

    // Delete user from database
    await _driftService.updateUser(
      UserDataTableCompanion(id: Value(user.id), isActive: const Value(false)),
    );
  }

  /// Get all users
  Future<List<UserDataTableData>> getAllUsers() async {
    return await _driftService.getAllUsers();
  }
}
