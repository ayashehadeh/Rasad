import 'package:dartz/dartz.dart';
import '../../../review/domain/entities/review_entity.dart';
import 'package:rasad/features/review/domain/repositories/review_repositories.dart';

class SubmitReviewUseCase {
  final ReviewRepository _repository;

  const SubmitReviewUseCase(this._repository);

  Future<Either<String, ReviewEntity>> call({
    required String placeId,
    required String userId,
    required int stars,
    required String comment,
    required List<String> photos,
  }) {
    return _repository.submitReview(
      placeId: placeId,
      userId: userId,
      stars: stars,
      comment: comment,
      photos: photos,
    );
  }
}
