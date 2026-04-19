import 'package:dartz/dartz.dart';
import '../entities/place_entity.dart';

abstract class HomeRepository {
  Future<Either<String, List<PlaceEntity>>> getTrendingPlaces();
  Future<Either<String, List<PlaceEntity>>> getNearbyPlaces();
}
