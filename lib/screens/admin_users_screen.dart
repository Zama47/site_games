import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/storage_service.dart';
import '../styles/app_styles.dart';
import '../widgets/app_drawer.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final StorageService _storageService = StorageService();
  List<String> _blockedUsers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    setState(() => _isLoading = true);
    final blocked = await _storageService.getBlockedUsers();
    setState(() {
      _blockedUsers = blocked;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final users = User.defaultUsers.where((u) => !u.isAdmin).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление пользователями'),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              padding: const EdgeInsets.all(AppStyles.paddingMedium),
              itemBuilder: (context, index) {
                final user = users[index];
                final isBlocked = _blockedUsers.contains(user.id);

                return Card(
                  margin: const EdgeInsets.only(bottom: AppStyles.paddingMedium),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppStyles.paddingMedium),
                    leading: CircleAvatar(
                      backgroundColor: isBlocked
                          ? AppStyles.errorColor.withOpacity(0.1)
                          : AppStyles.successColor.withOpacity(0.1),
                      child: Icon(
                        isBlocked ? Icons.block : Icons.person,
                        color: isBlocked ? AppStyles.errorColor : AppStyles.successColor,
                      ),
                    ),
                    title: Text(
                      user.displayName,
                      style: AppStyles.subtitleStyle(context),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Логин: ${user.username}',
                          style: AppStyles.bodyStyle(context),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isBlocked
                                ? AppStyles.errorColor.withOpacity(0.1)
                                : AppStyles.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isBlocked ? 'Заблокирован' : 'Активен',
                            style: AppStyles.captionStyle(context).copyWith(
                              color: isBlocked ? AppStyles.errorColor : AppStyles.successColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: isBlocked
                        ? ElevatedButton.icon(
                            onPressed: () => _unblockUser(user.id, user.displayName),
                            icon: const Icon(Icons.check_circle, size: 18),
                            label: const Text('Разблокировать'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.successColor,
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () => _blockUser(user.id, user.displayName),
                            icon: const Icon(Icons.block, size: 18),
                            label: const Text('Заблокировать'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.errorColor,
                            ),
                          ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _blockUser(String userId, String userName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Заблокировать пользователя?'),
        content: Text(
          'Пользователь "$userName" будет заблокирован и не сможет войти в приложение.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.errorColor,
            ),
            child: const Text('Заблокировать'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.blockUser(userId);
      await _loadBlockedUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Пользователь $userName заблокирован')),
        );
      }
    }
  }

  Future<void> _unblockUser(String userId, String userName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Разблокировать пользователя?'),
        content: Text(
          'Пользователь "$userName" будет разблокирован и сможет снова войти в приложение.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.successColor,
            ),
            child: const Text('Разблокировать'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.unblockUser(userId);
      await _loadBlockedUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Пользователь $userName разблокирован')),
        );
      }
    }
  }
}
