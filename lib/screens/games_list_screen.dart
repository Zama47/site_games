import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/games_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notifications_provider.dart';
import '../styles/app_styles.dart';
import '../widgets/app_drawer.dart';
import '../widgets/game_card_new.dart';
import '../models/game.dart';
import 'game_form_screen.dart';
import 'notifications_screen.dart';

class GamesListScreen extends StatefulWidget {
  const GamesListScreen({super.key});

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Force refresh to load updated game data with screenshots
      context.read<GamesProvider>().loadGames(refresh: true);
      context.read<NotificationsProvider>().loadNotifications();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // All games loaded at once - no pagination needed
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог игр'),
        actions: [
          if (isAdmin)
            Consumer<NotificationsProvider>(
              builder: (context, notifications, child) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    if (notifications.unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppStyles.accentColor,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            notifications.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppStyles.paddingMedium),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск игр...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<GamesProvider>().setSearchQuery('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                context.read<GamesProvider>().setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<GamesProvider>(
              builder: (context, gamesProvider, child) {
                if (gamesProvider.isLoading && gamesProvider.games.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (gamesProvider.error != null && gamesProvider.games.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppStyles.errorColor,
                        ),
                        const SizedBox(height: AppStyles.paddingMedium),
                        Text(
                          'Ошибка загрузки',
                          style: AppStyles.subtitleStyle(context),
                        ),
                        const SizedBox(height: AppStyles.paddingSmall),
                        Text(
                          gamesProvider.error!,
                          style: AppStyles.captionStyle(context),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppStyles.paddingLarge),
                        ElevatedButton(
                          onPressed: () {
                            gamesProvider.loadGames(refresh: true);
                          },
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                if (gamesProvider.games.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.videogame_asset_off,
                          size: 64,
                          color: AppStyles.textLightColor,
                        ),
                        const SizedBox(height: AppStyles.paddingMedium),
                        Text(
                          'Игры не найдены',
                          style: AppStyles.subtitleStyle(context).copyWith(
                            color: AppStyles.textLightColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: gamesProvider.games.length + (gamesProvider.hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Load more button at the end
                    if (index == gamesProvider.games.length) {
                      return Padding(
                        padding: const EdgeInsets.all(AppStyles.paddingMedium),
                        child: gamesProvider.isLoadingMore
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton.icon(
                                onPressed: () {
                                  gamesProvider.loadMore();
                                },
                                icon: const Icon(Icons.expand_more),
                                label: const Text('Загрузить еще'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                              ),
                      );
                    }
                    
                    final game = gamesProvider.games[index];
                    return FutureBuilder<bool>(
                      future: gamesProvider.isFavorite(game.id),
                      builder: (context, snapshot) {
                        final isFavorite = snapshot.data ?? false;
                        return GameCardNew(
                          game: game,
                          isFavorite: isFavorite,
                          onFavoriteToggle: !isAdmin
                              ? () => gamesProvider.toggleFavorite(game.id)
                              : null,
                          showEditButton: isAdmin,
                          onEdit: isAdmin
                              ? () => _navigateToEdit(context, game)
                              : null,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppStyles.radiusLarge),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(AppStyles.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppStyles.paddingLarge),
                    Text(
                      'Фильтры',
                      style: AppStyles.headlineStyle(context),
                    ),
                    const SizedBox(height: AppStyles.paddingLarge),
                    Text(
                      'Жанры (выберите несколько)',
                      style: AppStyles.subtitleStyle(context),
                    ),
                    const SizedBox(height: AppStyles.paddingSmall),
                    Consumer<GamesProvider>(
                      builder: (context, gamesProvider, child) {
                        return Wrap(
                          spacing: AppStyles.paddingSmall,
                          runSpacing: AppStyles.paddingSmall,
                          children: Game.availableGenres.map((genre) {
                            final isSelected =
                                gamesProvider.selectedGenres.contains(genre);
                            return FilterChip(
                              label: Text(genre),
                              selected: isSelected,
                              onSelected: (selected) {
                                final newGenres =
                                    List<String>.from(gamesProvider.selectedGenres);
                                if (selected) {
                                  newGenres.add(genre);
                                } else {
                                  newGenres.remove(genre);
                                }
                                gamesProvider.setGenreFilter(newGenres);
                              },
                              selectedColor: AppStyles.primaryColor.withOpacity(0.2),
                              checkmarkColor: AppStyles.primaryColor,
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: AppStyles.paddingLarge),
                    Text(
                      'Сортировка (выберите одну)',
                      style: AppStyles.subtitleStyle(context),
                    ),
                    const SizedBox(height: AppStyles.paddingSmall),
                    Consumer<GamesProvider>(
                      builder: (context, gamesProvider, child) {
                        return Column(
                          children: [
                            RadioListTile<String>(
                              title: const Text('По дате выхода (новые)'),
                              value: 'date',
                              groupValue: gamesProvider.sortBy,
                              onChanged: (value) {
                                if (value != null) {
                                  gamesProvider.setSortBy(value);
                                }
                              },
                              activeColor: AppStyles.primaryColor,
                            ),
                            RadioListTile<String>(
                              title: const Text('По рейтингу (высокий)'),
                              value: 'rating',
                              groupValue: gamesProvider.sortBy,
                              onChanged: (value) {
                                if (value != null) {
                                  gamesProvider.setSortBy(value);
                                }
                              },
                              activeColor: AppStyles.primaryColor,
                            ),
                            RadioListTile<String>(
                              title: const Text('По алфавиту'),
                              value: 'alphabet',
                              groupValue: gamesProvider.sortBy,
                              onChanged: (value) {
                                if (value != null) {
                                  gamesProvider.setSortBy(value);
                                }
                              },
                              activeColor: AppStyles.primaryColor,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppStyles.paddingLarge),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<GamesProvider>().setGenreFilter([]);
                          context.read<GamesProvider>().setSortBy('date');
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.textLightColor,
                        ),
                        child: const Text('Сбросить фильтры'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToEdit(BuildContext context, Game game) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameFormScreen(game: game),
      ),
    );
  }
}
