import 'package:dartz/dartz.dart';
import '../entities/place_entity.dart';
import '../repositories/home_repository.dart';

class GetNearbyPlacesUseCase {
  final HomeRepository _repository;
  const GetNearbyPlacesUseCase(this._repository);

  Future<Either<String, List<PlaceEntity>>> call() {
    return _repository.getNearbyPlaces();
  }
}
