import 'package:equatable/equatable.dart';

enum ExploreCategory { history, cuisine }

class ExplorePlaceEntity extends Equatable {
  final String id;
  final String name;
  final String imagePath;
  final ExploreCategory category;
  final String location;
  final String description;

  const ExplorePlaceEntity({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.location,
    required this.description,
  });

  String get categoryLabel {
    switch (category) {
      case ExploreCategory.history:
        return 'HISTORY';
      case ExploreCategory.cuisine:
        return 'CUISINE';
    }
  }

  @override
  List<Object?> get props => [id, name, imagePath, category, location, description];
}
