import 'package:equatable/equatable.dart';
import 'place_review_entity.dart';

class PlaceDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String imagePath;
  final String location;
  final String about;
  final double latitude;
  final double longitude;
  final String openingHours;
  final String contactInfo;
  final double overallRating;
  final int totalReviews;
  final List<PlaceReviewEntity> recentReviews;

  const PlaceDetailsEntity({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.location,
    required this.about,
    required this.latitude,
    required this.longitude,
    required this.openingHours,
    required this.contactInfo,
    required this.overallRating,
    required this.totalReviews,
    required this.recentReviews,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    imagePath,
    location,
    about,
    latitude,
    longitude,
    openingHours,
    contactInfo,
    overallRating,
    totalReviews,
    recentReviews,
  ];
}
