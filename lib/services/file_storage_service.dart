import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Service for handling file storage operations
/// Manages both internal and external storage for images, PDFs, and other files
class FileStorageService {
  static final FileStorageService _instance = FileStorageService._internal();
  factory FileStorageService() => _instance;
  FileStorageService._internal();

  // Storage directories
  static const String _profileImagesDir = 'profile_images';
  static const String _backgroundImagesDir = 'background_images';
  static const String _parkingImagesDir = 'parking_images';
  static const String _receiptsDir = 'receipts';
  static const String _backupsDir = 'backups';
  static const String _tempDir = 'temp';

  /// Get the app's document directory
  Future<Directory> getAppDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Get the app's cache directory (for temporary files)
  Future<Directory> getAppCacheDirectory() async {
    return await getTemporaryDirectory();
  }

  /// Get external storage directory (Android only)
  Future<Directory?> getExternalStorageDirectory() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory();
    }
    return null;
  }

  /// Create a directory if it doesn't exist
  Future<Directory> _ensureDirectory(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Get directory for specific file type
  Future<Directory> _getStorageDirectory(String subDir) async {
    final appDir = await getAppDocumentsDirectory();
    final path = p.join(appDir.path, subDir);
    return await _ensureDirectory(path);
  }

  // ========== PROFILE IMAGES ==========

  /// Save profile image and return the file path
  Future<String> saveProfileImage(File imageFile, String userId) async {
    try {
      final dir = await _getStorageDirectory(_profileImagesDir);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = p.extension(imageFile.path);
      final fileName = 'profile_${userId}_$timestamp$extension';
      final targetPath = p.join(dir.path, fileName);

      // Copy file to storage
      final savedFile = await imageFile.copy(targetPath);
      return savedFile.path;
    } catch (e) {
      throw Exception('Failed to save profile image: $e');
    }
  }

  /// Get profile image file
  Future<File?> getProfileImage(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Delete profile image
  Future<bool> deleteProfileImage(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ========== BACKGROUND IMAGES ==========

  /// Save background image and return the file path
  Future<String> saveBackgroundImage(File imageFile, String userId) async {
    try {
      final dir = await _getStorageDirectory(_backgroundImagesDir);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = p.extension(imageFile.path);
      final fileName = 'background_${userId}_$timestamp$extension';
      final targetPath = p.join(dir.path, fileName);

      final savedFile = await imageFile.copy(targetPath);
      return savedFile.path;
    } catch (e) {
      throw Exception('Failed to save background image: $e');
    }
  }

  /// Delete background image
  Future<bool> deleteBackgroundImage(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ========== PARKING IMAGES ==========

  /// Save parking spot image
  Future<String> saveParkingImage(File imageFile, String parkingId) async {
    try {
      final dir = await _getStorageDirectory(_parkingImagesDir);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = p.extension(imageFile.path);
      final fileName = 'parking_${parkingId}_$timestamp$extension';
      final targetPath = p.join(dir.path, fileName);

      final savedFile = await imageFile.copy(targetPath);
      return savedFile.path;
    } catch (e) {
      throw Exception('Failed to save parking image: $e');
    }
  }

  // ========== RECEIPTS & DOCUMENTS ==========

  /// Save receipt as PDF or image
  Future<String> saveReceipt(
    Uint8List data,
    String receiptNumber,
    String extension,
  ) async {
    try {
      final dir = await _getStorageDirectory(_receiptsDir);
      final fileName =
          'receipt_${receiptNumber}_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final targetPath = p.join(dir.path, fileName);

      final file = File(targetPath);
      await file.writeAsBytes(data);
      return targetPath;
    } catch (e) {
      throw Exception('Failed to save receipt: $e');
    }
  }

  /// Get all receipts
  Future<List<File>> getAllReceipts() async {
    try {
      final dir = await _getStorageDirectory(_receiptsDir);
      final files = dir.listSync().whereType<File>().toList();
      return files;
    } catch (e) {
      return [];
    }
  }

  // ========== BACKUPS ==========

  /// Save database backup
  Future<String> saveBackup(File backupFile) async {
    try {
      final dir = await _getStorageDirectory(_backupsDir);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'backup_$timestamp.db';
      final targetPath = p.join(dir.path, fileName);

      final savedFile = await backupFile.copy(targetPath);
      return savedFile.path;
    } catch (e) {
      throw Exception('Failed to save backup: $e');
    }
  }

  /// Get all backups
  Future<List<File>> getAllBackups() async {
    try {
      final dir = await _getStorageDirectory(_backupsDir);
      final files = dir.listSync().whereType<File>().toList();
      // Sort by modification time (newest first)
      files.sort(
        (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
      );
      return files;
    } catch (e) {
      return [];
    }
  }

  /// Delete old backups (keep only last N backups)
  Future<void> cleanOldBackups({int keepCount = 5}) async {
    try {
      final backups = await getAllBackups();
      if (backups.length > keepCount) {
        for (int i = keepCount; i < backups.length; i++) {
          await backups[i].delete();
        }
      }
    } catch (e) {
      // Ignore errors
    }
  }

  // ========== TEMPORARY FILES ==========

  /// Save temporary file
  Future<String> saveTempFile(File file, String fileName) async {
    try {
      final dir = await _getStorageDirectory(_tempDir);
      final targetPath = p.join(dir.path, fileName);
      final savedFile = await file.copy(targetPath);
      return savedFile.path;
    } catch (e) {
      throw Exception('Failed to save temp file: $e');
    }
  }

  /// Clear all temporary files
  Future<void> clearTempFiles() async {
    try {
      final dir = await _getStorageDirectory(_tempDir);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        await _ensureDirectory(dir.path);
      }
    } catch (e) {
      // Ignore errors
    }
  }

  // ========== UTILITY METHODS ==========

  /// Get file size in bytes
  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Check if file exists
  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get total storage used by app
  Future<int> getTotalStorageUsed() async {
    int total = 0;
    try {
      final appDir = await getAppDocumentsDirectory();
      final files = appDir.listSync(recursive: true).whereType<File>();
      for (final file in files) {
        total += await file.length();
      }
    } catch (e) {
      // Ignore errors
    }
    return total;
  }

  /// Format bytes to human readable string
  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Clear all app data (use with caution!)
  Future<void> clearAllData() async {
    try {
      final appDir = await getAppDocumentsDirectory();
      if (await appDir.exists()) {
        await appDir.delete(recursive: true);
        await _ensureDirectory(appDir.path);
      }
    } catch (e) {
      throw Exception('Failed to clear all data: $e');
    }
  }
}
