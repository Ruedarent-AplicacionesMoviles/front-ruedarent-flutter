// src/data/models/notification_model.dart

class NotificationModel {
  final int? id;
  final int userId;
  final String notificationType; // e.g., 'new reservation', 'reservation change'
  final String content;
  final DateTime timestamp;
  final bool read;

  NotificationModel({
    this.id,
    required this.userId,
    required this.notificationType,
    required this.content,
    required this.timestamp,
    required this.read,
  });

  // Método copyWith para crear una copia del objeto con cambios específicos
  NotificationModel copyWith({
    int? id,
    int? userId,
    String? notificationType,
    String? content,
    DateTime? timestamp,
    bool? read,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notificationType: notificationType ?? this.notificationType,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'notificationType': notificationType,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'read': read ? 1 : 0,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      userId: map['userId'],
      notificationType: map['notificationType'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      read: map['read'] == 1,
    );
  }
}
