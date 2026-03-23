import 'package:hive/hive.dart';

part 'cache_data.g.dart';

@HiveType(typeId: 2)
class CacheData extends HiveObject {
  @override
  @HiveField(0)
  String key;

  @HiveField(1)
  String value;

  @HiveField(2)
  DateTime cachedAt;

  @HiveField(3)
  DateTime? expiresAt;

  CacheData({
    required this.key,
    required this.value,
    required this.cachedAt,
    this.expiresAt,
  });

  // Check if cache is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}
