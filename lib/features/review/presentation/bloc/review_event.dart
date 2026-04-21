import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReviewSubmitRequested extends ReviewEvent {
  final String placeId;
  final String userId;
  final int stars;

  ReviewSubmitRequested({
    required this.placeId,
    required this.userId,
    required this.stars,
  });

  @override
  List<Object?> get props => [placeId, userId, stars];
}

class ReviewStarSelected extends ReviewEvent {
  final int stars;
  ReviewStarSelected(this.stars);

  @override
  List<Object?> get props => [stars];
}

class ReviewReset extends ReviewEvent {}
