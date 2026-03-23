# Database Setup Guide

This project uses two databases for optimal performance:

## 🗄️ Database Architecture

### 1. **Isar Database** - Structured Parking Data
Fast, offline-first NoSQL database for complex queries and large datasets.

**Use Cases:**
- Parking records (entry/exit tracking)
- Parking slot management
- Transaction history
- User data (attendants/admins)
- Vehicle activity logs

### 2. **Hive Database** - Lightweight App Data
Key-value database for simple, fast access to app settings and cache.

**Use Cases:**
- App settings (theme, language, notifications)
- User session management
- Cached data with expiry
- Temporary storage

---

## 📦 Installation

### Step 1: Install Dependencies

```bash
flutter pub get
```

### Step 2: Generate Code

Run the build runner to generate Isar and Hive adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `*.g.dart` files for all Isar models
- `*.g.dart` files for all Hive models

---

## 🚀 Usage

### Initialize Databases

Databases are automatically initialized in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseManager().initialize();
  runApp(const MyApp());
}
```

### Access Databases

```dart
final db = DatabaseManager();

// Access Isar service
final isar = db.isar;

// Access Hive service
final hive = db.hive;
```

---

## 📊 Isar Database Usage

### 1. Parking Records

```dart
// Vehicle entry
final record = ParkingRecord()
  ..plateNumber = 'UAH123X'
  ..entryTime = DateTime.now()
  ..parkingSlot = 'A001'
  ..vehicleType = 'car'
  ..paymentStatus = 'pending';

await db.isar.addParkingRecord(record);

// Find active parking
final activeRecord = await db.isar.getActiveParkingByPlate('UAH123X');

// Search by plate number
final records = await db.isar.searchParkingByPlate('UAH');
```

### 2. Parking Slots

```dart
// Get available slots
final availableSlots = await db.isar.getAvailableSlots();

// Update slot status
final slot = await db.isar.getSlotByNumber('A001');
if (slot != null) {
  slot.occupy('UAH123X');
  await db.isar.updateSlot(slot);
}

// Release slot
slot.release();
await db.isar.updateSlot(slot);
```

### 3. Transactions

```dart
// Add transaction
final transaction = Transaction()
  ..plateNumber = 'UAH123X'
  ..transactionDate = DateTime.now()
  ..durationMinutes = 120
  ..feePaid = 10000.0
  ..paymentMethod = 'mobile_money'
  ..paymentStatus = 'completed';

await db.isar.addTransaction(transaction);

// Get today's revenue
final revenue = await db.isar.getDailyRevenue(DateTime.now());

// Get transactions by date
final transactions = await db.isar.getTransactionsByDate(DateTime.now());
```

### 4. Vehicle Logs

```dart
// Log vehicle entry
final log = VehicleLog.createEntry('UAH123X', 'A001', 'ATT001');
await db.isar.addVehicleLog(log);

// Get vehicle history
final history = await db.isar.getLogsByPlate('UAH123X');

// Get recent logs
final recentLogs = await db.isar.getRecentLogs(50);
```

### 5. User Management

```dart
// Add user
final user = UserData()
  ..username = 'john_doe'
  ..role = 'attendant'
  ..fullName = 'John Doe'
  ..email = 'john@example.com'
  ..createdAt = DateTime.now()
  ..isActive = true;

await db.isar.addUser(user);

// Get user by username
final user = await db.isar.getUserByUsername('john_doe');

// Record login
user?.recordLogin();
await db.isar.updateUser(user!);
```

---

## 🎨 Hive Database Usage

### 1. App Settings

```dart
// Save settings
final settings = AppSettings(
  themeMode: 'dark',
  language: 'en',
  notificationsEnabled: true,
  currency: 'UGX',
  defaultParkingRate: 5000.0,
);
await db.hive.saveSettings(settings);

// Get settings
final settings = db.hive.getSettings();

// Update specific setting
await db.hive.updateTheme('light');
await db.hive.toggleNotifications(false);
```

### 2. User Session

```dart
// Save session
final session = UserSession(
  userId: 'user123',
  username: 'john_doe',
  role: 'attendant',
  email: 'john@example.com',
  loginTime: DateTime.now(),
  rememberMe: true,
);
await db.hive.saveSession(session);

// Get session
final session = db.hive.getSession();

// Check login status
final isLoggedIn = db.hive.isLoggedIn();

// Clear session (logout)
await db.hive.clearSession();
```

### 3. Cache Management

```dart
// Cache data with expiry
await db.hive.cacheData(
  'parking_rates',
  '{"regular": 5000, "vip": 10000}',
  expiry: Duration(hours: 1),
);

// Get cached data
final data = db.hive.getCachedData('parking_rates');

// Clear expired cache
await db.hive.clearExpiredCache();

// Clear all cache
await db.hive.clearCache();
```

---

## 🛠️ High-Level Service: ParkingService

Use `ParkingService` for common parking operations:

```dart
final parkingService = ParkingService();

// Vehicle entry
final record = await parkingService.vehicleEntry(
  plateNumber: 'UAH123X',
  slotNumber: 'A001',
  vehicleType: 'car',
  attendantId: 'ATT001',
);

// Vehicle exit
final transaction = await parkingService.vehicleExit(
  plateNumber: 'UAH123X',
  paymentMethod: 'mobile_money',
  phoneNumber: '256700000000',
  attendantId: 'ATT001',
);

// Find parked vehicle
final record = await parkingService.findParkedVehicle('UAH123X');

// Get available slots
final slots = await parkingService.getAvailableSlots();

// Get today's revenue
final revenue = await parkingService.getTodayRevenue();

// Initialize parking slots
await parkingService.initializeParkingSlots(50);
```

---

## 📁 Project Structure

```
lib/
├── models/
│   ├── isar/                    # Isar models
│   │   ├── parking_record.dart
│   │   ├── parking_slot.dart
│   │   ├── transaction.dart
│   │   ├── user_data.dart
│   │   └── vehicle_log.dart
│   └── hive/                    # Hive models
│       ├── app_settings.dart
│       ├── user_session.dart
│       └── cache_data.dart
├── services/
│   ├── database_manager.dart    # Main database manager
│   ├── isar_service.dart        # Isar operations
│   ├── hive_service.dart        # Hive operations
│   └── parking_service.dart     # High-level parking logic
└── examples/
    └── database_usage_example.dart
```

---

## 🔍 Key Features

### Isar Features:
- ✅ Fast indexing for quick searches
- ✅ Complex queries with filters
- ✅ Offline-first architecture
- ✅ Automatic ID generation
- ✅ Relationships between collections
- ✅ Full-text search support

### Hive Features:
- ✅ Lightning-fast key-value storage
- ✅ Minimal memory footprint
- ✅ Type-safe with code generation
- ✅ Cache expiry support
- ✅ Easy to use API

---

## 🧪 Testing

See `lib/examples/database_usage_example.dart` for a complete working example with UI.

---

## 🔄 Regenerating Code

Whenever you modify models, regenerate the code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes:

```bash
flutter pub run build_runner watch
```

---

## 🗑️ Clear Data

```dart
// Clear all Isar data
await db.isar.clearAllData();

// Clear all Hive data
await db.hive.clearAllData();

// Clear everything
await db.clearAllData();
```

---

## 📝 Notes

1. Always run `build_runner` after modifying models
2. Isar is best for complex queries and large datasets
3. Hive is best for simple key-value storage
4. Both databases work offline by default
5. Use indexes on frequently queried fields in Isar

---

## 🚨 Common Issues

### Issue: "No generated files found"
**Solution:** Run `flutter pub run build_runner build --delete-conflicting-outputs`

### Issue: "Isar not initialized"
**Solution:** Ensure `DatabaseManager().initialize()` is called in `main()`

### Issue: "Adapter not registered"
**Solution:** Check that Hive adapters are registered in `HiveService.init()`

---

## 📚 Resources

- [Isar Documentation](https://isar.dev)
- [Hive Documentation](https://docs.hivedb.dev)
