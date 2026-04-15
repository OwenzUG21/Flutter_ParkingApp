import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  static const String _favoritesKey = 'favorite_parking_lots';
  Set<String> _favorites = {};

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList(_favoritesKey) ?? [];
    _favorites = favoritesList.toSet();
  }

  Future<void> toggleFavorite(String parkingName) async {
    if (_favorites.contains(parkingName)) {
      _favorites.remove(parkingName);
    } else {
      _favorites.add(parkingName);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favorites.toList());
  }

  bool isFavorite(String parkingName) {
    return _favorites.contains(parkingName);
  }

  Set<String> get favorites => Set.from(_favorites);
}
