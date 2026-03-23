# Integration Guide - Adding Databases to Your Screens

## 🎯 Quick Integration Steps

### 1. Import Required Services

Add these imports to your screen files:

```dart
import 'package:project8/services/database_manager.dart';
import 'package:project8/services/parking_service.dart';
```

---

## 📱 Screen-by-Screen Integration

### Dashboard Screen (`lib/screens/dashboard.dart`)

Add real-time parking statistics:

```dart
class _DashboardScreenState extends State<DashboardScreen> {
  final _parkingService = ParkingService();
  
  int _availableSlots = 0;
  int _occupiedSlots = 0;
  double _todayRevenue = 0.0;
  int _todayTransactions = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final availableSlots = await _parkingService.getAvailableSlots();
    final revenue = await _parkingService.getTodayRevenue();
    final transactions = await _parkingService.getTodayTransactions();
    
    setState(() {
      _availableSlots = availableSlots.length;
      _todayRevenue = revenue;
      _todayTransactions = transactions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Stats Cards
          Row(
            children: [
              _buildStatCard('Available', '$_availableSlots', Colors.green),
              _buildStatCard('Revenue', '${_todayRevenue.toInt()} UGX', Colors.blue),
              _buildStatCard('Transactions', '$_todayTransactions', Colors.orange),
            ],
          ),
          // ... rest of your UI
        ],
      ),
    );
  }
}
```

---

### Booking Screen (`lib/screens/bookingscreen.dart`)

Save parking records when booking:

```dart
class _BookingScreenState extends State<BookingScreen> {
  final _parkingService = ParkingService();
  final _plateController = TextEditingController();

  Future<void> _confirmBooking() async {
    try {
      // Create parking record
      final record = await _parkingService.vehicleEntry(
        plateNumber: _plateController.text,
        slotNumber: widget.slotNumber ?? 'A001',
        vehicleType: 'car',
        attendantId: 'SYSTEM', // Or get from session
      );

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking confirmed! Slot: ${record.parkingSlot}')),
      );

      // Navigate to next screen
      Navigator.pushNamed(context, '/reservation', arguments: {
        'parkingName': widget.parkingName,
        'plateNumber': _plateController.text,
        'slotNumber': widget.slotNumber,
        // ... other data
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
```

---

### Parking Spots Screen (`lib/screens/parking_spots.dart`)

Show real-time slot availability:

```dart
class _ParkingSpotsScreenState extends State<ParkingSpotsScreen> {
  final _parkingService = ParkingService();
  List<ParkingSlot> _slots = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    setState(() => _loading = true);
    
    final slots = await _parkingService.getAvailableSlots();
    
    setState(() {
      _slots = slots;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: _slots.length,
      itemBuilder: (context, index) {
        final slot = _slots[index];
        return GestureDetector(
          onTap: () => _selectSlot(slot),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: slot.isAvailable ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                slot.slotNumber,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectSlot(ParkingSlot slot) {
    Navigator.pushNamed(context, '/booking', arguments: {
      'slotNumber': slot.slotNumber,
      // ... other data
    });
  }
}
```

---

### Payment Screen (`lib/screens/mobile_money_payment.dart`)

Record transactions after payment:

```dart
class _MobileMoneyPaymentScreenState extends State<MobileMoneyPaymentScreen> {
  final _parkingService = ParkingService();
  final _phoneController = TextEditingController();

  Future<void> _processPayment() async {
    try {
      // Get plate number from previous screen or session
      final plateNumber = 'UAH123X'; // Get from navigation args

      // Process exit and payment
      final transaction = await _parkingService.vehicleExit(
        plateNumber: plateNumber,
        paymentMethod: 'mobile_money',
        phoneNumber: _phoneController.text,
        attendantId: 'SYSTEM',
      );

      // Show success
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Payment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Amount: ${transaction.feePaid} UGX'),
              Text('Duration: ${transaction.durationMinutes} minutes'),
              Text('Receipt: ${transaction.receiptNumber}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }
}
```

---

### Login Screen (`lib/screens/login.dart`)

Save user session after login:

```dart
import 'package:project8/services/database_manager.dart';
import 'package:project8/models/hive/user_session.dart';

class _LoginScreenState extends State<LoginScreen> {
  final _db = DatabaseManager();

  Future<void> _handleLogin(String username, String password) async {
    // Your existing Firebase auth logic
    // ...

    // After successful login, save session
    final session = UserSession(
      userId: 'user_id_from_firebase',
      username: username,
      role: 'attendant', // or get from Firebase
      email: 'user@example.com',
      loginTime: DateTime.now(),
      rememberMe: _rememberMe,
    );

    await _db.hive.saveSession(session);

    // Navigate to dashboard
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    if (_db.hive.isLoggedIn()) {
      final session = _db.hive.getSession();
      if (session?.rememberMe == true) {
        // Auto-login
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }
  }
}
```

---

## 🔧 Settings Integration

Add settings screen to manage app preferences:

```dart
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _db = DatabaseManager();
  late AppSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = _db.hive.getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Notifications'),
            value: _settings.notificationsEnabled,
            onChanged: (value) async {
              await _db.hive.toggleNotifications(value);
              setState(() {
                _settings = _db.hive.getSettings();
              });
            },
          ),
          ListTile(
            title: Text('Theme'),
            subtitle: Text(_settings.themeMode),
            trailing: DropdownButton<String>(
              value: _settings.themeMode,
              items: ['light', 'dark', 'system']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) async {
                if (value != null) {
                  await _db.hive.updateTheme(value);
                  setState(() {
                    _settings = _db.hive.getSettings();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔍 Search Functionality

Add vehicle search:

```dart
class VehicleSearchScreen extends StatefulWidget {
  const VehicleSearchScreen({super.key});

  @override
  State<VehicleSearchScreen> createState() => _VehicleSearchScreenState();
}

class _VehicleSearchScreenState extends State<VehicleSearchScreen> {
  final _parkingService = ParkingService();
  final _searchController = TextEditingController();
  ParkingRecord? _foundRecord;

  Future<void> _searchVehicle() async {
    final record = await _parkingService.findParkedVehicle(
      _searchController.text,
    );

    setState(() {
      _foundRecord = record;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Vehicle')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Plate Number',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchVehicle,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_foundRecord != null)
              Card(
                child: ListTile(
                  title: Text(_foundRecord!.plateNumber),
                  subtitle: Text('Slot: ${_foundRecord!.parkingSlot}'),
                  trailing: Text(
                    'Duration: ${_foundRecord!.calculateDuration()} min',
                  ),
                ),
              )
            else if (_searchController.text.isNotEmpty)
              Text('Vehicle not found'),
          ],
        ),
      ),
    );
  }
}
```

---

## 📊 Reports Screen

Add daily reports:

```dart
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _parkingService = ParkingService();
  double _revenue = 0.0;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    final revenue = await _parkingService.getTodayRevenue();
    final transactions = await _parkingService.getTodayTransactions();

    setState(() {
      _revenue = revenue;
      _transactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Today\'s Report')),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Total Revenue', style: TextStyle(fontSize: 18)),
                  Text(
                    '${_revenue.toInt()} UGX',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text('${_transactions.length} transactions'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final tx = _transactions[index];
                return ListTile(
                  title: Text(tx.plateNumber),
                  subtitle: Text('${tx.durationMinutes} min'),
                  trailing: Text('${tx.feePaid.toInt()} UGX'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## ✅ Checklist

- [ ] Run `flutter pub get`
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Test database initialization in main.dart
- [ ] Add ParkingService to booking flow
- [ ] Update dashboard with real-time stats
- [ ] Add vehicle search functionality
- [ ] Implement payment recording
- [ ] Add settings screen
- [ ] Test offline functionality
- [ ] Add reports screen

---

## 🚀 Ready to Use!

Your databases are now fully integrated and ready to use. All data will be stored locally and work offline by default.
