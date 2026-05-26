class NannyWelcomeContent {
  const NannyWelcomeContent({required this.title, required this.suggestions});

  final String title;
  final List<String> suggestions;

  factory NannyWelcomeContent.fromJson(Map<String, dynamic> json) {
    final title = json['title'];
    final suggestionsRaw = json['suggestions'];

    return NannyWelcomeContent(
      title: title is String && title.trim().isNotEmpty
          ? title.trim()
          : 'Hôm nay bạn có gì muốn hỏi bảo mẫu?',
      suggestions: suggestionsRaw is List
          ? suggestionsRaw
                .whereType<String>()
                .map((item) => item.trim())
                .where((item) => item.isNotEmpty)
                .toList(growable: false)
          : const <String>[],
    );
  }
}
