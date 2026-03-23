import 'package:isar/isar.dart';

part 'user_data.g.dart';

@collection
class UserData {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String username;

  late String role; // 'admin', 'attendant', 'manager'

  String? fullName;

  String? email;

  String? phoneNumber;

  late DateTime createdAt;

  DateTime? lastLogin;

  bool isActive;

  String? passwordHash; // For offline login

  List<String>? permissions;

  String? shiftSchedule;

  // Login history (stored as JSON string)
  List<String>? loginHistory;

  // Helper method to record login
  void recordLogin() {
    lastLogin = DateTime.now();
    loginHistory ??= [];
    loginHistory!.add(DateTime.now().toIso8601String());
    // Keep only last 50 logins
    if (loginHistory!.length > 50) {
      loginHistory = loginHistory!.sublist(loginHistory!.length - 50);
    }
  }

  UserData() : isActive = true;
}
