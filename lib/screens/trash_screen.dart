import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/games_provider.dart';
import '../styles/app_styles.dart';
import '../widgets/app_drawer.dart';
import '../models/game.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GamesProvider>().loadDeletedGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        actions: [
          Consumer<GamesProvider>(
            builder: (context, gamesProvider, child) {
              if (gamesProvider.deletedGames.isEmpty) {
                return const SizedBox.shrink();
              }
              return TextButton.icon(
                onPressed: () => _showClearAllConfirmation(context),
                icon: const Icon(Icons.delete_forever, color: Colors.white),
                label: const Text(
                  'Очистить',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<GamesProvider>(
        builder: (context, gamesProvider, child) {
          if (gamesProvider.deletedGames.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delete_outline,
                    size: 80,
                    color: AppStyles.textLightColor,
                  ),
                  const SizedBox(height: AppStyles.paddingLarge),
                  Text(
                    'Корзина пуста',
                    style: AppStyles.subtitleStyle(context).copyWith(
                      color: AppStyles.textLightColor,
                    ),
                  ),
                  const SizedBox(height: AppStyles.paddingSmall),
                  Text(
                    'Удалённые игры появятся здесь',
                    style: AppStyles.captionStyle(context),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: gamesProvider.deletedGames.length,
            itemBuilder: (context, index) {
              final deletedGame = gamesProvider.deletedGames[index];
              final game = Game.fromJson(deletedGame);
              final deletedAt = DateTime.parse(deletedGame['deletedAt']);

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppStyles.marginMedium,
                  vertical: AppStyles.marginSmall,
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
                    child: Image.network(
                      game.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                        width: 60,
                        height: 60,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.image_not_supported, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                  title: Text(
                    game.title,
                    style: AppStyles.subtitleStyle(context),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(game.genre, style: AppStyles.captionStyle(context)),
                      Text(
                        'Удалена: ${_formatDate(deletedAt)}',
                        style: AppStyles.captionStyle(context).copyWith(
                          color: AppStyles.errorColor,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.restore,
                          color: AppStyles.successColor,
                        ),
                        tooltip: 'Восстановить',
                        onPressed: () {
                          gamesProvider.restoreGame(game.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${game.title} восстановлена'),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: AppStyles.errorColor,
                        ),
                        tooltip: 'Удалить навсегда',
                        onPressed: () {
                          _showDeleteConfirmation(context, game);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteConfirmation(BuildContext context, Game game) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить навсегда?'),
        content: Text(
          'Игра "${game.title}" будет безвозвратно удалена. Это действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GamesProvider>().permanentlyDelete(game.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${game.title} удалена навсегда')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.errorColor,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _showClearAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить корзину?'),
        content: const Text(
          'Все игры в корзине будут безвозвратно удалены. Это действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<GamesProvider>();
              for (final game in provider.deletedGames) {
                provider.permanentlyDelete(game['id']);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Корзина очищена')),
              );
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
