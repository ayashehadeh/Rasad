import 'package:dartz/dartz.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/home_repository.dart';
import 'package:rasad/features/home/data/models/place_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  // Static seed data — swap for a real API/Supabase call later.
  static const _trending = [
    PlaceModel(
      id: 'petra',
      name: 'The Treasury, Petra',
      imagePath: 'assets/images/petra.png',
      category: PlaceCategory.history,
      rating: 4.9,
      distanceKm: 245.0,
      isTrending: true,
    ),
    PlaceModel(
      id: 'wadirum',
      name: 'Wadi Rum Desert',
      imagePath: 'assets/images/wadirum.png',
      category: PlaceCategory.adventure,
      rating: 4.8,
      distanceKm: 310.0,
      isTrending: true,
    ),
    PlaceModel(
      id: 'deadsea',
      name: 'Dead Sea Shore',
      imagePath: 'assets/images/deadsea2.jpg',
      category: PlaceCategory.nature,
      rating: 4.7,
      distanceKm: 58.0,
      isTrending: true,
    ),
  ];

  static const _nearby = [
    PlaceModel(
      id: 'jarash',
      name: 'Jerash Ruins',
      imagePath: 'assets/images/jarash.png',
      category: PlaceCategory.history,
      rating: 4.9,
      distanceKm: 12.4,
    ),
    PlaceModel(
      id: 'alquds',
      name: 'Al-Quds Restaurant',
      imagePath: 'assets/images/alquds_rest.png',
      category: PlaceCategory.cuisine,
      rating: 4.7,
      distanceKm: 2.1,
    ),
    PlaceModel(
      id: 'madaba',
      name: 'Madaba Mosaics',
      imagePath: 'assets/images/madaba.png',
      category: PlaceCategory.art,
      rating: 4.8,
      distanceKm: 35.0,
    ),
  ];

  @override
  Future<Either<String, List<PlaceEntity>>> getTrendingPlaces() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return const Right(_trending);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<PlaceEntity>>> getNearbyPlaces() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return const Right(_nearby);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
