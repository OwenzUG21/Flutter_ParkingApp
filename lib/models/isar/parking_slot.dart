import 'package:isar/isar.dart';

part 'parking_slot.g.dart';

@collection
class ParkingSlot {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String slotId;

  late String slotNumber;

  late bool isOccupied;

  String? currentPlateNumber;

  DateTime? occupiedSince;

  String? slotType; // 'regular', 'disabled', 'vip', 'motorcycle'

  String? floor; // 'ground', '1st', '2nd', etc.

  String? zone; // 'A', 'B', 'C', etc.

  bool isReserved;

  String? reservedBy;

  DateTime? reservedUntil;

  // Helper method to check if slot is available
  bool get isAvailable => !isOccupied && !isReserved;

  // Helper method to release slot
  void release() {
    isOccupied = false;
    currentPlateNumber = null;
    occupiedSince = null;
  }

  // Helper method to occupy slot
  void occupy(String plateNumber) {
    isOccupied = true;
    currentPlateNumber = plateNumber;
    occupiedSince = DateTime.now();
  }

  ParkingSlot() : isReserved = false;
}
