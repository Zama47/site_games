import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/games_provider.dart';
import '../styles/app_styles.dart';
import '../widgets/app_drawer.dart';
import '../widgets/game_card_new.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GamesProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      drawer: const AppDrawer(),
      body: Consumer<GamesProvider>(
        builder: (context, gamesProvider, child) {
          if (gamesProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (gamesProvider.favoriteGames.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: AppStyles.textLightColor,
                  ),
                  const SizedBox(height: AppStyles.paddingLarge),
                  Text(
                    'Нет избранных игр',
                    style: AppStyles.subtitleStyle.copyWith(
                      color: AppStyles.textLightColor,
                    ),
                  ),
                  const SizedBox(height: AppStyles.paddingSmall),
                  Text(
                    'Добавляйте игры в избранное,\nнажимая на сердечко',
                    style: AppStyles.captionStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: gamesProvider.favoriteGames.length,
            itemBuilder: (context, index) {
              final game = gamesProvider.favoriteGames[index];
              return Dismissible(
                key: Key(game.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(
                    right: AppStyles.paddingLarge,
                  ),
                  color: AppStyles.errorColor,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Удалить',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                onDismissed: (direction) {
                  gamesProvider.toggleFavorite(game.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${game.title} удалена из избранного'),
                      action: SnackBarAction(
                        label: 'Отмена',
                        onPressed: () {
                          gamesProvider.toggleFavorite(game.id);
                        },
                      ),
                    ),
                  );
                },
                child: GameCardNew(
                  game: game,
                  isFavorite: true,
                  onFavoriteToggle: () => gamesProvider.toggleFavorite(game.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
