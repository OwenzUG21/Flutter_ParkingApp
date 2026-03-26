import 'package:drift/drift.dart';
import '../database/app_database.dart';
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
    final recordId = await _db.drift.addParkingRecord(
      ParkingRecordsCompanion.insert(
        plateNumber: plateNumber.toUpperCase(),
        entryTime: DateTime.now(),
        parkingSlot: slotNumber,
        vehicleType: Value(vehicleType ?? 'car'),
        attendantId: Value(attendantId),
        paymentStatus: const Value('pending'),
      ),
    );

    // Update parking slot
    final slot = await _db.drift.getSlotByNumber(slotNumber);
    if (slot != null) {
      await _db.drift.updateSlot(
        ParkingSlotsCompanion(
          id: Value(slot.id),
          isOccupied: const Value(true),
          currentPlateNumber: Value(plateNumber.toUpperCase()),
          occupiedSince: Value(DateTime.now()),
        ),
      );
    }

    // Log activity
    await _db.drift.addVehicleLog(
      VehicleLogsCompanion.insert(
        plateNumber: plateNumber.toUpperCase(),
        timestamp: DateTime.now(),
        activityType: 'entry',
        parkingSlot: Value(slotNumber),
        attendantId: Value(attendantId),
        status: const Value('success'),
        description: Value('Vehicle entered parking slot $slotNumber'),
      ),
    );

    return (await _db.drift.getParkingRecordById(recordId))!;
  }

  // ========== VEHICLE EXIT ==========

  Future<Transaction> vehicleExit({
    required String plateNumber,
    required String paymentMethod,
    String? phoneNumber,
    String? attendantId,
  }) async {
    // Get active parking record
    final record = await _db.drift.getActiveParkingByPlate(
      plateNumber.toUpperCase(),
    );
    if (record == null) {
      throw Exception('No active parking found for plate: $plateNumber');
    }

    // Calculate duration and fee
    final exitTime = DateTime.now();
    final duration = exitTime.difference(record.entryTime).inMinutes;
    final hours = (duration / 60).ceil();
    final fee = hours * 5000.0;

    // Update parking record
    await _db.drift.updateParkingRecord(
      ParkingRecordsCompanion(
        id: Value(record.id),
        exitTime: Value(exitTime),
        duration: Value(duration),
        amountCharged: Value(fee),
        paymentMethod: Value(paymentMethod),
        paymentStatus: const Value('paid'),
      ),
    );

    // Release parking slot
    final slot = await _db.drift.getSlotByNumber(record.parkingSlot);
    if (slot != null) {
      await _db.drift.updateSlot(
        ParkingSlotsCompanion(
          id: Value(slot.id),
          isOccupied: const Value(false),
          currentPlateNumber: const Value(null),
          occupiedSince: const Value(null),
        ),
      );
    }

    // Create transaction
    final transactionId = await _db.drift.addTransaction(
      TransactionsCompanion.insert(
        plateNumber: plateNumber.toUpperCase(),
        transactionDate: DateTime.now(),
        durationMinutes: duration,
        feePaid: fee,
        paymentMethod: paymentMethod,
        paymentStatus: 'completed',
        phoneNumber: Value(phoneNumber),
        attendantId: Value(attendantId),
        parkingSlot: Value(record.parkingSlot),
        entryTime: Value(record.entryTime),
        exitTime: Value(exitTime),
        serviceFee: const Value(1500.0),
        totalAmount: Value(fee + 1500.0),
        receiptNumber: Value('RCP${DateTime.now().millisecondsSinceEpoch}'),
      ),
    );

    // Log exit activity
    await _db.drift.addVehicleLog(
      VehicleLogsCompanion.insert(
        plateNumber: plateNumber.toUpperCase(),
        timestamp: DateTime.now(),
        activityType: 'exit',
        parkingSlot: Value(record.parkingSlot),
        amount: Value(fee),
        status: const Value('success'),
        description: Value('Vehicle exited parking slot ${record.parkingSlot}'),
      ),
    );

    final allTransactions = await _db.drift.getAllTransactions();
    return allTransactions.firstWhere((t) => t.id == transactionId);
  }

  // ========== SEARCH & QUERIES ==========

  Future<List<ParkingSlot>> getAvailableSlots() async {
    return await _db.drift.getAvailableSlots();
  }

  Future<ParkingRecord?> findParkedVehicle(String plateNumber) async {
    return await _db.drift.getActiveParkingByPlate(plateNumber.toUpperCase());
  }

  Future<List<Transaction>> getTodayTransactions() async {
    return await _db.drift.getTransactionsByDate(DateTime.now());
  }

  Future<double> getTodayRevenue() async {
    return await _db.drift.getDailyRevenue(DateTime.now());
  }

  Future<List<VehicleLog>> getVehicleHistory(String plateNumber) async {
    return await _db.drift.getLogsByPlate(plateNumber.toUpperCase());
  }

  // ========== SLOT MANAGEMENT ==========

  Future<void> initializeParkingSlots(int totalSlots) async {
    for (int i = 1; i <= totalSlots; i++) {
      await _db.drift.addParkingSlot(
        ParkingSlotsCompanion.insert(
          slotId: 'SLOT_$i',
          slotNumber: 'A${i.toString().padLeft(3, '0')}',
          slotType: const Value('regular'),
          floor: const Value('ground'),
          zone: const Value('A'),
        ),
      );
    }
  }
}
