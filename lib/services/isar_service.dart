import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/isar/parking_record.dart';
import '../models/isar/parking_slot.dart';
import '../models/isar/transaction.dart';
import '../models/isar/user_data.dart';
import '../models/isar/vehicle_log.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  factory IsarService() => _instance;
  IsarService._internal();

  Isar? _isar;

  // Initialize Isar database
  Future<void> init() async {
    if (_isar != null) return;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      ParkingRecordSchema,
      ParkingSlotSchema,
      TransactionSchema,
      UserDataSchema,
      VehicleLogSchema,
    ], directory: dir.path);
  }

  Isar get isar {
    if (_isar == null) {
      throw Exception('Isar not initialized. Call init() first.');
    }
    return _isar!;
  }

  // ========== PARKING RECORDS ==========

  Future<int> addParkingRecord(ParkingRecord record) async {
    return await isar.writeTxn(() async {
      return await isar.parkingRecords.put(record);
    });
  }

  Future<ParkingRecord?> getParkingRecordById(int id) async {
    return await isar.parkingRecords.get(id);
  }

  Future<List<ParkingRecord>> getAllParkingRecords() async {
    return await isar.parkingRecords.where().findAll();
  }

  Future<List<ParkingRecord>> getActiveParking() async {
    return await isar.parkingRecords.filter().exitTimeIsNull().findAll();
  }

  Future<ParkingRecord?> getActiveParkingByPlate(String plateNumber) async {
    return await isar.parkingRecords
        .filter()
        .plateNumberEqualTo(plateNumber)
        .exitTimeIsNull()
        .findFirst();
  }

  Future<List<ParkingRecord>> searchParkingByPlate(String plateNumber) async {
    return await isar.parkingRecords
        .filter()
        .plateNumberContains(plateNumber, caseSensitive: false)
        .findAll();
  }

  Future<void> updateParkingRecord(ParkingRecord record) async {
    await isar.writeTxn(() async {
      await isar.parkingRecords.put(record);
    });
  }

  // ========== PARKING SLOTS ==========

  Future<int> addParkingSlot(ParkingSlot slot) async {
    return await isar.writeTxn(() async {
      return await isar.parkingSlots.put(slot);
    });
  }

  Future<List<ParkingSlot>> getAllSlots() async {
    return await isar.parkingSlots.where().findAll();
  }

  Future<List<ParkingSlot>> getAvailableSlots() async {
    return await isar.parkingSlots
        .filter()
        .isOccupiedEqualTo(false)
        .and()
        .isReservedEqualTo(false)
        .findAll();
  }

  Future<ParkingSlot?> getSlotByNumber(String slotNumber) async {
    return await isar.parkingSlots
        .filter()
        .slotNumberEqualTo(slotNumber)
        .findFirst();
  }

  Future<void> updateSlot(ParkingSlot slot) async {
    await isar.writeTxn(() async {
      await isar.parkingSlots.put(slot);
    });
  }

  // ========== TRANSACTIONS ==========

  Future<int> addTransaction(Transaction transaction) async {
    return await isar.writeTxn(() async {
      return await isar.transactions.put(transaction);
    });
  }

  Future<List<Transaction>> getAllTransactions() async {
    return await isar.transactions
        .where()
        .sortByTransactionDateDesc()
        .findAll();
  }

  Future<List<Transaction>> getTransactionsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return await isar.transactions
        .filter()
        .transactionDateBetween(startOfDay, endOfDay)
        .findAll();
  }

  Future<List<Transaction>> getTransactionsByPlate(String plateNumber) async {
    return await isar.transactions
        .filter()
        .plateNumberEqualTo(plateNumber)
        .sortByTransactionDateDesc()
        .findAll();
  }

  Future<double> getDailyRevenue(DateTime date) async {
    final transactions = await getTransactionsByDate(date);
    return transactions
        .where((t) => t.paymentStatus == 'completed')
        .fold<double>(0.0, (sum, t) => sum + t.feePaid);
  }

  // ========== USER DATA ==========

  Future<int> addUser(UserData user) async {
    return await isar.writeTxn(() async {
      return await isar.userDatas.put(user);
    });
  }

  Future<UserData?> getUserByUsername(String username) async {
    return await isar.userDatas.filter().usernameEqualTo(username).findFirst();
  }

  Future<List<UserData>> getAllUsers() async {
    return await isar.userDatas.where().findAll();
  }

  Future<void> updateUser(UserData user) async {
    await isar.writeTxn(() async {
      await isar.userDatas.put(user);
    });
  }

  // ========== VEHICLE LOGS ==========

  Future<int> addVehicleLog(VehicleLog log) async {
    return await isar.writeTxn(() async {
      return await isar.vehicleLogs.put(log);
    });
  }

  Future<List<VehicleLog>> getLogsByPlate(String plateNumber) async {
    return await isar.vehicleLogs
        .filter()
        .plateNumberEqualTo(plateNumber)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<List<VehicleLog>> getRecentLogs(int limit) async {
    return await isar.vehicleLogs
        .where()
        .sortByTimestampDesc()
        .limit(limit)
        .findAll();
  }

  // ========== UTILITY METHODS ==========

  Future<void> clearAllData() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
