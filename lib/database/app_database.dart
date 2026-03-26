import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Vehicle Logs Table
class VehicleLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get plateNumber => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get activityType =>
      text()(); // 'entry', 'exit', 'payment', 'reservation', 'cancellation'
  TextColumn get parkingSlot => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get attendantId => text().nullable()();
  RealColumn get amount => real().nullable()();
  TextColumn get status =>
      text().nullable()(); // 'success', 'failed', 'pending'
  TextColumn get metadata => text().nullable()();
}

// User Data Table
class UserDataTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get role => text()(); // 'admin', 'attendant', 'manager'
  TextColumn get fullName => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastLogin => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get passwordHash => text().nullable()();
  TextColumn get permissions => text().nullable()(); // JSON string
  TextColumn get shiftSchedule => text().nullable()();
  TextColumn get loginHistory => text().nullable()(); // JSON string
}

// Transactions Table
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get plateNumber => text()();
  DateTimeColumn get transactionDate => dateTime()();
  IntColumn get durationMinutes => integer()();
  RealColumn get feePaid => real()();
  TextColumn get paymentMethod => text()(); // 'cash', 'mobile_money', 'card'
  TextColumn get paymentStatus =>
      text()(); // 'completed', 'pending', 'failed', 'refunded'
  TextColumn get transactionReference => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get receiptNumber => text().nullable()();
  TextColumn get attendantId => text().nullable()();
  TextColumn get parkingSlot => text().nullable()();
  DateTimeColumn get entryTime => dateTime().nullable()();
  DateTimeColumn get exitTime => dateTime().nullable()();
  RealColumn get serviceFee => real().nullable()();
  RealColumn get totalAmount => real().nullable()();
  TextColumn get notes => text().nullable()();
}

// Parking Slots Table
class ParkingSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get slotId => text().unique()();
  TextColumn get slotNumber => text()();
  BoolColumn get isOccupied => boolean().withDefault(const Constant(false))();
  TextColumn get currentPlateNumber => text().nullable()();
  DateTimeColumn get occupiedSince => dateTime().nullable()();
  TextColumn get slotType =>
      text().nullable()(); // 'regular', 'disabled', 'vip', 'motorcycle'
  TextColumn get floor => text().nullable()();
  TextColumn get zone => text().nullable()();
  BoolColumn get isReserved => boolean().withDefault(const Constant(false))();
  TextColumn get reservedBy => text().nullable()();
  DateTimeColumn get reservedUntil => dateTime().nullable()();
}

// Parking Records Table
class ParkingRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get plateNumber => text()();
  DateTimeColumn get entryTime => dateTime()();
  DateTimeColumn get exitTime => dateTime().nullable()();
  TextColumn get parkingSlot => text()();
  RealColumn get amountCharged => real().nullable()();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get paymentStatus =>
      text().nullable()(); // 'pending', 'paid', 'failed'
  IntColumn get duration => integer().nullable()();
  TextColumn get vehicleType => text().nullable()();
  TextColumn get attendantId => text().nullable()();
  TextColumn get notes => text().nullable()();
}

// Cache Data Table
class CacheDataTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get cachedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
}

// User Session Table
class UserSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get username => text()();
  TextColumn get role => text()();
  TextColumn get email => text().nullable()();
  DateTimeColumn get loginTime => dateTime()();
  DateTimeColumn get lastActivity => dateTime().nullable()();
  BoolColumn get rememberMe => boolean().withDefault(const Constant(false))();
  TextColumn get authToken => text().nullable()();
  BoolColumn get isOfflineMode =>
      boolean().withDefault(const Constant(false))();
}

// App Settings Table
class AppSettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  TextColumn get language => text().withDefault(const Constant('en'))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get currency => text().withDefault(const Constant('UGX'))();
  RealColumn get defaultParkingRate =>
      real().withDefault(const Constant(5000.0))();
  BoolColumn get autoBackup => boolean().withDefault(const Constant(false))();
  TextColumn get dateFormat =>
      text().withDefault(const Constant('dd/MM/yyyy'))();
  TextColumn get timeFormat => text().withDefault(const Constant('12h'))();
  BoolColumn get biometricEnabled =>
      boolean().withDefault(const Constant(false))();
}

@DriftDatabase(
  tables: [
    VehicleLogs,
    UserDataTable,
    Transactions,
    ParkingSlots,
    ParkingRecords,
    CacheDataTable,
    UserSessions,
    AppSettingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'parking_app.db'));
      return NativeDatabase(file);
    });
  }
}
