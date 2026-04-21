import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notifications_provider.dart';
import '../providers/theme_provider.dart';
import '../styles/app_styles.dart';
import '../screens/games_list_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/trash_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/game_form_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.isAdmin;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppStyles.primaryGradient,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                isAdmin ? Icons.admin_panel_settings : Icons.person,
                color: AppStyles.primaryColor,
                size: 40,
              ),
            ),
            accountName: Text(
              authProvider.user?.displayName ?? 'Пользователь',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              isAdmin ? 'Администратор' : 'Игрок',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.home,
                  title: 'Главная',
                  onTap: () => _navigateTo(context, const GamesListScreen()),
                ),
                if (!isAdmin)
                  _buildMenuItem(
                    context,
                    icon: Icons.favorite,
                    title: 'Избранное',
                    onTap: () => _navigateTo(context, const FavoritesScreen()),
                  ),
                if (isAdmin) ...[
                  _buildMenuItem(
                    context,
                    icon: Icons.add_circle,
                    title: 'Добавить игру',
                    onTap: () => _navigateTo(
                      context,
                      const GameFormScreen(),
                    ),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.delete_outline,
                    title: 'Корзина',
                    onTap: () => _navigateTo(context, const TrashScreen()),
                  ),
                  _buildMenuItemWithBadge(
                    context,
                    icon: Icons.notifications,
                    title: 'Уведомления',
                    onTap: () => _navigateTo(
                      context,
                      const NotificationsScreen(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                leading: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: AppStyles.primaryColor,
                ),
                title: Text(themeProvider.isDarkMode ? 'Светлая тема' : 'Темная тема'),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) => themeProvider.toggleTheme(),
                  activeColor: AppStyles.primaryColor,
                ),
                onTap: () => themeProvider.toggleTheme(),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: AppStyles.errorColor),
            title: const Text(
              'Выход',
              style: TextStyle(color: AppStyles.errorColor),
            ),
            onTap: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const GamesListScreen()),
                  (route) => false,
                );
              }
            },
          ),
          const SizedBox(height: AppStyles.paddingMedium),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppStyles.primaryColor),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }

  Widget _buildMenuItemWithBadge(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Consumer<NotificationsProvider>(
      builder: (context, notificationsProvider, child) {
        final unreadCount = notificationsProvider.unreadCount;
        return ListTile(
          leading: Icon(icon, color: AppStyles.primaryColor),
          title: Text(title),
          trailing: unreadCount > 0
              ? Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppStyles.accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
          onTap: () {
            Navigator.of(context).pop();
            onTap();
          },
        );
      },
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
