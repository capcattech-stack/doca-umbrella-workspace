typedef ChatMessageActionHandler = Future<void> Function();

class ChatMessageAction {
  const ChatMessageAction({
    required this.id,
    required this.label,
    required this.iconAssetPath,
    required this.onSelected,
    this.isDestructive = false,
  });

  final String id;
  final String label;
  final String iconAssetPath;
  final bool isDestructive;
  final ChatMessageActionHandler onSelected;
}
