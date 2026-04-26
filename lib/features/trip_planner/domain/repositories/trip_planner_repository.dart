import 'package:dartz/dartz.dart';

import '../entities/chat_message.dart';

abstract class TripPlannerRepository {
  Future<Either<String, List<String>>> getQuickSuggestions();
  Future<Either<String, ChatMessage>> sendMessage(String prompt);
}
