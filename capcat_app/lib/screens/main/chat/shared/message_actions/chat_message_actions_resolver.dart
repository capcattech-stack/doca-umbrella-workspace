import 'package:flutter_chat_mock_app/models/message.dart';
import 'package:flutter_chat_mock_app/screens/main/chat/shared/chat_screen_contract.dart';
import 'package:flutter_chat_mock_app/screens/main/chat/shared/message_actions/chat_message_action.dart';

List<ChatMessageAction> resolveChatMessageActions({
  required ChatScreenKind kind,
  required Message message,
  Future<void> Function()? onTogglePin,
}) {
  switch (kind) {
    case ChatScreenKind.nanny:
      final id = message.id;
      if (id == null || id.trim().isEmpty || onTogglePin == null) {
        return const <ChatMessageAction>[];
      }
      return <ChatMessageAction>[
        ChatMessageAction(
          id: message.isPinned ? 'unpin-message' : 'pin-message',
          label: message.isPinned ? 'Bỏ ghim tin nhắn' : 'Ghim tin nhắn',
          iconAssetPath: message.isPinned
              ? 'assets/icons/unpin.svg'
              : 'assets/icons/pin.svg',
          onSelected: onTogglePin,
        ),
      ];
    case ChatScreenKind.conversation:
    case ChatScreenKind.thread:
      return const <ChatMessageAction>[];
  }
}
