import '../database/app_database.dart';
import 'package:drift/drift.dart';

class DriftService {
  static final DriftService _instance = DriftService._internal();
  factory DriftService() => _instance;
  DriftService._internal();

  late AppDatabase _db;

  Future<void> init() async {
    _db = AppDatabase();
  }

  AppDatabase get db => _db;

  // ========== PARKING RECORDS ==========

  Future<int> addParkingRecord(ParkingRecordsCompanion record) async {
    return await _db.into(_db.parkingRecords).insert(record);
  }

  Future<ParkingRecord?> getParkingRecordById(int id) async {
    return await (_db.select(
      _db.parkingRecords,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<ParkingRecord>> getAllParkingRecords() async {
    return await _db.select(_db.parkingRecords).get();
  }

  Future<List<ParkingRecord>> getActiveParking() async {
    return await (_db.select(
      _db.parkingRecords,
    )..where((t) => t.exitTime.isNull())).get();
  }

  Future<ParkingRecord?> getActiveParkingByPlate(String plateNumber) async {
    return await (_db.select(_db.parkingRecords)..where(
          (t) => t.plateNumber.equals(plateNumber) & t.exitTime.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<List<ParkingRecord>> searchParkingByPlate(String plateNumber) async {
    return await (_db.select(
      _db.parkingRecords,
    )..where((t) => t.plateNumber.like('%$plateNumber%'))).get();
  }

  Future<void> updateParkingRecord(ParkingRecordsCompanion record) async {
    await (_db.update(
      _db.parkingRecords,
    )..where((t) => t.id.equals(record.id.value))).write(record);
  }

  // ========== PARKING SLOTS ==========

  Future<int> addParkingSlot(ParkingSlotsCompanion slot) async {
    return await _db.into(_db.parkingSlots).insert(slot);
  }

  Future<List<ParkingSlot>> getAllSlots() async {
    return await _db.select(_db.parkingSlots).get();
  }

  Future<List<ParkingSlot>> getAvailableSlots() async {
    return await (_db.select(_db.parkingSlots)..where(
          (t) => t.isOccupied.equals(false) & t.isReserved.equals(false),
        ))
        .get();
  }

  Future<ParkingSlot?> getSlotByNumber(String slotNumber) async {
    return await (_db.select(
      _db.parkingSlots,
    )..where((t) => t.slotNumber.equals(slotNumber))).getSingleOrNull();
  }

  Future<void> updateSlot(ParkingSlotsCompanion slot) async {
    await (_db.update(
      _db.parkingSlots,
    )..where((t) => t.id.equals(slot.id.value))).write(slot);
  }

  // ========== TRANSACTIONS ==========

  Future<int> addTransaction(TransactionsCompanion transaction) async {
    return await _db.into(_db.transactions).insert(transaction);
  }

  Future<List<Transaction>> getAllTransactions() async {
    return await (_db.select(
      _db.transactions,
    )..orderBy([(t) => OrderingTerm.desc(t.transactionDate)])).get();
  }

  Future<List<Transaction>> getTransactionsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return await (_db.select(_db.transactions)..where(
          (t) =>
              t.transactionDate.isBiggerOrEqualValue(startOfDay) &
              t.transactionDate.isSmallerOrEqualValue(endOfDay),
        ))
        .get();
  }

  Future<List<Transaction>> getTransactionsByPlate(String plateNumber) async {
    return await (_db.select(_db.transactions)
          ..where((t) => t.plateNumber.equals(plateNumber))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  Future<double> getDailyRevenue(DateTime date) async {
    final transactions = await getTransactionsByDate(date);
    return transactions
        .where((t) => t.paymentStatus == 'completed')
        .fold<double>(0.0, (sum, t) => sum + t.feePaid);
  }

  // ========== USER DATA ==========

  Future<int> addUser(UserDataTableCompanion user) async {
    return await _db.into(_db.userDataTable).insert(user);
  }

  Future<UserDataTableData?> getUserByUsername(String username) async {
    return await (_db.select(
      _db.userDataTable,
    )..where((t) => t.username.equals(username))).getSingleOrNull();
  }

  Future<List<UserDataTableData>> getAllUsers() async {
    return await _db.select(_db.userDataTable).get();
  }

  Future<void> updateUser(UserDataTableCompanion user) async {
    await (_db.update(
      _db.userDataTable,
    )..where((t) => t.id.equals(user.id.value))).write(user);
  }

  // ========== VEHICLE LOGS ==========

  Future<int> addVehicleLog(VehicleLogsCompanion log) async {
    return await _db.into(_db.vehicleLogs).insert(log);
  }

  Future<List<VehicleLog>> getLogsByPlate(String plateNumber) async {
    return await (_db.select(_db.vehicleLogs)
          ..where((t) => t.plateNumber.equals(plateNumber))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<List<VehicleLog>> getRecentLogs(int limit) async {
    return await (_db.select(_db.vehicleLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();
  }

  // ========== APP SETTINGS ==========

  Future<void> saveSettings(AppSettingsTableCompanion settings) async {
    final existing = await (_db.select(
      _db.appSettingsTable,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.appSettingsTable).insert(settings);
    } else {
      await (_db.update(
        _db.appSettingsTable,
      )..where((t) => t.id.equals(1))).write(settings);
    }
  }

  Future<AppSettingsTableData?> getSettings() async {
    return await (_db.select(
      _db.appSettingsTable,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
  }

  // ========== USER SESSION ==========

  Future<void> saveSession(UserSessionsCompanion session) async {
    await _db.into(_db.userSessions).insert(session, mode: InsertMode.replace);
  }

  Future<UserSession?> getSession() async {
    return await (_db.select(_db.userSessions)..limit(1)).getSingleOrNull();
  }

  Future<void> clearSession() async {
    await _db.delete(_db.userSessions).go();
  }

  Future<bool> isLoggedIn() async {
    final session = await getSession();
    return session != null;
  }

  // ========== CACHE ==========

  Future<void> cacheData(String key, String value, {Duration? expiry}) async {
    final cacheData = CacheDataTableCompanion(
      key: Value(key),
      value: Value(value),
      cachedAt: Value(DateTime.now()),
      expiresAt: Value(expiry != null ? DateTime.now().add(expiry) : null),
    );
    await _db
        .into(_db.cacheDataTable)
        .insert(cacheData, mode: InsertMode.replace);
  }

  Future<String?> getCachedData(String key) async {
    final cache = await (_db.select(
      _db.cacheDataTable,
    )..where((t) => t.key.equals(key))).getSingleOrNull();

    if (cache == null) return null;
    if (cache.expiresAt != null && DateTime.now().isAfter(cache.expiresAt!)) {
      await (_db.delete(
        _db.cacheDataTable,
      )..where((t) => t.key.equals(key))).go();
      return null;
    }

    return cache.value;
  }

  Future<void> clearCache() async {
    await _db.delete(_db.cacheDataTable).go();
  }

  Future<void> clearExpiredCache() async {
    await (_db.delete(_db.cacheDataTable)..where(
          (t) =>
              t.expiresAt.isNotNull() &
              t.expiresAt.isSmallerThanValue(DateTime.now()),
        ))
        .go();
  }

  // ========== UTILITY ==========

  Future<void> clearAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.parkingRecords).go();
      await _db.delete(_db.parkingSlots).go();
      await _db.delete(_db.transactions).go();
      await _db.delete(_db.userDataTable).go();
      await _db.delete(_db.vehicleLogs).go();
      await _db.delete(_db.cacheDataTable).go();
      await _db.delete(_db.userSessions).go();
      await _db.delete(_db.appSettingsTable).go();
    });
  }

  Future<void> close() async {
    await _db.close();
  }
}
