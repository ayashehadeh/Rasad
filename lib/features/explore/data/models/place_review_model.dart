import '../../domain/entities/place_review_entity.dart';

class PlaceReviewModel extends PlaceReviewEntity {
  const PlaceReviewModel({
    required super.authorName,
    required super.rating,
    required super.comment,
  });
}
