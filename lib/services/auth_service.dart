import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _sessionKey = 'user_session';
  static const String _customUsersKey = 'custom_users';

  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  bool get isAdmin => _currentUser?.isAdmin ?? false;

  bool get isGamer => _currentUser?.isGamer ?? false;

  Future<User?> login(String username, String password) async {
    try {
      // Combine built-in users with custom registered users
      final customUsers = await _getCustomUsers();
      final allUsers = [...User.defaultUsers, ...customUsers];

      final user = allUsers.firstWhere(
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

  Future<bool> register(String username, String password, String displayName) async {
    // Prevent duplicate usernames among built-in and custom users
    final existing = [...User.defaultUsers, ...await _getCustomUsers()]
        .any((u) => u.username == username);
    if (existing) return false;

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      password: password,
      role: UserRole.gamer,
      displayName: displayName,
      avatarUrl: null,
    );

    final users = await _getCustomUsers();
    users.add(newUser);
    await _saveCustomUsers(users);
    return true;
  }

  Future<List<User>> _getCustomUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_customUsersKey);
    if (usersJson != null) {
      try {
        final List<dynamic> decoded = json.decode(usersJson);
        return decoded.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  Future<void> _saveCustomUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = users.map((u) => u.toJson()).toList();
    await prefs.setString(_customUsersKey, json.encode(encoded));
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
