import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isGamer => _user?.isGamer ?? false;

  AuthProvider() {
    checkSession();
  }

  Future<void> checkSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.checkSession();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Attempt login via AuthService (which checks built-in and custom users)
      final logged = await _authService.login(username, password);
      if (logged == null) {
        _error = 'Неверный логин или пароль';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check if user is blocked
      final isBlocked = await StorageService().isUserBlocked(logged.id);
      if (isBlocked) {
        _error = 'Пользователь заблокирован. Обратитесь к администратору.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _user = logged;
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _error = 'Неверный логин или пароль';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String password, String displayName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _authService.register(username, password, displayName);
      if (!success) {
        _error = 'Пользователь с таким логином уже существует';
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = 'Ошибка регистрации';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }
}
