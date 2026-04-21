import '../../domain/entities/place_entity.dart';

class PlaceModel extends PlaceEntity {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.imagePath,
    required super.category,
    required super.rating,
    required super.distanceKm,
    super.isTrending,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imagePath: json['image_path'] as String,
      category: PlaceCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => PlaceCategory.history,
      ),
      rating: (json['rating'] as num).toDouble(),
      distanceKm: (json['distance_km'] as num).toDouble(),
      isTrending: json['is_trending'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image_path': imagePath,
    'category': category.name,
    'rating': rating,
    'distance_km': distanceKm,
    'is_trending': isTrending,
  };
}
