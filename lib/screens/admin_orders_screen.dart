import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders_provider.dart';
import '../styles/app_styles.dart';
import '../widgets/app_drawer.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String _filterStatus = 'pending';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().loadPendingOrders();
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return AppStyles.successColor;
      case 'rejected':
        return AppStyles.errorColor;
      default:
        return AppStyles.textLightColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  void _loadOrders() {
    if (_filterStatus == 'pending') {
      context.read<OrdersProvider>().loadPendingOrders();
    } else {
      context.read<OrdersProvider>().loadOrders(status: _filterStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Модерация заказов'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _filterStatus,
            onSelected: (value) {
              setState(() {
                _filterStatus = value;
              });
              _loadOrders();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pending',
                child: Text('На рассмотрении'),
              ),
              const PopupMenuItem(
                value: 'approved',
                child: Text('Одобренные'),
              ),
              const PopupMenuItem(
                value: 'rejected',
                child: Text('Отклоненные'),
              ),
              const PopupMenuItem(
                value: 'all',
                child: Text('Все'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    _filterStatus == 'pending'
                        ? 'На рассмотрении'
                        : _filterStatus == 'approved'
                            ? 'Одобренные'
                            : _filterStatus == 'rejected'
                                ? 'Отклоненные'
                                : 'Все',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<OrdersProvider>(
        builder: (context, ordersProvider, child) {
          final orders = _filterStatus == 'all'
              ? ordersProvider.orders
              : ordersProvider.orders;

          if (ordersProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inbox_outlined,
                    size: 80,
                    color: AppStyles.textLightColor,
                  ),
                  const SizedBox(height: AppStyles.paddingLarge),
                  Text(
                    'Нет заказов',
                    style: AppStyles.subtitleStyle(context).copyWith(
                      color: AppStyles.textLightColor,
                    ),
                  ),
                  const SizedBox(height: AppStyles.paddingSmall),
                  Text(
                    'Заказы с выбранным статусом отсутствуют',
                    style: AppStyles.captionStyle(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadOrders();
            },
            child: ListView.builder(
              itemCount: orders.length,
              padding: const EdgeInsets.all(AppStyles.paddingMedium),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppStyles.paddingMedium),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(AppStyles.paddingMedium),
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(order.status).withOpacity(0.1),
                          child: Icon(
                            _getStatusIcon(order.status),
                            color: _getStatusColor(order.status),
                          ),
                        ),
                        title: Text(
                          order.gameTitle,
                          style: AppStyles.subtitleStyle(context),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'От: ${order.userName}',
                              style: AppStyles.bodyStyle(context).copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Дата: ${_formatDate(order.createdAt)}',
                              style: AppStyles.captionStyle(context),
                            ),
                            if (order.comment != null && order.comment!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Комментарий: ${order.comment}',
                                style: AppStyles.captionStyle(context),
                              ),
                            ],
                            if (order.adminComment != null && order.adminComment!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppStyles.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Ответ: ${order.adminComment}',
                                  style: AppStyles.captionStyle(context).copyWith(
                                    color: AppStyles.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        isThreeLine: true,
                      ),
                      if (order.isPending)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppStyles.paddingMedium,
                            0,
                            AppStyles.paddingMedium,
                            AppStyles.paddingMedium,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showApproveDialog(context, order.id);
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text('Одобрить'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyles.successColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppStyles.paddingMedium),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showRejectDialog(context, order.id);
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text('Отклонить'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyles.errorColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showApproveDialog(BuildContext context, int orderId) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Одобрить заказ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Заказ будет одобрен. Можно добавить комментарий:'),
            const SizedBox(height: AppStyles.paddingMedium),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                labelText: 'Комментарий (необязательно)',
                hintText: 'Например: Игра доступна для скачивания',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<OrdersProvider>().approveOrder(
                orderId,
                adminComment: commentController.text.isNotEmpty
                    ? commentController.text
                    : null,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Заказ одобрен')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.successColor,
            ),
            child: const Text('Одобрить'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, int orderId) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отклонить заказ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Заказ будет отклонен. Рекомендуется добавить причину:'),
            const SizedBox(height: AppStyles.paddingMedium),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                labelText: 'Причина отклонения',
                hintText: 'Например: Игра временно недоступна',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<OrdersProvider>().rejectOrder(
                orderId,
                adminComment: commentController.text.isNotEmpty
                    ? commentController.text
                    : null,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Заказ отклонен')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.errorColor,
            ),
            child: const Text('Отклонить'),
          ),
        ],
      ),
    );
  }
}
