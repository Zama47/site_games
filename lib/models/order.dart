class Order {
  final int id;
  final int gameId;
  final String userId;
  final String userName;
  final String gameTitle;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime createdAt;
  final String? comment;
  final String? adminComment;
  final DateTime? processedAt;

  const Order({
    required this.id,
    required this.gameId,
    required this.userId,
    required this.userName,
    required this.gameTitle,
    this.status = 'pending',
    required this.createdAt,
    this.comment,
    this.adminComment,
    this.processedAt,
  });

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  String get statusText {
    switch (status) {
      case 'pending':
        return 'На рассмотрении';
      case 'approved':
        return 'Одобрено';
      case 'rejected':
        return 'Отклонено';
      default:
        return 'Неизвестно';
    }
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      gameId: json['gameId'] as int,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      gameTitle: json['gameTitle'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      comment: json['comment'] as String?,
      adminComment: json['adminComment'] as String?,
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameId': gameId,
      'userId': userId,
      'userName': userName,
      'gameTitle': gameTitle,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'comment': comment,
      'adminComment': adminComment,
      'processedAt': processedAt?.toIso8601String(),
    };
  }

  Order copyWith({
    int? id,
    int? gameId,
    String? userId,
    String? userName,
    String? gameTitle,
    String? status,
    DateTime? createdAt,
    String? comment,
    String? adminComment,
    DateTime? processedAt,
  }) {
    return Order(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      gameTitle: gameTitle ?? this.gameTitle,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      comment: comment ?? this.comment,
      adminComment: adminComment ?? this.adminComment,
      processedAt: processedAt ?? this.processedAt,
    );
  }
}
