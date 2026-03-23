# Quick Reference Guide

## 🚀 Getting Started

```dart
// 1. Initialize (already done in main.dart)
await DatabaseManager().initialize();

// 2. Access databases
final db = DatabaseManager();
```

---

## 📊 Common Operations

### Vehicle Entry
```dart
final parkingService = ParkingService();
final record = await parkingService.vehicleEntry(
  plateNumber: 'UAH123X',
  slotNumber: 'A001',
  vehicleType: 'car',
);
```

### Vehicle Exit
```dart
final transaction = await parkingService.vehicleExit(
  plateNumber: 'UAH123X',
  paymentMethod: 'mobile_money',
  phoneNumber: '256700000000',
);
```

### Find Vehicle
```dart
final record = await parkingService.findParkedVehicle('UAH123X');
if (record != null) {
  print('Found in slot: ${record.parkingSlot}');
}
```

### Available Slots
```dart
final slots = await parkingService.getAvailableSlots();
print('${slots.length} slots available');
```

### Today's Revenue
```dart
final revenue = await parkingService.getTodayRevenue();
print('Revenue: $revenue UGX');
```

---

## ⚙️ Settings Management

```dart
final hive = DatabaseManager().hive;

// Get settings
final settings = hive.getSettings();

// Update theme
await hive.updateTheme('dark');

// Toggle notifications
await hive.toggleNotifications(true);
```

---

## 👤 Session Management

```dart
// Save session (login)
final session = UserSession(
  userId: 'user123',
  username: 'john_doe',
  role: 'attendant',
  loginTime: DateTime.now(),
);
await hive.saveSession(session);

// Check if logged in
if (hive.isLoggedIn()) {
  final session = hive.getSession();
  print('Welcome ${session?.username}');
}

// Logout
await hive.clearSession();
```

---

## 💾 Cache Usage

```dart
// Cache with 1 hour expiry
await hive.cacheData(
  'key',
  'value',
  expiry: Duration(hours: 1),
);

// Get cached data
final data = hive.getCachedData('key');

// Clear expired cache
await hive.clearExpiredCache();
```

---

## 🔍 Advanced Queries

### Search by Plate
```dart
final records = await db.isar.searchParkingByPlate('UAH');
```

### Get Transactions by Date
```dart
final transactions = await db.isar.getTransactionsByDate(DateTime.now());
```

### Vehicle History
```dart
final logs = await db.isar.getLogsByPlate('UAH123X');
```

### Recent Activity
```dart
final recentLogs = await db.isar.getRecentLogs(50);
```

---

## 🛠️ Build Commands

```bash
# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter pub run build_runner watch

# Clean and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```
