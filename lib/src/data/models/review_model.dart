// src/data/models/review_model.dart

class ReviewModel {
  final int? id;
  final int vehicleId;
  final int userId;
  final int rating; // 1 to 5
  final String? comment;
  final DateTime timestamp;

  ReviewModel({
    this.id,
    required this.vehicleId,
    required this.userId,
    required this.rating,
    this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'],
      vehicleId: map['vehicleId'],
      userId: map['userId'],
      rating: map['rating'],
      comment: map['comment'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
