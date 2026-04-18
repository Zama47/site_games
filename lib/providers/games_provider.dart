import 'package:flutter/foundation.dart';
import '../models/game.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class GamesProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  List<Game> _games = [];
  List<Game> _filteredGames = [];
  List<Game> _favoriteGames = [];
  List<Map<String, dynamic>> _deletedGames = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 0;
  bool _hasMoreData = true;

  // Filters
  List<String> _selectedGenres = [];
  String _sortBy = 'date'; // date, rating, alphabet
  String _searchQuery = '';

  List<Game> get games => _filteredGames;
  List<Game> get favoriteGames => _favoriteGames;
  List<Map<String, dynamic>> get deletedGames => _deletedGames;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMoreData => _hasMoreData;

  List<String> get selectedGenres => _selectedGenres;
  String get sortBy => _sortBy;

  Future<void> loadGames({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _games = [];
      _hasMoreData = true;
    }

    if (!_hasMoreData && !refresh) return;

    _isLoading = _currentPage == 0;
    _isLoadingMore = _currentPage > 0;
    _error = null;
    notifyListeners();

    try {
      final newGames = await _apiService.fetchGames(page: _currentPage);

      if (newGames.isEmpty) {
        _hasMoreData = false;
      } else {
        _games.addAll(newGames);
        _currentPage++;
      }

      _applyFiltersAndSort();
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMoreData) return;
    await loadGames();
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final favoriteIds = await _storageService.getFavorites();
      final allGames = await _apiService.fetchAllGames();
      _favoriteGames = allGames
          .where((game) => favoriteIds.contains(game.id))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int gameId) async {
    final isFav = await _storageService.isFavorite(gameId);
    if (isFav) {
      await _storageService.removeFromFavorites(gameId);
    } else {
      await _storageService.addToFavorites(gameId);
      // Add notification for admin
      await _storageService.addNotification(
        'Игра добавлена в избранное пользователем',
        'favorite',
      );
    }
    await loadFavorites();
    notifyListeners();
  }

  Future<bool> isFavorite(int gameId) async {
    return await _storageService.isFavorite(gameId);
  }

  void setGenreFilter(List<String> genres) {
    _selectedGenres = genres;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void _applyFiltersAndSort() {
    _filteredGames = List.from(_games);

    // Apply genre filter
    if (_selectedGenres.isNotEmpty) {
      _filteredGames = _filteredGames
          .where((game) => _selectedGenres.contains(game.genre))
          .toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      _filteredGames = _filteredGames
          .where((game) =>
              game.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              game.genre.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'date':
        _filteredGames.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
        break;
      case 'rating':
        _filteredGames.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'alphabet':
        _filteredGames.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
  }

  // Admin functions
  Future<void> addGame(Game game) async {
    final gameData = game.toJson();
    await _storageService.saveCustomGame(gameData);
    _games.insert(0, game);
    _applyFiltersAndSort();
    notifyListeners();
  }

  Future<void> updateGame(Game game) async {
    final index = _games.indexWhere((g) => g.id == game.id);
    if (index >= 0) {
      _games[index] = game;
      await _storageService.saveCustomGame(game.toJson());
      _applyFiltersAndSort();
      notifyListeners();
    }
  }

  Future<void> deleteGame(int gameId) async {
    final index = _games.indexWhere((g) => g.id == gameId);
    if (index >= 0) {
      final game = _games[index];
      await _storageService.addToTrash(game.toJson());
      _games.removeAt(index);
      _applyFiltersAndSort();
      notifyListeners();
    }
  }

  Future<void> loadDeletedGames() async {
    _deletedGames = await _storageService.getDeletedGames();
    notifyListeners();
  }

  Future<void> restoreGame(int gameId) async {
    await _storageService.restoreFromTrash(gameId);
    await loadDeletedGames();
    await loadGames(refresh: true);
  }

  Future<void> permanentlyDelete(int gameId) async {
    await _storageService.permanentlyDelete(gameId);
    await loadDeletedGames();
  }

  Future<void> rateGame(int gameId, double rating) async {
    await _storageService.setRating(gameId, rating);
    await _storageService.addNotification(
      'Игра получила оценку $rating',
      'rating',
    );
    notifyListeners();
  }

  Future<double?> getGameRating(int gameId) async {
    return await _storageService.getRating(gameId);
  }
}
