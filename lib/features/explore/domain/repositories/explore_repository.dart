import 'package:dartz/dartz.dart';
import '../entities/explore_place_entity.dart';
import '../entities/place_details_entity.dart';

abstract class ExploreRepository {
  Future<Either<String, List<ExplorePlaceEntity>>> getExplorePlaces();
  Future<Either<String, PlaceDetailsEntity>> getPlaceDetails(String placeId);
}
