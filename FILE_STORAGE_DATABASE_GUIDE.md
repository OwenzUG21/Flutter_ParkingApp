# File Storage + Drift Database Integration Guide

## Overview

This guide explains how the app uses both **file storage** and **Drift database** together to persist data properly. This ensures that:
- ✅ Bookings survive app restarts
- ✅ Profile images are saved and loaded correctly
- ✅ Data remains consistent between files and database

## Architecture

### File Storage (FileStorageService)
**Purpose**: Store large, unstructured data
- Profile images
- Background images
- Parking spot photos
- Receipts (PDFs/images)
- Database backups

**Location**: `lib/services/file_storage_service.dart`

### Drift Database (DriftService)
**Purpose**: Store structured, queryable data
- User profiles (name, email, phone)
- Bookings (plate number, slot, time, status)
- Transactions (payments, fees)
- Parking slots (availability, reservations)
- File paths (references to stored files)

**Location**: `lib/database/app_database.dart`

## Key Principle

**NEVER store large files in the database!**
Instead:
1. Save the file to storage using `FileStorageService`
2. Get the file path
3. Store the path in the database
4. When needed, read the path from database and load the file

## Implementation

### 1. User Profile with Images

```dart
// Save profile with image
final profile = await UserProfileService().saveUserProfile(
  username: 'john_doe',
  fullName: 'John Doe',
  email: 'john@example.com',
  profileImage: File('/path/to/image.jpg'), // File object
);

// Behind the scenes:
// 1. Image is saved to: /app_documents/profile_images/profile_john_doe_123456.jpg
// 2. Path is stored in database: UserDataTable.profileImagePath
// 3. Profile data is stored in database: UserDataTable (name, email, etc.)
```

### 2. Loading Profile with Images

```dart
// Load profile
final profile = await UserProfileService().getUserProfile('john_doe');

// Get the image file
final imageFile = await UserProfileService().getProfileImageFile('john_doe');

// Display in UI
if (imageFile != null) {
  Image.file(imageFile);
}
```

### 3. Creating Bookings

```dart
// Create booking
final booking = await BookingService().createBooking(
  plateNumber: 'UAH123X',
  slotNumber: 'A001',
  startTime: DateTime.now().add(Duration(hours: 1)),
  durationHours: 2,
  parkingRate: 10000.0,
  serviceFee: 1500.0,
);

// Booking is saved to database and persists across app restarts
```

### 4. Loading Bookings

```dart
// Get all bookings
final allBookings = await BookingService().getAllBookings();

// Get active bookings
final activeBookings = await BookingService().getActiveBookings();

// Get upcoming bookings
final upcomingBookings = await BookingService().getUpcomingBookings();
```

## Database Schema

### UserDataTable
```dart
- id: int (primary key)
- username: string (unique)
- fullName: string
- email: string
- phoneNumber: string
- profileImagePath: string (file path) ← NEW
- backgroundImagePath: string (file path) ← NEW
- createdAt: DateTime
- lastLogin: DateTime
```

### ParkingRecords
```dart
- id: int (primary key)
- plateNumber: string
- entryTime: DateTime
- exitTime: DateTime (nullable)
- parkingSlot: string
- amountCharged: double
- paymentStatus: string
- vehicleImagePath: string (file path) ← NEW
- receiptPath: string (file path) ← NEW
```

## Services

### FileStorageService
```dart
// Save images
saveProfileImage(File, userId) → String (path)
saveBackgroundImage(File, userId) → String (path)
saveParkingImage(File, parkingId) → String (path)

// Save documents
saveReceipt(Uint8List, receiptNumber, extension) → String (path)
saveBackup(File) → String (path)

// Retrieve
getProfileImage(path) → File?
fileExists(path) → bool
getFileSize(path) → int

// Cleanup
deleteProfileImage(path) → bool
clearTempFiles() → void
cleanOldBackups(keepCount) → void
```

### UserProfileService
```dart
// Combines file storage + database
saveUserProfile(username, fullName, email, profileImage, backgroundImage) → UserProfile
getUserProfile(username) → UserProfile?
updateProfileImage(username, imageFile) → void
getProfileImageFile(username) → File?
```

### BookingService
```dart
// Database persistence for bookings
createBooking(plateNumber, slotNumber, startTime, duration, rate) → ParkingRecord
getAllBookings() → List<ParkingRecord>
getActiveBookings() → List<ParkingRecord>
getUpcomingBookings() → List<ParkingRecord>
cancelBooking(bookingId) → void
markBookingAsPaid(bookingId, paymentMethod) → void
```

## Fixing Your Issues

### Issue 1: Bookings Disappear on App Restart

**Problem**: Using `ReservationManager` (in-memory storage)

**Solution**: Use `BookingService` (database storage)

```dart
// ❌ OLD WAY (in-memory, lost on restart)
ReservationManager.instance.addReservation({...});

// ✅ NEW WAY (database, persists)
await BookingService().createBooking(
  plateNumber: plateNumber,
  slotNumber: slotNumber,
  startTime: selectedDateTime,
  durationHours: hours,
  parkingRate: rate,
  serviceFee: fee,
);
```

### Issue 2: Profile Images Don't Persist

**Problem**: Images selected but not saved to storage

**Solution**: Use `UserProfileService` to save images

```dart
// ❌ OLD WAY (temporary file, lost on restart)
File? _profileImage; // Just holds temporary path

// ✅ NEW WAY (saved to permanent storage)
await UserProfileService().saveUserProfile(
  username: username,
  fullName: name,
  email: email,
  profileImage: _profileImage, // Saved permanently
);
```

### Issue 3: Cannot Select Profile Picture

**Problem**: Image picker permissions or file handling

**Solution**: Check permissions and use proper file handling

```dart
// Add to AndroidManifest.xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.CAMERA"/>

// In code
final XFile? image = await ImagePicker().pickImage(
  source: ImageSource.gallery,
  maxWidth: 1024,
  maxHeight: 1024,
  imageQuality: 85,
);

if (image != null) {
  final file = File(image.path);
  await UserProfileService().updateProfileImage(username, file);
}
```

## Testing

Run the example to test the integration:

```dart
// Navigate to the test screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => FileStorageDatabaseExample(),
  ),
);
```

Test buttons available:
- **Pick & Save Image**: Test file storage
- **Create User Profile**: Test database
- **Full Profile Flow**: Test file + database integration
- **Full Booking Flow**: Test booking persistence
- **Data Consistency Check**: Verify files match database records

## Best Practices

### ✅ DO
- Store file paths in database, not file contents
- Use `FileStorageService` for all file operations
- Use `UserProfileService` and `BookingService` for integrated operations
- Handle file deletion when updating (delete old, save new)
- Check file existence before loading
- Implement error handling for file operations

### ❌ DON'T
- Store images as BLOB in database
- Store large files in database
- Keep files in temp directory permanently
- Forget to delete old files when updating
- Assume files exist without checking
- Use in-memory storage for persistent data

## Error Handling

```dart
try {
  final path = await FileStorageService().saveProfileImage(file, userId);
  await UserProfileService().updateProfileImage(username, file);
} catch (e) {
  if (e.toString().contains('permission')) {
    // Handle permission error
    showDialog('Please grant storage permission');
  } else if (e.toString().contains('space')) {
    // Handle storage full error
    showDialog('Not enough storage space');
  } else {
    // Handle other errors
    showDialog('Failed to save image: $e');
  }
}
```

## Storage Locations

### Android
- App Documents: `/data/data/com.example.project8/app_flutter/`
- Profile Images: `/data/data/com.example.project8/app_flutter/profile_images/`
- Backups: `/data/data/com.example.project8/app_flutter/backups/`

### iOS
- App Documents: `/var/mobile/Containers/Data/Application/[UUID]/Documents/`
- Profile Images: `/var/mobile/Containers/Data/Application/[UUID]/Documents/profile_images/`

## Migration from Old Code

### Step 1: Update Booking Screen

Replace `ReservationManager` with `BookingService`:

```dart
// In bookingscreen.dart
final _bookingService = BookingService();

// Replace reservation creation
final booking = await _bookingService.createBooking(
  plateNumber: plateNumber,
  slotNumber: slotNumber,
  startTime: selectedDateTime,
  durationHours: hours,
  parkingRate: rate,
  serviceFee: fee,
);
```

### Step 2: Update Profile Screen

Use `UserProfileService` to load images:

```dart
// In profile_screen.dart
final _profileService = UserProfileService();

@override
void initState() {
  super.initState();
  _loadProfileData();
}

Future<void> _loadProfileData() async {
  final username = AuthService().currentUser?.email?.split('@')[0];
  final profile = await _profileService.getUserProfile(username);
  final imageFile = await _profileService.getProfileImageFile(username);
  
  setState(() {
    _profileImage = imageFile;
  });
}
```

### Step 3: Update Edit Profile Screen

Save images properly:

```dart
// In edit_profile_screen.dart
await _profileService.saveUserProfile(
  username: username,
  fullName: _nameController.text,
  email: _emailController.text,
  profileImage: _profileImage,
  backgroundImage: _backgroundImage,
);
```

## Troubleshooting

### Bookings still disappear
- Check if using `BookingService` instead of `ReservationManager`
- Verify database is initialized in `main.dart`
- Check for database errors in logs

### Images don't load
- Verify file path is stored in database
- Check file exists at the path
- Ensure proper permissions
- Check image picker configuration

### App crashes on image selection
- Add permissions to AndroidManifest.xml
- Check iOS Info.plist for photo library usage description
- Handle null cases when no image selected

## Summary

This implementation provides:
- ✅ Persistent bookings that survive app restarts
- ✅ Profile images saved to permanent storage
- ✅ Proper separation of file storage and database
- ✅ Data consistency between files and database
- ✅ Error handling and cleanup
- ✅ Complete working examples

All data is now properly persisted and will survive app restarts!
