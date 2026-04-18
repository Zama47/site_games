import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/game.dart';
import '../providers/games_provider.dart';
import '../providers/auth_provider.dart';
import '../styles/app_styles.dart';
import 'game_form_screen.dart';

class GameDetailScreenNew extends StatefulWidget {
  final Game game;

  const GameDetailScreenNew({super.key, required this.game});

  @override
  State<GameDetailScreenNew> createState() => _GameDetailScreenNewState();
}

class _GameDetailScreenNewState extends State<GameDetailScreenNew>
    with SingleTickerProviderStateMixin {
  int _currentScreenshotIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _launchTrailer() async {
    if (widget.game.trailerUrl.isNotEmpty) {
      final uri = Uri.parse(widget.game.trailerUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final hasTrailer = widget.game.trailerUrl.isNotEmpty;
    final hasScreenshots = widget.game.screenshots.isNotEmpty;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'game_image_${widget.game.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.game.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade800,
                        child: const Icon(
                          Icons.videogame_asset,
                          size: 80,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                widget.game.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              if (hasTrailer)
                IconButton(
                  icon: const Icon(Icons.play_circle_outline),
                  onPressed: _launchTrailer,
                  tooltip: 'Смотреть трейлер',
                ),
              if (isAdmin)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToEdit(context),
                ),
              if (isAdmin)
                IconButton(
                  icon: const Icon(Icons.delete, color: AppStyles.accentColor),
                  onPressed: () => _showDeleteConfirmation(context),
                ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(AppStyles.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Rating Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.game.title,
                                style: AppStyles.headlineStyle.copyWith(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppStyles.paddingSmall),
                              Row(
                                children: [
                                  _buildChip(
                                    widget.game.genre,
                                    AppStyles.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: AppStyles.paddingSmall,
                                  ),
                                  if (widget.game.isFree)
                                    _buildChip(
                                      'Бесплатно',
                                      AppStyles.successColor,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Rating Badge
                        Container(
                          padding: const EdgeInsets.all(AppStyles.paddingMedium),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.amber, Colors.orange],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppStyles.radiusMedium,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 24,
                              ),
                              Text(
                                widget.game.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppStyles.paddingLarge),

                    // Info Cards Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildInfoCard(
                            Icons.calendar_today,
                            'Дата выхода',
                            DateFormat('dd.MM.yyyy').format(
                              widget.game.releaseDate,
                            ),
                          ),
                          const SizedBox(width: AppStyles.paddingMedium),
                          _buildInfoCard(
                            Icons.business,
                            'Разработчик',
                            widget.game.developer,
                          ),
                          const SizedBox(width: AppStyles.paddingMedium),
                          _buildInfoCard(
                            Icons.info,
                            'Статус',
                            widget.game.status,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppStyles.paddingLarge),

                    // YouTube Trailer
                    if (hasTrailer) ...[
                      _buildSectionTitle('Трейлер'),
                      const SizedBox(height: AppStyles.paddingMedium),
                      InkWell(
                        onTap: _launchTrailer,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFCC0000), Color(0xFF990000)],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppStyles.radiusMedium,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppStyles.radiusMedium,
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Thumbnail
                                CachedNetworkImage(
                                  imageUrl: widget.game.imageUrl,
                                  fit: BoxFit.cover,
                                  color: Colors.black.withOpacity(0.3),
                                  colorBlendMode: BlendMode.darken,
                                ),
                                // Play button
                                Center(
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Color(0xFFCC0000),
                                      size: 40,
                                    ),
                                  ),
                                ),
                                // YouTube logo
                                Positioned(
                                  top: 16,
                                  left: 16,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFCC0000),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.play_circle_filled,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'YouTube',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Open in browser hint
                                Positioned(
                                  bottom: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.open_in_new,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Открыть',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                    ],

                    // Screenshots Carousel
                    if (hasScreenshots) ...[
                      _buildSectionTitle('Скриншоты'),
                      const SizedBox(height: AppStyles.paddingMedium),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 280,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 4),
                          viewportFraction: 0.9,
                          enlargeFactor: 0.25,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentScreenshotIndex = index;
                            });
                          },
                        ),
                        items: widget.game.screenshots.map((screenshot) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: AppStyles.paddingSmall,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(
                                    AppStyles.radiusMedium,
                                  ),
                                  boxShadow: AppStyles.cardShadow,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppStyles.radiusMedium,
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: CachedNetworkImage(
                                      imageUrl: screenshot,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey.shade900,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors.grey.shade900,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppStyles.paddingSmall),
                      // Carousel indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.game.screenshots.asMap().entries.map(
                          (entry) {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentScreenshotIndex == entry.key
                                    ? AppStyles.primaryColor
                                    : Colors.grey.shade300,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(height: AppStyles.paddingLarge),
                    ],

                    // Description
                    _buildSectionTitle('Описание'),
                    const SizedBox(height: AppStyles.paddingMedium),
                    Container(
                      padding: const EdgeInsets.all(AppStyles.paddingLarge),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppStyles.radiusMedium,
                        ),
                        boxShadow: AppStyles.cardShadow,
                      ),
                      child: Text(
                        widget.game.description,
                        style: AppStyles.bodyStyle.copyWith(
                          height: 1.6,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppStyles.paddingLarge),

                    // Platforms
                    _buildSectionTitle('Платформы'),
                    const SizedBox(height: AppStyles.paddingMedium),
                    Wrap(
                      spacing: AppStyles.paddingSmall,
                      runSpacing: AppStyles.paddingSmall,
                      children: widget.game.platforms.map((platform) {
                        return Chip(
                          avatar: Icon(
                            _getPlatformIcon(platform),
                            size: 18,
                            color: AppStyles.primaryColor,
                          ),
                          label: Text(platform),
                          backgroundColor: AppStyles.primaryColor.withOpacity(
                            0.1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppStyles.radiusSmall,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // User Rating Section (for Gamers)
                    if (!isAdmin) ...[
                      const SizedBox(height: AppStyles.paddingLarge * 2),
                      _buildSectionTitle('Ваша оценка'),
                      const SizedBox(height: AppStyles.paddingMedium),
                      Consumer<GamesProvider>(
                        builder: (context, gamesProvider, child) {
                          return FutureBuilder<double?>(
                            future: gamesProvider.getGameRating(widget.game.id),
                            builder: (context, snapshot) {
                              final userRating = snapshot.data;
                              return Container(
                                padding: const EdgeInsets.all(
                                  AppStyles.paddingLarge,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppStyles.primaryColor.withOpacity(0.1),
                                      AppStyles.secondaryColor.withOpacity(
                                        0.1,
                                      ),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppStyles.radiusMedium,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(5, (index) {
                                        return IconButton(
                                          icon: Icon(
                                            index < (userRating ?? 0) / 2
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 40,
                                          ),
                                          onPressed: () {
                                            final rating = (index + 1) * 2.0;
                                            gamesProvider.rateGame(
                                              widget.game.id,
                                              rating,
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Вы поставили оценку ${rating.toInt()}/10',
                                                ),
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                    ),
                                    if (userRating != null)
                                      Text(
                                        'Ваша оценка: ${userRating.toInt()}/10',
                                        style: AppStyles.subtitleStyle.copyWith(
                                          color: AppStyles.primaryColor,
                                        ),
                                      ),
                                  ],
                                ),
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
          ),
        ],
      ),
      floatingActionButton: !isAdmin
          ? Consumer<GamesProvider>(
              builder: (context, gamesProvider, child) {
                return FutureBuilder<bool>(
                  future: gamesProvider.isFavorite(widget.game.id),
                  builder: (context, snapshot) {
                    final isFavorite = snapshot.data ?? false;
                    return FloatingActionButton.extended(
                      onPressed: () {
                        gamesProvider.toggleFavorite(widget.game.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFavorite
                                  ? 'Удалено из избранного'
                                  : 'Добавлено в избранное',
                            ),
                            action: SnackBarAction(
                              label: 'Отмена',
                              onPressed: () {
                                gamesProvider.toggleFavorite(widget.game.id);
                              },
                            ),
                          ),
                        );
                      },
                      backgroundColor:
                          isFavorite ? AppStyles.accentColor : Colors.white,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.white : AppStyles.accentColor,
                      ),
                      label: Text(
                        isFavorite ? 'В избранном' : 'В избранное',
                        style: TextStyle(
                          color:
                              isFavorite ? Colors.white : AppStyles.accentColor,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : null,
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppStyles.paddingMedium,
        vertical: AppStyles.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppStyles.primaryColor, size: 28),
          const SizedBox(height: AppStyles.paddingSmall),
          Text(
            label,
            style: AppStyles.captionStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppStyles.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: AppStyles.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppStyles.paddingSmall),
        Text(
          title,
          style: AppStyles.titleStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'pc':
        return Icons.computer;
      case 'playstation':
        return Icons.gamepad;
      case 'xbox':
        return Icons.sports_esports;
      case 'nintendo switch':
        return Icons.videogame_asset;
      case 'mobile':
        return Icons.smartphone;
      case 'vr':
        return Icons.visibility;
      default:
        return Icons.devices;
    }
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameFormScreen(game: widget.game),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
        ),
        title: const Text('Удалить игру?'),
        content: Text(
          'Игра "${widget.game.title}" будет перемещена в корзину.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GamesProvider>().deleteGame(widget.game.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Игра перемещена в корзину'),
                ),
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
