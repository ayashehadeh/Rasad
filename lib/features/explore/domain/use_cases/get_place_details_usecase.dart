import 'package:dartz/dartz.dart';
import '../entities/place_details_entity.dart';
import '../repositories/explore_repository.dart';

class GetPlaceDetailsUseCase {
  final ExploreRepository _repository;

  GetPlaceDetailsUseCase(this._repository);

  Future<Either<String, PlaceDetailsEntity>> call(String placeId) {
    return _repository.getPlaceDetails(placeId);
  }
}
