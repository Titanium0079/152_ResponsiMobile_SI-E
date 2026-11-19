import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'saved_username';
  static const String _keyFavorites = 'favorite_recipe_ids';

  // Sesuaikan dengan ketentuan: username = nama panggilan, password = 3 digit akhir NIM
  static const String validUsername = 'titan';
  static const String validPassword = '152';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> saveLogin(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsername, username);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  static Future<List<int>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_keyFavorites) ?? [];
    return rawList
        .map((e) => int.tryParse(e) ?? -1)
        .where((id) => id > 0)
        .toList();
  }

  static Future<void> setFavorite(int recipeId, bool isFavorite) async {
    final prefs = await SharedPreferences.getInstance();
    final currentIds = await getFavoriteIds();
    if (isFavorite) {
      if (!currentIds.contains(recipeId)) {
        currentIds.add(recipeId);
      }
    } else {
      currentIds.remove(recipeId);
    }
    await prefs.setStringList(
      _keyFavorites,
      currentIds.map((e) => e.toString()).toList(),
    );
  }
}
