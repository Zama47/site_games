import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/notifications_provider.dart';
import '../styles/app_styles.dart';
import '../widgets/app_drawer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
        actions: [
          Consumer<NotificationsProvider>(
            builder: (context, notifications, child) {
              if (notifications.notifications.isEmpty) {
                return const SizedBox.shrink();
              }
              return TextButton.icon(
                onPressed: () {
                  notifications.markAllAsRead();
                },
                icon: const Icon(Icons.done_all, color: Colors.white),
                label: const Text(
                  'Все прочитаны',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => _showClearConfirmation(context),
            tooltip: 'Очистить все',
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<NotificationsProvider>(
        builder: (context, notifications, child) {
          if (notifications.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (notifications.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: AppStyles.textLightColor,
                  ),
                  const SizedBox(height: AppStyles.paddingLarge),
                  Text(
                    'Нет уведомлений',
                    style: AppStyles.subtitleStyle.copyWith(
                      color: AppStyles.textLightColor,
                    ),
                  ),
                  const SizedBox(height: AppStyles.paddingSmall),
                  Text(
                    'Здесь будут появляться уведомления\nо действиях игроков',
                    style: AppStyles.captionStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications.notifications[index];
              final isRead = notification['read'] as bool;
              final timestamp = DateTime.parse(notification['timestamp']);
              final type = notification['type'] as String;

              return Dismissible(
                key: Key(notification['id'].toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(
                    right: AppStyles.paddingLarge,
                  ),
                  color: AppStyles.errorColor,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  // Note: Individual delete not implemented in provider
                  // This is just for UI demonstration
                },
                child: ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isRead
                          ? Colors.grey.shade200
                          : AppStyles.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForType(type),
                      color: isRead ? AppStyles.textLightColor : AppStyles.primaryColor,
                    ),
                  ),
                  title: Text(
                    notification['message'] as String,
                    style: AppStyles.bodyStyle.copyWith(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    _formatTimestamp(timestamp),
                    style: AppStyles.captionStyle,
                  ),
                  trailing: isRead
                      ? null
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppStyles.accentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                  onTap: () {
                    if (!isRead) {
                      notifications.markAsRead(notification['id'] as int);
                    }
                  },
                  tileColor: isRead ? null : AppStyles.primaryColor.withOpacity(0.05),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'favorite':
        return Icons.favorite;
      case 'rating':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('dd.MM.yyyy HH:mm').format(timestamp);
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить уведомления?'),
        content: const Text('Все уведомления будут удалены.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<NotificationsProvider>().clearAll();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.errorColor,
            ),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }
}
