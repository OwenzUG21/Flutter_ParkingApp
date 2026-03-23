import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 0)
class AppSettings extends HiveObject {
  @HiveField(0)
  String themeMode; // 'light', 'dark', 'system'

  @HiveField(1)
  String language; // 'en', 'sw', etc.

  @HiveField(2)
  bool notificationsEnabled;

  @HiveField(3)
  bool soundEnabled;

  @HiveField(4)
  String currency; // 'UGX', 'USD', etc.

  @HiveField(5)
  double defaultParkingRate;

  @HiveField(6)
  bool autoBackup;

  @HiveField(7)
  String dateFormat; // 'dd/MM/yyyy', 'MM/dd/yyyy', etc.

  @HiveField(8)
  String timeFormat; // '12h', '24h'

  @HiveField(9)
  bool biometricEnabled;

  AppSettings({
    this.themeMode = 'system',
    this.language = 'en',
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.currency = 'UGX',
    this.defaultParkingRate = 5000.0,
    this.autoBackup = false,
    this.dateFormat = 'dd/MM/yyyy',
    this.timeFormat = '12h',
    this.biometricEnabled = false,
  });
}
