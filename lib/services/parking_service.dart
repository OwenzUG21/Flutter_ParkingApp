import '../models/isar/parking_record.dart';
import '../models/isar/parking_slot.dart';
import '../models/isar/transaction.dart';
import '../models/isar/vehicle_log.dart';
import 'database_manager.dart';

class ParkingService {
  final _db = DatabaseManager();

  // ========== VEHICLE ENTRY ==========

  Future<ParkingRecord> vehicleEntry({
    required String plateNumber,
    required String slotNumber,
    String? vehicleType,
    String? attendantId,
  }) async {
    // Create parking record
    final record = ParkingRecord()
      ..plateNumber = plateNumber.toUpperCase()
      ..entryTime = DateTime.now()
      ..parkingSlot = slotNumber
      ..vehicleType = vehicleType ?? 'car'
      ..attendantId = attendantId
      ..paymentStatus = 'pending';

    final recordId = await _db.isar.addParkingRecord(record);
    record.id = recordId;

    // Update parking slot
    final slot = await _db.isar.getSlotByNumber(slotNumber);
    if (slot != null) {
      slot.occupy(plateNumber.toUpperCase());
      await _db.isar.updateSlot(slot);
    }

    // Log activity
    final log = VehicleLog.createEntry(
      plateNumber.toUpperCase(),
      slotNumber,
      attendantId,
    );
    await _db.isar.addVehicleLog(log);

    return record;
  }

  // ========== VEHICLE EXIT ==========

  Future<Transaction> vehicleExit({
    required String plateNumber,
    required String paymentMethod,
    String? phoneNumber,
    String? attendantId,
  }) async {
    // Get active parking record
    final record = await _db.isar.getActiveParkingByPlate(
      plateNumber.toUpperCase(),
    );
    if (record == null) {
      throw Exception('No active parking found for plate: $plateNumber');
    }

    // Calculate duration and fee
    record.exitTime = DateTime.now();
    record.duration = record.calculateDuration();

    // Calculate fee (example: 5000 UGX per hour)
    final hours = (record.duration! / 60).ceil();
    final fee = hours * 5000.0;
    record.amountCharged = fee;
    record.paymentMethod = paymentMethod;
    record.paymentStatus = 'paid';

    await _db.isar.updateParkingRecord(record);

    // Release parking slot
    final slot = await _db.isar.getSlotByNumber(record.parkingSlot);
    if (slot != null) {
      slot.release();
      await _db.isar.updateSlot(slot);
    }

    // Create transaction
    final transaction = Transaction()
      ..plateNumber = plateNumber.toUpperCase()
      ..transactionDate = DateTime.now()
      ..durationMinutes = record.duration!
      ..feePaid = fee
      ..paymentMethod = paymentMethod
      ..paymentStatus = 'completed'
      ..phoneNumber = phoneNumber
      ..attendantId = attendantId
      ..parkingSlot = record.parkingSlot
      ..entryTime = record.entryTime
      ..exitTime = record.exitTime
      ..serviceFee = 1500.0
      ..totalAmount = fee + 1500.0
      ..receiptNumber = 'RCP${DateTime.now().millisecondsSinceEpoch}';

    await _db.isar.addTransaction(transaction);

    // Log exit activity
    final log = VehicleLog.createExit(
      plateNumber.toUpperCase(),
      record.parkingSlot,
      fee,
    );
    await _db.isar.addVehicleLog(log);

    return transaction;
  }

  // ========== SEARCH & QUERIES ==========

  Future<List<ParkingSlot>> getAvailableSlots() async {
    return await _db.isar.getAvailableSlots();
  }

  Future<ParkingRecord?> findParkedVehicle(String plateNumber) async {
    return await _db.isar.getActiveParkingByPlate(plateNumber.toUpperCase());
  }

  Future<List<Transaction>> getTodayTransactions() async {
    return await _db.isar.getTransactionsByDate(DateTime.now());
  }

  Future<double> getTodayRevenue() async {
    return await _db.isar.getDailyRevenue(DateTime.now());
  }

  Future<List<VehicleLog>> getVehicleHistory(String plateNumber) async {
    return await _db.isar.getLogsByPlate(plateNumber.toUpperCase());
  }

  // ========== SLOT MANAGEMENT ==========

  Future<void> initializeParkingSlots(int totalSlots) async {
    for (int i = 1; i <= totalSlots; i++) {
      final slot = ParkingSlot()
        ..slotId = 'SLOT_$i'
        ..slotNumber = 'A${i.toString().padLeft(3, '0')}'
        ..isOccupied = false
        ..slotType = 'regular'
        ..floor = 'ground'
        ..zone = 'A';

      await _db.isar.addParkingSlot(slot);
    }
  }
}
