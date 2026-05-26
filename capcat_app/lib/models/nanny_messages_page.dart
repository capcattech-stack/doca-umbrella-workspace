import 'package:flutter_chat_mock_app/models/message.dart';

class NannyMessagesPage {
  final List<Message> messages;
  final int? nextCursor;
  final bool hasMore;
  final bool hasUserMessagedRecently;

  const NannyMessagesPage({
    required this.messages,
    this.nextCursor,
    this.hasMore = false,
    this.hasUserMessagedRecently = true,
  });

  NannyMessagesPage copyWith({
    List<Message>? messages,
    int? nextCursor,
    bool? hasMore,
    bool? hasUserMessagedRecently,
  }) {
    return NannyMessagesPage(
      messages: messages ?? this.messages,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      hasUserMessagedRecently:
          hasUserMessagedRecently ?? this.hasUserMessagedRecently,
    );
  }

  static const empty = NannyMessagesPage(messages: []);
}
