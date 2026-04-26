import 'package:dartz/dartz.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/trip_planner_repository.dart';
import '../datasources/trip_planner_local_datasource.dart';

class TripPlannerRepositoryImpl implements TripPlannerRepository {
  final TripPlannerLocalDataSource _localDataSource;

  const TripPlannerRepositoryImpl(this._localDataSource);

  @override
  Future<Either<String, List<String>>> getQuickSuggestions() async {
    try {
      final suggestions = await _localDataSource.getQuickSuggestions();
      return Right(suggestions);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ChatMessage>> sendMessage(String prompt) async {
    try {
      final response = await _localDataSource.sendMessage(prompt);
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
