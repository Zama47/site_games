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
        await Future.delayed(const Duration(seconds: 1));
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
      
      List<Game> allGames = jsonData
          .map((json) => Game.fromJson(json))
          .where((game) => !game.isDeleted)
          .toList();

      final int startIndex = page * (limit ?? pageSize);
      final int endIndex = startIndex + (limit ?? pageSize);

        if (startIndex >= allGames.length) {
          return [];
        }

        return allGames.sublist(
          startIndex,
          endIndex > allGames.length ? allGames.length : endIndex,
        );
    } catch (e) {
      // Fallback to local data on error
      final jsonData = gamesSteamData;
      List<Game> allGames = jsonData
          .map((json) => Game.fromJson(json))
          .where((game) => !game.isDeleted)
          .toList();
      
      final int startIndex = page * (limit ?? pageSize);
      final int endIndex = startIndex + (limit ?? pageSize);

      if (startIndex >= allGames.length) {
        return [];
      }

      return allGames.sublist(
        startIndex,
        endIndex > allGames.length ? allGames.length : endIndex,
      );
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
