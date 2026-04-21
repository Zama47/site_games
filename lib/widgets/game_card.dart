import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/game.dart';
import '../styles/app_styles.dart';
import '../screens/game_detail_screen.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;
  final bool showEditButton;
  final VoidCallback? onEdit;

  const GameCard({
    super.key,
    required this.game,
    this.onFavoriteToggle,
    this.isFavorite = false,
    this.showEditButton = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppStyles.marginMedium,
        vertical: AppStyles.marginSmall,
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GameDetailScreen(game: game),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppStyles.radiusMedium),
              ),
              child: CachedNetworkImage(
                imageUrl: game.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 150,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 150,
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppStyles.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          game.title,
                          style: AppStyles.subtitleStyle(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onFavoriteToggle != null)
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? AppStyles.accentColor : null,
                          ),
                          onPressed: onFavoriteToggle,
                        ),
                      if (showEditButton && onEdit != null)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: onEdit,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppStyles.paddingSmall),
                  Text(
                    game.genre,
                    style: AppStyles.captionStyle(context).copyWith(
                      color: AppStyles.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppStyles.paddingSmall),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        game.rating.toStringAsFixed(1),
                        style: AppStyles.bodyStyle(context).copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(game.releaseDate),
                        style: AppStyles.captionStyle(context),
                      ),
                    ],
                  ),
                  if (game.isFree)
                    Container(
                      margin: const EdgeInsets.only(top: AppStyles.paddingSmall),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppStyles.paddingSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppStyles.successColor,
                        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
                      ),
                      child: const Text(
                        'Бесплатно',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
