enum UserRole { gamer, admin }

class User {
  final String id;
  final String username;
  final String password;
  final UserRole role;
  final String displayName;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.displayName,
    this.avatarUrl,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isGamer => role == UserRole.gamer;

  static const User gamer = User(
    id: '1',
    username: 'gamer',
    password: 'pass',
    role: UserRole.gamer,
    displayName: 'Игрок',
    avatarUrl: null,
  );

  static const User admin = User(
    id: '2',
    username: 'admin',
    password: 'pass',
    role: UserRole.admin,
    displayName: 'Администратор',
    avatarUrl: null,
  );

  static const List<User> defaultUsers = [gamer, admin];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.gamer,
      ),
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role.name,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
    };
  }
}
