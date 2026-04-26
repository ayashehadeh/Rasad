import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.text,
    required super.sender,
    required super.timestamp,
    super.responseType,
    super.planItems,
  });
}
