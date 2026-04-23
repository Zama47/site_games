import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../services/storage_service.dart';

class OrdersProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Order> _orders = [];
  List<Order> _pendingOrders = [];
  bool _isLoading = false;
  int _pendingCount = 0;

  List<Order> get orders => _orders;
  List<Order> get pendingOrders => _pendingOrders;
  bool get isLoading => _isLoading;
  int get pendingCount => _pendingCount;

  Future<void> loadOrders({String? userId, String? status}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _storageService.getOrders(userId: userId, status: status);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPendingOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _pendingOrders = await _storageService.getOrders(status: 'pending');
      _pendingCount = _pendingOrders.length;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createOrder({
    required int gameId,
    required String userId,
    required String userName,
    required String gameTitle,
    String? comment,
  }) async {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch,
      gameId: gameId,
      userId: userId,
      userName: userName,
      gameTitle: gameTitle,
      comment: comment,
      createdAt: DateTime.now(),
    );

    await _storageService.saveOrder(order);
    
    // Add notification for admin
    await _storageService.addNotification(
      'Новый заказ на игру "$gameTitle" от $userName',
      'order',
      targetId: order.id,
    );
    
    await loadOrders(userId: userId);
  }

  Future<void> approveOrder(int orderId, {String? adminComment}) async {
    await _storageService.updateOrderStatus(orderId, 'approved', adminComment: adminComment);
    
    // Get order details for notification
    final allOrders = await _storageService.getOrders();
    final order = allOrders.firstWhere((o) => o.id == orderId);
    
    // Add notification for user
    await _storageService.addNotification(
      'Ваш заказ на "${order.gameTitle}" одобрен!',
      'order_approved',
      targetId: orderId,
    );
    
    await loadPendingOrders();
  }

  Future<void> rejectOrder(int orderId, {String? adminComment}) async {
    await _storageService.updateOrderStatus(orderId, 'rejected', adminComment: adminComment);
    
    // Get order details for notification
    final allOrders = await _storageService.getOrders();
    final order = allOrders.firstWhere((o) => o.id == orderId);
    
    // Add notification for user
    await _storageService.addNotification(
      'Ваш заказ на "${order.gameTitle}" отклонен',
      'order_rejected',
      targetId: orderId,
    );
    
    await loadPendingOrders();
  }

  Future<void> refreshPendingCount() async {
    _pendingCount = await _storageService.getPendingOrdersCount();
    notifyListeners();
  }
}
