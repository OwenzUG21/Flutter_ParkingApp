import 'package:isar/isar.dart';

part 'vehicle_log.g.dart';

@collection
class VehicleLog {
  Id id = Isar.autoIncrement;

  @Index()
  late String plateNumber;

  @Index()
  late DateTime timestamp;

  late String
  activityType; // 'entry', 'exit', 'payment', 'reservation', 'cancellation'

  String? parkingSlot;

  String? description;

  String? attendantId;

  double? amount;

  String? status; // 'success', 'failed', 'pending'

  String? metadata; // JSON string for additional data

  // Helper method to create entry log
  static VehicleLog createEntry(
    String plateNumber,
    String slot,
    String? attendantId,
  ) {
    return VehicleLog()
      ..plateNumber = plateNumber
      ..timestamp = DateTime.now()
      ..activityType = 'entry'
      ..parkingSlot = slot
      ..attendantId = attendantId
      ..status = 'success'
      ..description = 'Vehicle entered parking slot $slot';
  }

  // Helper method to create exit log
  static VehicleLog createExit(String plateNumber, String slot, double amount) {
    return VehicleLog()
      ..plateNumber = plateNumber
      ..timestamp = DateTime.now()
      ..activityType = 'exit'
      ..parkingSlot = slot
      ..amount = amount
      ..status = 'success'
      ..description = 'Vehicle exited parking slot $slot';
  }
}
