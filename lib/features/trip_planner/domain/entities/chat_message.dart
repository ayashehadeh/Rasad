enum MessageSender { user, bot }

enum BotResponseType { text, plan }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final BotResponseType responseType;
  final List<String>? planItems;

  const ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
    this.responseType = BotResponseType.text,
    this.planItems,
  });
}
