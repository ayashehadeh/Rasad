import 'package:equatable/equatable.dart';
import '../../domain/entities/review_entity.dart';

abstract class ReviewState extends Equatable {
  final int selectedStars;
  const ReviewState({this.selectedStars = 0});

  @override
  List<Object?> get props => [selectedStars];
}

class ReviewInitial extends ReviewState {
  const ReviewInitial() : super(selectedStars: 0);
}

class ReviewStarUpdated extends ReviewState {
  const ReviewStarUpdated(int stars) : super(selectedStars: stars);
}

class ReviewLoading extends ReviewState {
  const ReviewLoading(int stars) : super(selectedStars: stars);
}

class ReviewSuccess extends ReviewState {
  final ReviewEntity review;
  const ReviewSuccess(this.review, int stars) : super(selectedStars: stars);

  @override
  List<Object?> get props => [review, selectedStars];
}

class ReviewFailure extends ReviewState {
  final String message;
  const ReviewFailure(this.message, int stars) : super(selectedStars: stars);

  @override
  List<Object?> get props => [message, selectedStars];
}
