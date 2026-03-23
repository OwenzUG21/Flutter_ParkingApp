import 'package:isar/isar.dart';

part 'parking_record.g.dart';

@collection
class ParkingRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late String plateNumber;

  late DateTime entryTime;

  DateTime? exitTime;

  @Index()
  late String parkingSlot;

  double? amountCharged;

  String? paymentMethod;

  String? paymentStatus; // 'pending', 'paid', 'failed'

  int? duration; // Duration in minutes

  String? vehicleType; // 'car', 'motorcycle', 'truck'

  String? attendantId;

  String? notes;

  // Helper method to check if vehicle is currently parked
  bool get isParked => exitTime == null;

  // Calculate duration in minutes
  int calculateDuration() {
    if (exitTime == null) {
      return DateTime.now().difference(entryTime).inMinutes;
    }
    return exitTime!.difference(entryTime).inMinutes;
  }
}
