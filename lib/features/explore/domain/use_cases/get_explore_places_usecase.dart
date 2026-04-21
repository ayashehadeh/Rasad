import 'package:dartz/dartz.dart';
import '../entities/explore_place_entity.dart';
import '../repositories/explore_repository.dart';

class GetExplorePlacesUseCase {
  final ExploreRepository _repository;

  GetExplorePlacesUseCase(this._repository);

  Future<Either<String, List<ExplorePlaceEntity>>> call() {
    return _repository.getExplorePlaces();
  }
}
