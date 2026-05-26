class Conversation {
  final String id;
  final String title;
  final String? avatarUrl;
  final String? type;
  final String? userAccountId;
  final String? agentAccountId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;
  final bool isLastMessageFromSelf;

  const Conversation({
    required this.id,
    required this.title,
    this.avatarUrl,
    this.type,
    this.userAccountId,
    this.agentAccountId,
    this.createdAt,
    this.updatedAt,
    this.lastMessagePreview,
    this.lastMessageAt,
    this.isLastMessageFromSelf = false,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final lastMessage = _mapFromJson(json['last_message']);
    final createdAt = _parseDate(json['created_at']);
    final updatedAt = _parseDate(json['updated_at']) ?? createdAt;

    final messagePreview = _extractMessagePreview(lastMessage);
    final messageTime =
        _parseDate(lastMessage?['created_at']) ??
        _parseDate(json['last_message_at']);

    // final userAccountId = _castNullableInt(json['user_account_id']);
    final userAccountId = json['user_account_id'];
    // final agentAccountId = _castNullableInt(json['agent_account_id']);
    final agentAccountId = json['agent_account_id'];
    final isFromSelf = _determineIsFromSelf(
      lastMessage,
      userAccountId: userAccountId,
    );

    return Conversation(
      id: json['id'] as String,
      title: _resolveTitle(json),
      avatarUrl: json['avatar'] as String?,
      type: json['type'] as String?,
      userAccountId: userAccountId,
      agentAccountId: agentAccountId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastMessagePreview: messagePreview,
      lastMessageAt: messageTime ?? updatedAt ?? createdAt,
      isLastMessageFromSelf:
          isFromSelf ??
          (json['last_message_from_self'] as bool?) ??
          (json['is_last_message_from_self'] as bool?) ??
          false,
    );
  }

  factory Conversation.fromCacheJson(Map<String, dynamic> json) => Conversation(
    id: json['id'] as String,
    title: json['title'] as String? ?? 'Cuộc trò chuyện',
    avatarUrl: json['avatar'] as String?,
    type: json['type'] as String?,
    // userAccountId: _castNullableInt(json['user_account_id']),
    // agentAccountId: _castNullableInt(json['agent_account_id']),
    userAccountId: json['user_account_id'] as String?,
    agentAccountId: json['agent_account_id'] as String?,
    createdAt: _parseDate(json['created_at']),
    updatedAt: _parseDate(json['updated_at']),
    lastMessagePreview: json['last_message'] as String?,
    lastMessageAt: _parseDate(json['last_message_at']),
    isLastMessageFromSelf:
        (json['last_message_from_self'] as bool?) ??
        (json['is_last_message_from_self'] as bool?) ??
        false,
  );

  Map<String, dynamic> toCacheJson() => {
    'id': id,
    'title': title,
    'avatar': avatarUrl,
    'type': type,
    'user_account_id': userAccountId,
    'agent_account_id': agentAccountId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'last_message': lastMessagePreview,
    'last_message_at': lastMessageAt?.toIso8601String(),
    'last_message_from_self': isLastMessageFromSelf,
  };
}

Map<String, dynamic>? _mapFromJson(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return null;
}

String _resolveTitle(Map<String, dynamic> json) {
  final candidates = [
    json['display_name'],
    json['title'],
    json['name'],
    json['agent_name'],
    json['agent'],
    json['pet_name'],
    json['pet'],
  ];

  for (final candidate in candidates) {
    if (candidate is String && candidate.trim().isNotEmpty) {
      return candidate.trim();
    }
  }

  final agentAccount = _mapFromJson(json['agent_account']);
  if (agentAccount != null) {
    final name = agentAccount['name'];
    if (name is String && name.trim().isNotEmpty) {
      return name.trim();
    }
  }

  final petProfile = _mapFromJson(json['pet']);
  if (petProfile != null) {
    final name = petProfile['name'];
    if (name is String && name.trim().isNotEmpty) {
      return name.trim();
    }
  }

  final id = json['id'];
  return 'Cuộc trò chuyện ${id is num ? '#${id.toInt()}' : ''}'.trim();
}

int? _castNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toLocal();
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value)?.toLocal();
  }
  return null;
}

String? _extractMessagePreview(Map<String, dynamic>? lastMessage) {
  if (lastMessage == null) return null;
  final content = lastMessage['content'];
  if (content is String && content.trim().isNotEmpty) {
    return content.trim();
  }
  final richContent = lastMessage['rich_content'];
  if (richContent is String && richContent.trim().isNotEmpty) {
    return richContent.trim();
  }
  if (richContent is Map<String, dynamic>) {
    final text = richContent['text'];
    if (text is String && text.trim().isNotEmpty) {
      return text.trim();
    }
  }
  return null;
}

bool? _determineIsFromSelf(
  Map<String, dynamic>? lastMessage, {
  int? userAccountId,
}) {
  if (lastMessage == null) return null;
  final senderId = _castNullableInt(lastMessage['sender_id']);
  if (senderId != null && userAccountId != null) {
    return senderId == userAccountId;
  }
  final role = lastMessage['role'];
  if (role is String) {
    final normalized = role.toLowerCase();
    if (normalized == 'user' ||
        normalized == 'customer' ||
        normalized == 'owner' ||
        normalized == 'human') {
      return true;
    }
    if (normalized.contains('agent') ||
        normalized.contains('bot') ||
        normalized.contains('ai')) {
      return false;
    }
  }
  return null;
}
