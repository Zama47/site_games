import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/game.dart';
import '../providers/games_provider.dart';
import '../providers/auth_provider.dart';
import '../styles/app_styles.dart';
import 'game_form_screen.dart';

class GameDetailScreen extends StatelessWidget {
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: game.imageUrl,
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.image_not_supported, size: 50, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            actions: [
              if (isAdmin)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GameFormScreen(game: game),
                      ),
                    );
                  },
                ),
              if (isAdmin)
                IconButton(
                  icon: const Icon(Icons.delete, color: AppStyles.errorColor),
                  onPressed: () => _showDeleteConfirmation(context),
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppStyles.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          game.title,
                          style: AppStyles.headlineStyle,
                        ),
                      ),
                      if (!isAdmin)
                        Consumer<GamesProvider>(
                          builder: (context, gamesProvider, child) {
                            return FutureBuilder<bool>(
                              future: gamesProvider.isFavorite(game.id),
                              builder: (context, snapshot) {
                                final isFavorite = snapshot.data ?? false;
                                return IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite
                                        ? AppStyles.accentColor
                                        : null,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    gamesProvider.toggleFavorite(game.id);
                                  },
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: AppStyles.paddingSmall),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppStyles.paddingMedium,
                          vertical: AppStyles.paddingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: AppStyles.primaryColor.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppStyles.radiusSmall),
                        ),
                        child: Text(
                          game.genre,
                          style: AppStyles.bodyStyle(context).copyWith(
                            color: AppStyles.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppStyles.paddingSmall),
                      if (game.isFree)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppStyles.paddingMedium,
                            vertical: AppStyles.paddingSmall,
                          ),
                          decoration: BoxDecoration(
                            color: AppStyles.successColor.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppStyles.radiusSmall),
                          ),
                          child: const Text(
                            'Бесплатно',
                            style: TextStyle(
                              color: AppStyles.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppStyles.paddingLarge),
                  _buildInfoRow(
                    icon: Icons.star,
                    label: 'Рейтинг',
                    value: '${game.rating.toStringAsFixed(1)} / 10',
                    valueColor: Colors.amber,
                  ),
                  _buildInfoRow(
                    icon: Icons.business,
                    label: 'Разработчик',
                    value: game.developer,
                  ),
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Дата выхода',
                    value: DateFormat('dd MMMM yyyy', 'ru').format(game.releaseDate),
                  ),
                  _buildInfoRow(
                    icon: Icons.info,
                    label: 'Статус',
                    value: game.status,
                  ),
                  const SizedBox(height: AppStyles.paddingLarge),
                  Text(
                    'Описание',
                    style: AppStyles.subtitleStyle(context),
                  ),
                  const SizedBox(height: AppStyles.paddingSmall),
                  Text(
                    game.description,
                    style: AppStyles.bodyStyle(context).copyWith(
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppStyles.paddingLarge),
                  Text(
                    'Платформы',
                    style: AppStyles.subtitleStyle(context),
                  ),
                  const SizedBox(height: AppStyles.paddingSmall),
                  Wrap(
                    spacing: AppStyles.paddingSmall,
                    runSpacing: AppStyles.paddingSmall,
                    children: game.platforms.map((platform) {
                      return Chip(
                        label: Text(platform),
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      );
                    }).toList(),
                  ),
                  if (!isAdmin) ...[
                    const SizedBox(height: AppStyles.paddingLarge),
                    Text(
                      'Ваша оценка',
                      style: AppStyles.subtitleStyle(context),
                    ),
                    const SizedBox(height: AppStyles.paddingSmall),
                    Consumer<GamesProvider>(
                      builder: (context, gamesProvider, child) {
                        return FutureBuilder<double?>(
                          future: gamesProvider.getGameRating(game.id),
                          builder: (context, snapshot) {
                            final userRating = snapshot.data;
                            return Row(
                              children: [
                                ...List.generate(5, (index) {
                                  return IconButton(
                                    icon: Icon(
                                      index < (userRating ?? 0) / 2
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      final rating = (index + 1) * 2.0;
                                      gamesProvider.rateGame(game.id, rating);
                                    },
                                  );
                                }),
                                if (userRating != null)
                                  Text(
                                    '${userRating.toStringAsFixed(0)}/10',
                                    style: AppStyles.bodyStyle(context),
                                  ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: AppStyles.paddingLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppStyles.paddingMedium),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppStyles.textLightColor),
          const SizedBox(width: AppStyles.paddingMedium),
          Text(
            '$label: ',
            style: AppStyles.bodyStyle(context).copyWith(
              color: AppStyles.textLightColor,
            ),
          ),
          Text(
            value,
            style: AppStyles.bodyStyle(context).copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить игру?'),
        content: Text('Игра "${game.title}" будет перемещена в корзину.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GamesProvider>().deleteGame(game.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Игра перемещена в корзину')),
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
}
