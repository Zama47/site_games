import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _sessionKey = 'user_session';

  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  bool get isAdmin => _currentUser?.isAdmin ?? false;

  bool get isGamer => _currentUser?.isGamer ?? false;

  Future<User?> login(String username, String password) async {
    try {
      final user = User.defaultUsers.firstWhere(
        (u) => u.username == username && u.password == password,
        orElse: () => throw Exception('Invalid credentials'),
      );

      _currentUser = user;
      await _saveSession(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_sessionKey);
  }

  Future<User?> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      try {
        final userData = json.decode(userJson);
        final user = User.fromJson(userData);
        _currentUser = user;
        return user;
      } catch (e) {
        await logout();
        return null;
      }
    }
    return null;
  }

  Future<void> _saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setString(_sessionKey, DateTime.now().toIso8601String());
  }
}
