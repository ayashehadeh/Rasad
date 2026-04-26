import '../../domain/entities/chat_message.dart';
import '../models/chat_message_model.dart';

class TripPlannerLocalDataSource {
  static const List<String> _defaultSuggestions = [
    'Build a 2-day Amman itinerary',
    'Best places in Petra',
    'Family trip in Aqaba',
    'Budget trip around Jordan',
  ];

  Future<List<String>> getQuickSuggestions() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _defaultSuggestions;
  }

  Future<ChatMessageModel> sendMessage(String prompt) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final normalized = prompt.toLowerCase();
    if (normalized.contains('itinerary') ||
        normalized.contains('trip') ||
        normalized.contains('plan')) {
      return ChatMessageModel(
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

    return ChatMessageModel(
      text:
          'Great idea. I can help tailor your Jordan trip by city, budget, and number of days.',
      sender: MessageSender.bot,
      timestamp: DateTime.now(),
    );
  }
}
