enum ChatScreenKind { conversation, thread, nanny }

class ChatScreenContract {
  const ChatScreenContract({
    required this.kind,
    required this.parentId,
    required this.hasWelcomeContent,
    required this.hasToolPanel,
    required this.supportsThreadReplies,
    required this.hidesAssistantFab,
  });

  final ChatScreenKind kind;
  final String? parentId;
  final bool hasWelcomeContent;
  final bool hasToolPanel;
  final bool supportsThreadReplies;
  final bool hidesAssistantFab;
}

class ChatScreenContracts {
  const ChatScreenContracts._();

  static const ChatScreenContract conversation = ChatScreenContract(
    kind: ChatScreenKind.conversation,
    parentId: null,
    hasWelcomeContent: true,
    hasToolPanel: true,
    supportsThreadReplies: true,
    hidesAssistantFab: true,
  );

  static ChatScreenContract thread({required String rootMessageId}) =>
      ChatScreenContract(
        kind: ChatScreenKind.thread,
        parentId: rootMessageId,
        hasWelcomeContent: false,
        hasToolPanel: true,
        supportsThreadReplies: false,
        hidesAssistantFab: false,
      );

  static const ChatScreenContract nanny = ChatScreenContract(
    kind: ChatScreenKind.nanny,
    parentId: null,
    hasWelcomeContent: false,
    hasToolPanel: false,
    supportsThreadReplies: false,
    hidesAssistantFab: true,
  );
}
