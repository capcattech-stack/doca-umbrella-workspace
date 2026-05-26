import 'message.dart';

class ChatMessagesPage {
  final List<Message> messages;
  final int? nextCursor;
  final bool hasMore;

  const ChatMessagesPage({
    required this.messages,
    this.nextCursor,
    this.hasMore = false,
  });

  ChatMessagesPage copyWith({
    List<Message>? messages,
    int? nextCursor,
    bool? hasMore,
  }) {
    return ChatMessagesPage(
      messages: messages ?? this.messages,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  static const empty = ChatMessagesPage(messages: []);
}
