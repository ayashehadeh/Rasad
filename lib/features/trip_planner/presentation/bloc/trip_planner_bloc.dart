import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_message.dart';
import 'trip_planner_event.dart';
import 'trip_planner_state.dart';

class TripPlannerBloc extends Bloc<TripPlannerEvent, TripPlannerState> {
  TripPlannerBloc() : super(const TripPlannerInitial()) {
    on<TripPlannerMessageSent>(_onMessageSent);
    on<TripPlannerSuggestionTapped>(_onSuggestionTapped);
    on<TripPlannerChatCleared>(_onChatCleared);
  }

  static const List<String> _defaultSuggestions = [
    'Build a 2-day Amman itinerary',
    'Best places in Petra',
    'Family trip in Aqaba',
    'Budget trip around Jordan',
  ];

  Future<void> _onMessageSent(
    TripPlannerMessageSent event,
    Emitter<TripPlannerState> emit,
  ) async {
    final current = _activeState;
    final userMessage = ChatMessage(
      text: event.text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    emit(
      current.copyWith(
        messages: [...current.messages, userMessage],
        isBotTyping: true,
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 700));

    final response = _buildBotResponse(event.text);
    emit(
      current.copyWith(
        messages: [...current.messages, userMessage, response],
        isBotTyping: false,
      ),
    );
  }

  Future<void> _onSuggestionTapped(
    TripPlannerSuggestionTapped event,
    Emitter<TripPlannerState> emit,
  ) async {
    add(TripPlannerMessageSent(event.suggestion));
  }

  void _onChatCleared(
    TripPlannerChatCleared event,
    Emitter<TripPlannerState> emit,
  ) {
    emit(
      const TripPlannerActive(
        messages: [],
        isBotTyping: false,
        quickSuggestions: _defaultSuggestions,
      ),
    );
  }

  TripPlannerActive get _activeState {
    final stateValue = state;
    if (stateValue is TripPlannerActive) {
      return stateValue;
    }
    return const TripPlannerActive(
      messages: [],
      isBotTyping: false,
      quickSuggestions: _defaultSuggestions,
    );
  }

  ChatMessage _buildBotResponse(String prompt) {
    final normalized = prompt.toLowerCase();
    if (normalized.contains('itinerary') ||
        normalized.contains('trip') ||
        normalized.contains('plan')) {
      return ChatMessage(
        text: 'Suggested travel plan',
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
        responseType: BotResponseType.plan,
        planItems: const [
          'Day 1: Explore Downtown Amman and Rainbow Street.',
          'Day 2: Visit Petra early and stay for sunset.',
          'Day 3: Relax in Aqaba or Wadi Rum desert camp.',
        ],
      );
    }

    return ChatMessage(
      text:
          'Great idea. I can help tailor your Jordan trip by city, budget, and number of days.',
      sender: MessageSender.bot,
      timestamp: DateTime.now(),
    );
  }
}
