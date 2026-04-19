import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/submit_review_usecase.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final SubmitReviewUseCase _submitReviewUseCase;

  ReviewBloc({required SubmitReviewUseCase submitReviewUseCase})
    : _submitReviewUseCase = submitReviewUseCase,
      super(const ReviewInitial()) {
    on<ReviewStarSelected>(_onStarSelected);
    on<ReviewSubmitRequested>(_onSubmit);
    on<ReviewReset>(_onReset);
  }

  void _onStarSelected(ReviewStarSelected event, Emitter<ReviewState> emit) {
    emit(ReviewStarUpdated(event.stars));
  }

  Future<void> _onSubmit(
    ReviewSubmitRequested event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading(event.stars));
    final result = await _submitReviewUseCase(
      placeId: event.placeId,
      userId: event.userId,
      stars: event.stars,
    );
    result.fold(
      (failure) => emit(ReviewFailure(failure, event.stars)),
      (review) => emit(ReviewSuccess(review, event.stars)),
    );
  }

  void _onReset(ReviewReset event, Emitter<ReviewState> emit) {
    emit(const ReviewInitial());
  }
}
