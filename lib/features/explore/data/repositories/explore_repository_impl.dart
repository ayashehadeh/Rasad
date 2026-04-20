import 'package:dartz/dartz.dart';
import '../models/explore_place_model.dart';
import '../models/place_details_model.dart';
import '../models/place_review_model.dart';
import '../../domain/entities/explore_place_entity.dart';
import '../../domain/entities/place_details_entity.dart';
import '../../domain/repositories/explore_repository.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  static const _places = [
    ExplorePlaceModel(
      id: 'petra-2',
      name: 'The Treasury (Al Khazneh)',
      imagePath: 'assets/images/petra2.png',
      category: ExploreCategory.history,
      location: 'Petra, Ma\'an',
      description:
          'Iconic rose-red facade carved into sandstone and one of Jordan\'s most famous landmarks.',
    ),
    ExplorePlaceModel(
      id: 'sufra-rest',
      name: 'Sufra Restaurant',
      imagePath: 'assets/images/sufra_resturant.png',
      category: ExploreCategory.cuisine,
      location: 'Rainbow Street, Amman',
      description:
          'Traditional Jordanian dining experience with warm interiors and classic local dishes.',
    ),
    ExplorePlaceModel(
      id: 'amman-roman-theater',
      name: 'Amman Roman Theater',
      imagePath: 'assets/images/amman-roman-theater.jpg',
      category: ExploreCategory.history,
      location: 'Downtown Amman',
      description:
          'A well-preserved Roman amphitheater in the heart of the city with panoramic steps and history.',
    ),
  ];

  static const Map<String, PlaceDetailsModel> _detailsById = {
    'petra-2': PlaceDetailsModel(
      id: 'petra-2',
      name: 'The Treasury (Al Khazneh)',
      imagePath: 'assets/images/petra2.png',
      location: 'Petra, Ma\'an',
      about:
          'The Treasury is Petra\'s most iconic monument, carved directly into pink sandstone. It reflects Nabataean craftsmanship and remains a key symbol of Jordan\'s heritage.',
      latitude: 30.3285,
      longitude: 35.4444,
      openingHours: '06:00 AM - 06:00 PM',
      contactInfo: '+962 3 215 7090',
      overallRating: 4.9,
      totalReviews: 1248,
      recentReviews: [
        PlaceReviewModel(
          authorName: 'Omar Khalid',
          rating: 5.0,
          comment: 'Absolutely breathtaking. Visit early to avoid crowds.',
        ),
        PlaceReviewModel(
          authorName: 'Layla Mansour',
          rating: 4.5,
          comment: 'Beautiful site and stunning colors at sunset.',
        ),
      ],
    ),
    'sufra-rest': PlaceDetailsModel(
      id: 'sufra-rest',
      name: 'Sufra Restaurant',
      imagePath: 'assets/images/sufra_resturant.png',
      location: 'Rainbow Street, Amman',
      about:
          'Sufra serves traditional Jordanian cuisine in an elegant and warm setting. It is known for local recipes and authentic hospitality.',
      latitude: 31.9516,
      longitude: 35.9232,
      openingHours: '11:00 AM - 11:00 PM',
      contactInfo: '+962 6 461 1468',
      overallRating: 4.7,
      totalReviews: 500,
      recentReviews: [
        PlaceReviewModel(
          authorName: 'Dina Saleh',
          rating: 4.8,
          comment: 'Great atmosphere and authentic flavors.',
        ),
        PlaceReviewModel(
          authorName: 'Ahmad F.',
          rating: 4.6,
          comment: 'Loved the mansaf and the service quality.',
        ),
      ],
    ),
    'amman-roman-theater': PlaceDetailsModel(
      id: 'amman-roman-theater',
      name: 'Amman Roman Theater',
      imagePath: 'assets/images/amman-roman-theater.jpg',
      location: 'Downtown Amman',
      about:
          'A historic Roman amphitheater built in the 2nd century, still hosting events and offering views over old Amman.',
      latitude: 31.9517,
      longitude: 35.9347,
      openingHours: '08:00 AM - 07:00 PM',
      contactInfo: '+962 6 460 4217',
      overallRating: 4.8,
      totalReviews: 1248,
      recentReviews: [
        PlaceReviewModel(
          authorName: 'Omar Khalid',
          rating: 5.0,
          comment: 'A must-visit historical place with impressive structure.',
        ),
        PlaceReviewModel(
          authorName: 'Layla Mansour',
          rating: 4.6,
          comment: 'Very photogenic and rich with historical value.',
        ),
      ],
    ),
  };

  @override
  Future<Either<String, List<ExplorePlaceEntity>>> getExplorePlaces() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(_places);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, PlaceDetailsEntity>> getPlaceDetails(String placeId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 350));
      final details = _detailsById[placeId];
      if (details == null) {
        return const Left('Place details not found.');
      }
      return Right(details);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
