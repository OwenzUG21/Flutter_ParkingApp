import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/file_storage_service.dart';
import '../services/user_profile_service.dart';
import '../services/booking_service.dart';
import '../services/drift_service.dart';

/// Complete example showing File Storage + Drift Database integration
/// Demonstrates how to use both systems together effectively
class FileStorageDatabaseExample extends StatefulWidget {
  const FileStorageDatabaseExample({super.key});

  @override
  State<FileStorageDatabaseExample> createState() =>
      _FileStorageDatabaseExampleState();
}

class _FileStorageDatabaseExampleState
    extends State<FileStorageDatabaseExample> {
  final _fileStorage = FileStorageService();
  final _profileService = UserProfileService();
  final _bookingService = BookingService();
  final _driftService = DriftService();
  final _picker = ImagePicker();

  String _output = 'Ready to test File Storage + Database integration...';
  File? _selectedImage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('File Storage + Database Example'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Output Display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(minHeight: 200),
              child: SingleChildScrollView(
                child: Text(
                  _output,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Image Preview
            if (_selectedImage != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Test Buttons
            _buildSection('File Storage Tests', [
              _buildTestButton(
                'Pick & Save Image',
                _testImageStorage,
                Icons.image,
              ),
              _buildTestButton(
                'Get Storage Info',
                _testStorageInfo,
                Icons.info,
              ),
              _buildTestButton(
                'Clear Temp Files',
                _testClearTemp,
                Icons.cleaning_services,
              ),
            ]),

            const SizedBox(height: 16),

            _buildSection('Database Tests', [
              _buildTestButton(
                'Create User Profile',
                _testCreateProfile,
                Icons.person_add,
              ),
              _buildTestButton(
                'Load User Profile',
                _testLoadProfile,
                Icons.person,
              ),
              _buildTestButton(
                'Create Booking',
                _testCreateBooking,
                Icons.book_online,
              ),
            ]),

            const SizedBox(height: 16),

            _buildSection('Integration Tests', [
              _buildTestButton(
                'Full Profile Flow',
                _testFullProfileFlow,
                Icons.account_circle,
              ),
              _buildTestButton(
                'Full Booking Flow',
                _testFullBookingFlow,
                Icons.local_parking,
              ),
              _buildTestButton(
                'Data Consistency Check',
                _testDataConsistency,
                Icons.check_circle,
              ),
            ]),

            const SizedBox(height: 16),

            _buildSection('Cleanup', [
              _buildTestButton(
                'Clear All Test Data',
                _testClearAll,
                Icons.delete_forever,
                color: Colors.red,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> buttons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...buttons,
      ],
    );
  }

  Widget _buildTestButton(
    String label,
    VoidCallback onPressed,
    IconData icon, {
    Color color = Colors.blue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  void _setOutput(String text) {
    setState(() => _output = text);
  }

  void _appendOutput(String text) {
    setState(() => _output += '\n$text');
  }

  // ========== FILE STORAGE TESTS ==========

  Future<void> _testImageStorage() async {
    try {
      setState(() => _isLoading = true);
      _setOutput('Testing image storage...\n');

      // Pick image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image == null) {
        _appendOutput('❌ No image selected');
        return;
      }

      _appendOutput('✅ Image picked: ${image.name}');

      // Save as profile image
      final file = File(image.path);
      final savedPath = await _fileStorage.saveProfileImage(file, 'test_user');

      setState(() => _selectedImage = File(savedPath));

      _appendOutput('✅ Image saved to: $savedPath');

      // Get file info
      final size = await _fileStorage.getFileSize(savedPath);
      final exists = await _fileStorage.fileExists(savedPath);

      _appendOutput('📊 File size: ${_fileStorage.formatBytes(size)}');
      _appendOutput('📊 File exists: $exists');
    } catch (e) {
      _appendOutput('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testStorageInfo() async {
    try {
      setState(() => _isLoading = true);
      _setOutput('Getting storage information...\n');

      final totalUsed = await _fileStorage.getTotalStorageUsed();
      final appDir = await _fileStorage.getAppDocumentsDirectory();
      final cacheDir = await _fileStorage.getAppCacheDirectory();

      _appendOutput(
        '📊 Total storage used: ${_fileStorage.formatBytes(totalUsed)}',
      );
      _appendOutput('📁 App directory: ${appDir.path}');
      _appendOutput('📁 Cache directory: ${cacheDir.path}');

      // Get backups
      final backups = await _fileStorage.getAllBackups();
      _appendOutput('💾 Backups found: ${backups.length}');

      // Get receipts
      final receipts = await _fileStorage.getAllReceipts();
      _appendOutput('🧾 Receipts found: ${receipts.length}');
    } catch (e) {
      _appendOutput('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testClearTemp() async {
    try {
      setState(() => _isLoading = true);
      _setOutput('Clearing temporary files...\n');

      await _fileStorage.clearTempFiles();
      _appendOutput('✅ Temporary files cleared');
    } catch (e) {
      _appendOutput('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ========== DATABASE TESTS ==========

  Future<void> _testCreateProfile() async {
    try {
      setState(() => _isLoading = true);
      _setOutput('Creating user profile in database...\n');

      final profile = await _profileService.saveUserProfile(
        username: 'test_user',
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: '+256700000000',
        role: 'user',
      );

      _appendOutput('✅ Profile created:');
      _appendOutput('   ID: ${profile.id}');
      _appendOutput('   Username: ${profile.username}');
      _appendOutput('   Name: ${profile.fullName}');
      _appendOutput('   Email: ${profile.email}');
      _appendOutput('   Phone: ${profile.phoneNumber}');
    } catch (e) {
      _appendOutput('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testLoadProfile() async {
    try {
      setState(() => _isLoading = true);
      _setOutput('Loading user profile from database...\n');

      final profile = await _profileService.getUserProfile('test_user');

      if (profile == null) {
        _appendOutput('❌ Profile not found');
        return;
      }

      _appendOutput('✅ Profile loaded:');
      _appendOutput('   ID: ${profile.id}');
      _appendOutput('   Username: ${profile.username}');
      _appendOutput('   Name: ${profile.fullName}');
      _appendOutput('   Email: ${profile.email}');
      _appendOutput('   Profile Image: ${profile.profileImagePath ?? "None"}');
      _appendOutput(
        '   Background Image: ${profile.backgroundImagePath ?? "None"}',
      );
    } catch (e) {
      _appendOutput('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testCreateBooking() async {
    try {
      setState(() => _isLoading = true);
      _setOutput('Creating booking in database...\n');

      final booking = await _bookingService.createBooking(
        plateNumber: 'UAH123X',
        slotNumber: 'A001',
        startTime: DateTime.now().add(const Duration(hours: 1)),
        durationHours: 2,
        parkingRate: 10000.0,
        serviceFee: 1500.0,
        vehicleType: 'car',
        notes: 'Test booking',
      );

      _appendOutput('✅ Booking created:');
      _appendOutput('   ID: ${booking.id}');
      _appendOutput('   Plate: ${booking.plateNumber}');
      _appendOutput('   Slot: ${booking.parkingSlot}');
      _appendOutput('   Start: ${booking.entryTime}');
      _appendOutput('   Status: ${booking.paymentStatus}');
    } catch (e) {
      _appendOutput('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ========== INTEGRATION TESTS ==========

  Future<void> _testFullProfileFlow() async {
    try {
      setState(() => _isLoading = true);
      _setOutput('Testing full profile flow (File + Database)...\n');

      // Step 1: Pick image
      _appendOutput('Step 1: Picking image...');
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image == null) {
        _appendOutput('❌ No image selected');
        return;
      }

      // Step 2: Save profile with image
      _appendOutput('Step 2: Saving profile with image...');
      final profile = await _profileService.saveUserProfile(
        username: 'integration_test',
        fullName: 'Integration Test User',
        email: 'integration@test.com',
        phoneNumber: '+256700000000',
        role: 'user',
        profileImage: File(image.path),
      );

      _appendOutput('✅ Profile saved with image');
      _appendOutput('   Profile ID: ${profile.id}');
      _appendOutput('   Image path: ${profile.profileImagePath}');

      // Step 3: Verify file exists
      _appendOutput('Step 3: Verifying file...');
      final exists = await _fileStorage.fileExists(profile.profileImagePath!);
      final size = await _fileStorage.getFileSize(profile.profileImagePath!);

      _appendOutput('✅ File verification:');
      _appendOutput('   Exists: $exists');
      _appendOutput('   Size: ${_fileStorage.formatBytes(size)}');

      // Step 4: Load profile and image
      _appendOutput('Step 4: Loading profile and image...');
      final loadedProfile = await _profileService.getUserProfile(
        'integration_test',
      );
      final imageFile = await _profileService.getProfileImageFile(
        'integration_test',
      );

      _appendOutput('✅ Profile and image loaded successfully');
      _appendOutput('   Profile: ${loadedProfile?.fullName}');
      _appendOutput('   Image file: ${imageFile?.path}');

      setState(() => _selectedImage = imageFile);

      _appendOutput('\n🎉 Full profile flow completed successfully!');
    } catch (e) {
      _appendOutput('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testFullBookingFlow() async {
    try {
      setState(() => _isLoading = true);
      _setOutput('Testing full booking flow...\n');

      // Create booking
      _appendOutput('Step 1: Creating booking...');
      final booking = await _bookingService.createBooking(
        plateNumber: 'TEST456',
        slotNumber: 'B002',
        startTime: DateTime.now(),
        durationHours: 3,
        parkingRate: 15000.0,
        serviceFee: 2250.0,
        vehicleType: 'car',
      );

      _appendOutput('✅ Booking created: ID ${booking.id}');

      // Get booking stats
      _appendOutput('Step 2: Getting booking stats...');
      final stats = await _bookingService.getBookingStats();

      _appendOutput('✅ Booking statistics:');
      _appendOutput('   Total: ${stats['total']}');
      _appendOutput('   Active: ${stats['active']}');
      _appendOutput('   Upcoming: ${stats['upcoming']}');
      _appendOutput('   Revenue: UGX ${stats['totalRevenue']}');

      _appendOutput('\n🎉 Full booking flow completed!');
    } catch (e) {
      _appendOutput('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testDataConsistency() async {
    try {
      setState(() => _isLoading = true);
      _setOutput('Checking data consistency...\n');

      // Check profiles
      _appendOutput('Checking user profiles...');
      final users = await _profileService.getAllUsers();
      _appendOutput('✅ Found ${users.length} users');

      int filesFound = 0;
      int filesMissing = 0;

      for (final user in users) {
        if (user.profileImagePath != null) {
          final exists = await _fileStorage.fileExists(user.profileImagePath!);
          if (exists) {
            filesFound++;
          } else {
            filesMissing++;
            _appendOutput('⚠️  Missing file for user ${user.username}');
          }
        }
      }

      _appendOutput(
        '📊 Profile images: $filesFound found, $filesMissing missing',
      );

      // Check bookings
      _appendOutput('\nChecking bookings...');
      final bookings = await _bookingService.getAllBookings();
      _appendOutput('✅ Found ${bookings.length} bookings');

      // Check storage
      _appendOutput('\nChecking storage...');
      final totalUsed = await _fileStorage.getTotalStorageUsed();
      _appendOutput('📊 Total storage: ${_fileStorage.formatBytes(totalUsed)}');

      _appendOutput('\n✅ Data consistency check completed!');
    } catch (e) {
      _appendOutput('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testClearAll() async {
    try {
      setState(() => _isLoading = true);
      _setOutput('Clearing all test data...\n');

      // Clear database
      _appendOutput('Clearing database...');
      await _driftService.clearAllData();
      _appendOutput('✅ Database cleared');

      // Clear files (keep this commented for safety)
      // await _fileStorage.clearAllData();
      // _appendOutput('✅ Files cleared');

      setState(() => _selectedImage = null);

      _appendOutput('\n✅ All test data cleared!');
    } catch (e) {
      _appendOutput('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
