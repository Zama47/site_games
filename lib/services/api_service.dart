import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';
import '../data/games_data_steam.dart';

class ApiService {
  static const String baseUrl = 'https://raw.githubusercontent.com';
  static const String gamesEndpoint = 
      '/flutter-devs/assets/main/games_catalog/games.json';
  
  static const int pageSize = 5;
  
  bool _useLocalData = true;

  Future<List<Game>> fetchGames({int page = 0, int? limit}) async {
    try {
      List<dynamic> jsonData;
      
      if (_useLocalData) {
        // Simulate network delay for loading animation
        await Future.delayed(const Duration(milliseconds: 500));
        jsonData = gamesSteamData;
      } else {
        final response = await http.get(
          Uri.parse(baseUrl + gamesEndpoint),
        );

        if (response.statusCode == 200) {
          jsonData = json.decode(response.body);
        } else {
          throw Exception('Failed to load games: ${response.statusCode}');
        }
      }
      
      // Pagination: return 5 items per page
      final startIndex = page * pageSize;
      final endIndex = startIndex + pageSize;
      
      if (startIndex >= jsonData.length) {
        return []; // No more data
      }
      
      final paginatedData = jsonData.sublist(
        startIndex,
        endIndex > jsonData.length ? jsonData.length : endIndex,
      );
      
      return paginatedData
          .map((json) => Game.fromJson(json))
          .where((game) => !game.isDeleted)
          .toList();
    } catch (e) {
      // Fallback to local data on error with pagination
      final jsonData = gamesSteamData;
      final startIndex = page * pageSize;
      final endIndex = startIndex + pageSize;
      
      if (startIndex >= jsonData.length) {
        return [];
      }
      
      final paginatedData = jsonData.sublist(
        startIndex,
        endIndex > jsonData.length ? jsonData.length : endIndex,
      );
      
      return paginatedData
          .map((json) => Game.fromJson(json))
          .where((game) => !game.isDeleted)
          .toList();
    }
  }

  Future<List<Game>> searchGames(String query) async {
    try {
      List<dynamic> jsonData;
      
      if (_useLocalData) {
        jsonData = gamesSteamData;
      } else {
        final response = await http.get(
          Uri.parse(baseUrl + gamesEndpoint),
        );

        if (response.statusCode == 200) {
          jsonData = json.decode(response.body);
        } else {
          throw Exception('Failed to search games: ${response.statusCode}');
        }
      }
      
      return jsonData
          .map((json) => Game.fromJson(json))
          .where((game) =>
              !game.isDeleted &&
              (game.title.toLowerCase().contains(query.toLowerCase()) ||
                  game.genre.toLowerCase().contains(query.toLowerCase())))
          .toList();
    } catch (e) {
      // Fallback to local data
      final jsonData = gamesSteamData;
      return jsonData
          .map((json) => Game.fromJson(json))
          .where((game) =>
              !game.isDeleted &&
              (game.title.toLowerCase().contains(query.toLowerCase()) ||
                  game.genre.toLowerCase().contains(query.toLowerCase())))
          .toList();
    }
  }

  Future<List<Game>> fetchAllGames() async {
    try {
      List<dynamic> jsonData;
      
      if (_useLocalData) {
        jsonData = gamesSteamData;
      } else {
        final response = await http.get(
          Uri.parse(baseUrl + gamesEndpoint),
        );

        if (response.statusCode == 200) {
          jsonData = json.decode(response.body);
        } else {
          throw Exception('Failed to load all games: ${response.statusCode}');
        }
      }
      
      return jsonData
          .map((json) => Game.fromJson(json))
          .where((game) => !game.isDeleted)
          .toList();
    } catch (e) {
      // Fallback to local data
      final jsonData = gamesSteamData;
      return jsonData
          .map((json) => Game.fromJson(json))
          .where((game) => !game.isDeleted)
          .toList();
    }
  }
}
