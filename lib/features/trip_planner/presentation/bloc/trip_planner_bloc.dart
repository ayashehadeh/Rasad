import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/use_cases/get_trip_planner_suggestions_usecase.dart';
import '../../domain/use_cases/send_trip_planner_message_usecase.dart';
import 'trip_planner_event.dart';
import 'trip_planner_state.dart';

class TripPlannerBloc extends Bloc<TripPlannerEvent, TripPlannerState> {
  final GetTripPlannerSuggestionsUseCase _getSuggestions;
  final SendTripPlannerMessageUseCase _sendMessage;

  TripPlannerBloc({
    required GetTripPlannerSuggestionsUseCase getSuggestionsUseCase,
    required SendTripPlannerMessageUseCase sendMessageUseCase,
  }) : _getSuggestions = getSuggestionsUseCase,
       _sendMessage = sendMessageUseCase,
       super(const TripPlannerInitial()) {
    on<TripPlannerStarted>(_onStarted);
    on<TripPlannerMessageSent>(_onMessageSent);
    on<TripPlannerSuggestionTapped>(_onSuggestionTapped);
    on<TripPlannerChatCleared>(_onChatCleared);
    add(const TripPlannerStarted());
  }

  Future<void> _onStarted(
    TripPlannerStarted event,
    Emitter<TripPlannerState> emit,
  ) async {
    final suggestionsResult = await _getSuggestions();

    emit(
      TripPlannerActive(
        messages: const [],
        isBotTyping: false,
        quickSuggestions: suggestionsResult.getOrElse(() => const []),
      ),
    );
  }

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

    final responseResult = await _sendMessage(event.text);
    final response = responseResult.getOrElse(
      () => ChatMessage(
        text: 'Sorry, I could not prepare a trip suggestion right now.',
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
      ),
    );

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
      _activeState.copyWith(
        messages: [],
        isBotTyping: false,
      ),
    );
    add(const TripPlannerStarted());
  }

  TripPlannerActive get _activeState {
    final currentState = state;
    if (currentState is TripPlannerActive) {
      return currentState;
    }

    return const TripPlannerActive(
      messages: [],
      isBotTyping: false,
      quickSuggestions: [],
    );
  }
}
