import 'package:hive/hive.dart';

part 'user_session.g.dart';

@HiveType(typeId: 1)
class UserSession extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String username;

  @HiveField(2)
  String role;

  @HiveField(3)
  String? email;

  @HiveField(4)
  DateTime loginTime;

  @HiveField(5)
  DateTime? lastActivity;

  @HiveField(6)
  bool rememberMe;

  @HiveField(7)
  String? authToken;

  @HiveField(8)
  bool isOfflineMode;

  UserSession({
    required this.userId,
    required this.username,
    required this.role,
    this.email,
    required this.loginTime,
    this.lastActivity,
    this.rememberMe = false,
    this.authToken,
    this.isOfflineMode = false,
  });

  // Update last activity
  void updateActivity() {
    lastActivity = DateTime.now();
    save();
  }
}
