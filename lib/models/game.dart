class Game {
  final int id;
  final String title;
  final String genre;
  final String description;
  final DateTime releaseDate;
  final double rating;
  final String imageUrl;
  final String developer;
  final List<String> platforms;
  final String status;
  final bool isFree;
  final String trailerUrl;
  final List<String> screenshots;
  bool isDeleted;
  double? userRating;

  Game({
    required this.id,
    required this.title,
    required this.genre,
    required this.description,
    required this.releaseDate,
    required this.rating,
    required this.imageUrl,
    required this.developer,
    required this.platforms,
    this.status = 'Released',
    this.isFree = false,
    this.trailerUrl = '',
    this.screenshots = const [],
    this.isDeleted = false,
    this.userRating,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as int,
      title: json['title'] as String,
      genre: json['genre'] as String,
      description: json['description'] as String,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      developer: json['developer'] as String,
      platforms: List<String>.from(json['platforms'] as List),
      status: json['status'] as String? ?? 'Released',
      isFree: json['isFree'] as bool? ?? false,
      trailerUrl: json['trailerUrl'] as String? ?? '',
      screenshots: json['screenshots'] != null
          ? List<String>.from(json['screenshots'] as List)
          : const [],
      isDeleted: json['isDeleted'] as bool? ?? false,
      userRating: json['userRating'] != null
          ? (json['userRating'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'description': description,
      'releaseDate': releaseDate.toIso8601String(),
      'rating': rating,
      'imageUrl': imageUrl,
      'developer': developer,
      'platforms': platforms,
      'status': status,
      'isFree': isFree,
      'trailerUrl': trailerUrl,
      'screenshots': screenshots,
      'isDeleted': isDeleted,
      'userRating': userRating,
    };
  }

  Game copyWith({
    int? id,
    String? title,
    String? genre,
    String? description,
    DateTime? releaseDate,
    double? rating,
    String? imageUrl,
    String? developer,
    List<String>? platforms,
    String? status,
    bool? isFree,
    String? trailerUrl,
    List<String>? screenshots,
    bool? isDeleted,
    double? userRating,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      releaseDate: releaseDate ?? this.releaseDate,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      developer: developer ?? this.developer,
      platforms: platforms ?? this.platforms,
      status: status ?? this.status,
      isFree: isFree ?? this.isFree,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      screenshots: screenshots ?? this.screenshots,
      isDeleted: isDeleted ?? this.isDeleted,
      userRating: userRating ?? this.userRating,
    );
  }

  static const List<String> availableGenres = [
    'RPG',
    'Shooter',
    'Arcade',
    'Strategy',
    'Adventure',
    'Racing',
    'Simulation',
    'Puzzle',
    'Action',
    'Sports',
  ];

  static const List<String> availablePlatforms = [
    'PC',
    'PlayStation',
    'Xbox',
    'Nintendo Switch',
    'Mobile',
    'VR',
  ];

  static const List<String> availableStatuses = [
    'Released',
    'In Development',
    'Beta',
    'Alpha',
  ];
}
