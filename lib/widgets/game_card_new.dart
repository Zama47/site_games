import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/game.dart';
import '../styles/app_styles.dart';
import '../screens/game_detail_screen_new.dart';

class GameCardNew extends StatelessWidget {
  final Game game;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;
  final bool showEditButton;
  final VoidCallback? onEdit;

  const GameCardNew({
    super.key,
    required this.game,
    this.onFavoriteToggle,
    this.isFavorite = false,
    this.showEditButton = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppStyles.marginMedium,
        vertical: AppStyles.marginSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppStyles.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppStyles.radiusLarge),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return GameDetailScreenNew(game: game);
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  Hero(
                    tag: 'game_image_${game.id}',
                    child: CachedNetworkImage(
                      imageUrl: game.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                      placeholder: (context, url) => Container(
                        height: 200,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.videogame_asset, size: 60, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                  // Gradient overlay at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        ),
                      ),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.amber, Colors.orange]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            game.rating.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Genre chip at bottom
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppStyles.primaryColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        game.genre,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  // Free badge
                  if (game.isFree)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppStyles.successColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: AppStyles.successColor.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: const Text(
                          'БЕСПЛАТНО',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(AppStyles.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            game.title,
                            style: AppStyles.titleStyle(context).copyWith(
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (onFavoriteToggle != null)
                          IconButton(
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                key: ValueKey<bool>(isFavorite),
                                color: isFavorite ? AppStyles.accentColor : Colors.grey,
                              ),
                            ),
                            onPressed: onFavoriteToggle,
                          ),
                        if (showEditButton && onEdit != null)
                          IconButton(
                            icon: const Icon(Icons.edit, color: AppStyles.primaryColor),
                            onPressed: onEdit,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppStyles.paddingSmall),
                    Row(
                      children: [
                        Icon(Icons.business, size: 16, color: AppStyles.textLightColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            game.developer,
                            style: AppStyles.captionStyle(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatDate(game.releaseDate),
                          style: AppStyles.captionStyle(context).copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
