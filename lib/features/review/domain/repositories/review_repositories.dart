import 'package:dartz/dartz.dart';
import '../entities/review_entity.dart';

abstract class ReviewRepository {
  Future<Either<String, ReviewEntity>> submitReview({
    required String placeId,
    required String userId,
    required int stars,
  });
}
