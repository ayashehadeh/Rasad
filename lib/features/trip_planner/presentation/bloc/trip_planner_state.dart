import '../../domain/entities/chat_message.dart';

abstract class TripPlannerState {
  const TripPlannerState();
}

class TripPlannerInitial extends TripPlannerState {
  const TripPlannerInitial();
}

class TripPlannerActive extends TripPlannerState {
  final List<ChatMessage> messages;
  final bool isBotTyping;
  final List<String> quickSuggestions;

  const TripPlannerActive({
    required this.messages,
    required this.isBotTyping,
    required this.quickSuggestions,
  });

  TripPlannerActive copyWith({
    List<ChatMessage>? messages,
    bool? isBotTyping,
    List<String>? quickSuggestions,
  }) {
    return TripPlannerActive(
      messages: messages ?? this.messages,
      isBotTyping: isBotTyping ?? this.isBotTyping,
      quickSuggestions: quickSuggestions ?? this.quickSuggestions,
    );
  }
}
