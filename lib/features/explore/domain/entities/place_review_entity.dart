import 'package:equatable/equatable.dart';

class PlaceReviewEntity extends Equatable {
  final String authorName;
  final double rating;
  final String comment;

  const PlaceReviewEntity({
    required this.authorName,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [authorName, rating, comment];
}
