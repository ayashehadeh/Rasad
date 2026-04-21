import '../../domain/entities/explore_place_entity.dart';

class ExplorePlaceModel extends ExplorePlaceEntity {
  const ExplorePlaceModel({
    required super.id,
    required super.name,
    required super.imagePath,
    required super.category,
    required super.location,
    required super.description,
  });
}
