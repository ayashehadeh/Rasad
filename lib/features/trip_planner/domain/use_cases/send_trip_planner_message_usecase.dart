import 'package:dartz/dartz.dart';

import '../entities/chat_message.dart';
import '../repositories/trip_planner_repository.dart';

class SendTripPlannerMessageUseCase {
  final TripPlannerRepository _repository;

  const SendTripPlannerMessageUseCase(this._repository);

  Future<Either<String, ChatMessage>> call(String prompt) {
    return _repository.sendMessage(prompt);
  }
}
