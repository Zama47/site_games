import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders_provider.dart';
import '../providers/auth_provider.dart';
import '../styles/app_styles.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) {
        context.read<OrdersProvider>().loadOrders(userId: userId);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заказы'),
      ),
      drawer: const AppDrawer(),
      body: Consumer<OrdersProvider>(
        builder: (context, ordersProvider, child) {
          if (ordersProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (ordersProvider.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_basket_outlined,
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
                    'Заказывайте игры из каталога',
                    style: AppStyles.captionStyle(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: ordersProvider.orders.length,
            padding: const EdgeInsets.all(AppStyles.paddingMedium),
            itemBuilder: (context, index) {
              final order = ordersProvider.orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppStyles.paddingMedium),
                child: ListTile(
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
                        'Статус: ${order.statusText}',
                        style: AppStyles.bodyStyle(context).copyWith(
                          color: _getStatusColor(order.status),
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
                        Text(
                          'Ответ админа: ${order.adminComment}',
                          style: AppStyles.captionStyle(context).copyWith(
                            color: AppStyles.primaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  isThreeLine: order.comment != null || order.adminComment != null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
