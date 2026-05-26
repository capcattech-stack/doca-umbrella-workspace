class ChatWelcomeContent {
  final String imageUrl;
  final String title;
  final List<String> suggestions;

  const ChatWelcomeContent({
    required this.imageUrl,
    required this.title,
    required this.suggestions,
  });

  factory ChatWelcomeContent.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    final title = json['title'];
    final suggestionsRaw = json['suggestions'];

    return ChatWelcomeContent(
      imageUrl: image is String && image.isNotEmpty
          ? image
          : 'https://resources.capcat.vn/dev/app-setting/chat-welcome.png',
      title: title is String && title.isNotEmpty
          ? title
          : 'Bắt đầu trò chuyện với CAPCAT AI nhé!',
      suggestions: suggestionsRaw is List
          ? suggestionsRaw
              .whereType<String>()
              .where((item) => item.trim().isNotEmpty)
              .toList(growable: false)
          : const [],
    );
  }
}
