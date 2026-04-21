import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String placeId;
  final String userId;
  final int stars; // 1–5
  final String comment;
  final List<String> photos;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.stars,
    required this.comment,
    required this.photos,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, placeId, userId, stars, comment, photos, createdAt];
}
