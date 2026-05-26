class NannyProfile {
  const NannyProfile({required this.name, this.avatar, this.conversationId});

  final String name;
  final String? avatar;
  final String? conversationId;

  factory NannyProfile.fromJson(Map<String, dynamic> json) {
    final rawName = json['name'];
    final rawAvatar = json['avatar'];
    final rawConversationId = json['conversation_id'];

    final name = rawName is String ? rawName.trim() : '';
    final avatar = rawAvatar is String ? rawAvatar.trim() : '';
    final conversationId = rawConversationId is String
        ? rawConversationId.trim()
        : '';

    return NannyProfile(
      name: name,
      avatar: avatar.isNotEmpty ? avatar : null,
      conversationId: conversationId.isNotEmpty ? conversationId : null,
    );
  }
}
