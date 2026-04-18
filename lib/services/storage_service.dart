import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _favoritesKey = 'favorites';
  static const String _ratingsKey = 'ratings';
  static const String _notificationsKey = 'notifications';
  static const String _deletedGamesKey = 'deleted_games';
  static const String _customGamesKey = 'custom_games';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // Favorites
  Future<List<int>> getFavorites() async {
    final prefs = await _prefs;
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      final List<dynamic> decoded = json.decode(favoritesJson);
      return decoded.cast<int>();
    }
    return [];
  }

  Future<void> addToFavorites(int gameId) async {
    final prefs = await _prefs;
    final favorites = await getFavorites();
    if (!favorites.contains(gameId)) {
      favorites.add(gameId);
      await prefs.setString(_favoritesKey, json.encode(favorites));
    }
  }

  Future<void> removeFromFavorites(int gameId) async {
    final prefs = await _prefs;
    final favorites = await getFavorites();
    favorites.remove(gameId);
    await prefs.setString(_favoritesKey, json.encode(favorites));
  }

  Future<bool> isFavorite(int gameId) async {
    final favorites = await getFavorites();
    return favorites.contains(gameId);
  }

  // Ratings
  Future<Map<int, double>> getRatings() async {
    final prefs = await _prefs;
    final String? ratingsJson = prefs.getString(_ratingsKey);
    if (ratingsJson != null) {
      final Map<String, dynamic> decoded = json.decode(ratingsJson);
      return decoded.map((key, value) =>
          MapEntry(int.parse(key), (value as num).toDouble()));
    }
    return {};
  }

  Future<void> setRating(int gameId, double rating) async {
    final prefs = await _prefs;
    final ratings = await getRatings();
    ratings[gameId] = rating;
    final encoded = ratings.map((key, value) =>
        MapEntry(key.toString(), value));
    await prefs.setString(_ratingsKey, json.encode(encoded));
  }

  Future<double?> getRating(int gameId) async {
    final ratings = await getRatings();
    return ratings[gameId];
  }

  // Deleted Games (Trash)
  Future<List<Map<String, dynamic>>> getDeletedGames() async {
    final prefs = await _prefs;
    final String? deletedJson = prefs.getString(_deletedGamesKey);
    if (deletedJson != null) {
      final List<dynamic> decoded = json.decode(deletedJson);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> addToTrash(Map<String, dynamic> game) async {
    final prefs = await _prefs;
    final deletedGames = await getDeletedGames();
    deletedGames.add({
      ...game,
      'deletedAt': DateTime.now().toIso8601String(),
    });
    await prefs.setString(_deletedGamesKey, json.encode(deletedGames));
  }

  Future<void> restoreFromTrash(int gameId) async {
    final prefs = await _prefs;
    final deletedGames = await getDeletedGames();
    deletedGames.removeWhere((game) => game['id'] == gameId);
    await prefs.setString(_deletedGamesKey, json.encode(deletedGames));
  }

  Future<void> permanentlyDelete(int gameId) async {
    final prefs = await _prefs;
    final deletedGames = await getDeletedGames();
    deletedGames.removeWhere((game) => game['id'] == gameId);
    await prefs.setString(_deletedGamesKey, json.encode(deletedGames));
  }

  // Custom Games (Admin additions/edits)
  Future<List<Map<String, dynamic>>> getCustomGames() async {
    final prefs = await _prefs;
    final String? customJson = prefs.getString(_customGamesKey);
    if (customJson != null) {
      final List<dynamic> decoded = json.decode(customJson);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> saveCustomGame(Map<String, dynamic> game) async {
    final prefs = await _prefs;
    final customGames = await getCustomGames();
    final existingIndex = customGames.indexWhere((g) => g['id'] == game['id']);
    if (existingIndex >= 0) {
      customGames[existingIndex] = game;
    } else {
      customGames.add(game);
    }
    await prefs.setString(_customGamesKey, json.encode(customGames));
  }

  Future<void> deleteCustomGame(int gameId) async {
    final prefs = await _prefs;
    final customGames = await getCustomGames();
    customGames.removeWhere((game) => game['id'] == gameId);
    await prefs.setString(_customGamesKey, json.encode(customGames));
  }

  // Notifications
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final prefs = await _prefs;
    final String? notificationsJson = prefs.getString(_notificationsKey);
    if (notificationsJson != null) {
      final List<dynamic> decoded = json.decode(notificationsJson);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> addNotification(String message, String type) async {
    final prefs = await _prefs;
    final notifications = await getNotifications();
    notifications.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch,
      'message': message,
      'type': type,
      'timestamp': DateTime.now().toIso8601String(),
      'read': false,
    });
    // Keep only last 50 notifications
    if (notifications.length > 50) {
      notifications.removeRange(50, notifications.length);
    }
    await prefs.setString(_notificationsKey, json.encode(notifications));
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    final prefs = await _prefs;
    final notifications = await getNotifications();
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index >= 0) {
      notifications[index]['read'] = true;
      await prefs.setString(_notificationsKey, json.encode(notifications));
    }
  }

  Future<void> clearNotifications() async {
    final prefs = await _prefs;
    await prefs.remove(_notificationsKey);
  }

  Future<int> getUnreadCount() async {
    final notifications = await getNotifications();
    return notifications.where((n) => n['read'] == false).length;
  }

  // Clear all data
  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}
