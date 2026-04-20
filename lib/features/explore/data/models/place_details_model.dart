import '../../domain/entities/place_details_entity.dart';
import 'place_review_model.dart';

class PlaceDetailsModel extends PlaceDetailsEntity {
  const PlaceDetailsModel({
    required super.id,
    required super.name,
    required super.imagePath,
    required super.location,
    required super.about,
    required super.latitude,
    required super.longitude,
    required super.openingHours,
    required super.contactInfo,
    required super.overallRating,
    required super.totalReviews,
    required List<PlaceReviewModel> super.recentReviews,
  });
}
