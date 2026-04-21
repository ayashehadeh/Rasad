import 'package:dartz/dartz.dart';
import '../../domain/entities/review_entity.dart';
import 'package:rasad/features/review/domain/repositories/review_repositories.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  @override
  Future<Either<String, ReviewEntity>> submitReview({
    required String placeId,
    required String userId,
    required int stars,
  }) async {
    try {
      // TODO: replace with real API/Supabase call
      await Future.delayed(const Duration(seconds: 1));
      return Right(
        ReviewModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          placeId: placeId,
          userId: userId,
          stars: stars,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
