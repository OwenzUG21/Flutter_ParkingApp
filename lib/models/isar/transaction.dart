import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  @Index()
  late String plateNumber;

  @Index()
  late DateTime transactionDate;

  late int durationMinutes;

  late double feePaid;

  late String paymentMethod; // 'cash', 'mobile_money', 'card'

  late String paymentStatus; // 'completed', 'pending', 'failed', 'refunded'

  String? transactionReference;

  String? phoneNumber; // For mobile money

  String? receiptNumber;

  String? attendantId;

  String? parkingSlot;

  DateTime? entryTime;

  DateTime? exitTime;

  double? serviceFee;

  double? totalAmount;

  String? notes;

  // Helper method to calculate total with service fee
  double calculateTotal() {
    return feePaid + (serviceFee ?? 0);
  }
}
