import 'package:dartz/dartz.dart';

import '../repositories/trip_planner_repository.dart';

class GetTripPlannerSuggestionsUseCase {
  final TripPlannerRepository _repository;

  const GetTripPlannerSuggestionsUseCase(this._repository);

  Future<Either<String, List<String>>> call() {
    return _repository.getQuickSuggestions();
  }
}
