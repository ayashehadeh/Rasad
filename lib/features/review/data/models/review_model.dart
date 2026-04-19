import '../../../review/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.placeId,
    required super.userId,
    required super.stars,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      placeId: json['place_id'] as String,
      userId: json['user_id'] as String,
      stars: json['stars'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place_id': placeId,
      'user_id': userId,
      'stars': stars,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
