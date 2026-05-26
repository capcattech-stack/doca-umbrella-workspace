class ChatPet {
  final String id;
  final String name;
  final String? avatarUrl;
  final String type;
  final String? conversationId;
  final String? conversationType;

  const ChatPet({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.type,
    this.conversationId,
    this.conversationType,
  });

  factory ChatPet.fromJson(Map<String, dynamic> json) {
    final rawName = json['name'];
    final normalizedName = rawName is String && rawName.trim().isNotEmpty
        ? rawName.trim()
        : null;
    final rawType = json['type'];
    final normalizedType = rawType is String && rawType.trim().isNotEmpty
        ? rawType.trim()
        : 'personal';

    return ChatPet(
      id: json['id'].toString(),
      name: normalizedName ?? 'Bé cưng',
      avatarUrl: json['avatar'] as String?,
      type: normalizedType,
      conversationId: json['conversation_id']?.toString(),
      conversationType: json['conversation_type'] as String?,
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? value.hashCode;
    }
    return 0;
  }

  bool get isSystem => type.toLowerCase() == 'system';
}
