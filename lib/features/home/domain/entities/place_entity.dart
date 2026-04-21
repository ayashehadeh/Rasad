import 'package:equatable/equatable.dart';

enum PlaceCategory { history, cuisine, art, nature, adventure }

class PlaceEntity extends Equatable {
  final String id;
  final String name;
  final String imagePath; // local asset path
  final PlaceCategory category;
  final double rating;
  final double distanceKm;
  final bool isTrending;

  const PlaceEntity({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.rating,
    required this.distanceKm,
    this.isTrending = false,
  });

  String get categoryLabel {
    switch (category) {
      case PlaceCategory.history:
        return 'HISTORY';
      case PlaceCategory.cuisine:
        return 'CUISINE';
      case PlaceCategory.art:
        return 'ART';
      case PlaceCategory.nature:
        return 'NATURE';
      case PlaceCategory.adventure:
        return 'ADVENTURE';
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    imagePath,
    category,
    rating,
    distanceKm,
    isTrending,
  ];
}
