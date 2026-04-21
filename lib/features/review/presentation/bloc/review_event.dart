import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReviewSubmitRequested extends ReviewEvent {
  final String placeId;
  final String userId;
  final int stars;
  final String comment;
  final List<String> photos;

  ReviewSubmitRequested({
    required this.placeId,
    required this.userId,
    required this.stars,
    required this.comment,
    required this.photos,
  });

  @override
  List<Object?> get props => [placeId, userId, stars, comment, photos];
}

class ReviewStarSelected extends ReviewEvent {
  final int stars;
  ReviewStarSelected(this.stars);

  @override
  List<Object?> get props => [stars];
}

class ReviewReset extends ReviewEvent {}
