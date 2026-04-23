import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class NotificationsProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;

  List<Map<String, dynamic>> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _storageService.getNotifications();
      _unreadCount = await _storageService.getUnreadCount();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNotification(String message, String type, {int? targetId}) async {
    await _storageService.addNotification(message, type, targetId: targetId);
    await loadNotifications();
  }

  Future<void> markAsRead(int notificationId) async {
    await _storageService.markNotificationAsRead(notificationId);
    await loadNotifications();
  }

  Future<void> markAllAsRead() async {
    for (final notification in _notifications) {
      if (notification['read'] == false) {
        await _storageService.markNotificationAsRead(notification['id']);
      }
    }
    await loadNotifications();
  }

  Future<void> clearAll() async {
    await _storageService.clearNotifications();
    await loadNotifications();
  }
}
