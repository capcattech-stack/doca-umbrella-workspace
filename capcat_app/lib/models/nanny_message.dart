class NannyMessage {
  final String? id;
  final String content;
  final bool isSentByUser;
  final String? role;
  final String? senderId;
  final DateTime timestamp;
  final DateTime? updatedAt;
  final dynamic richContent;
  final String? richContentType;
  final NannyMessageSender sender;

  const NannyMessage({
    required this.content,
    required this.isSentByUser,
    required this.sender,
    required this.timestamp,
    this.id,
    this.role,
    this.senderId,
    this.updatedAt,
    this.richContent,
    this.richContentType,
  });

  factory NannyMessage.fromJson(
    Map<String, dynamic> json, {
    String? currentAccountId,
  }) {
    final payload = _resolveMessagePayload(json);
    final sender = NannyMessageSender.fromJson(
      _mapFromJson(payload['sender']) ?? _mapFromJson(json['sender']),
    );

    final senderId =
        _extractString(payload['sender_id']) ??
        _extractString(json['sender_id']) ??
        sender.accountId ??
        sender.id;
    final role =
        _extractString(payload['role']) ??
        _extractString(json['role']) ??
        sender.type;
    final richContent = payload['rich_content'] ?? json['rich_content'];
    final content = _extractContent(payload, json);

    return NannyMessage(
      id:
          _extractString(payload['id']) ??
          _extractString(json['id']) ??
          _extractString(payload['message_id']),
      content: content,
      isSentByUser: _determineOwnership(
        senderId: senderId,
        senderType: sender.type,
        currentAccountId: currentAccountId,
        role: role,
      ),
      role: role,
      senderId: senderId,
      sender: sender,
      timestamp:
          _parseDate(payload['created_at']) ??
          _parseDate(json['created_at']) ??
          _parseDate(payload['timestamp']) ??
          _parseDate(json['timestamp']) ??
          DateTime.now(),
      updatedAt:
          _parseDate(payload['updated_at']) ?? _parseDate(json['updated_at']),
      richContent: richContent,
      richContentType: _extractString(_mapFromJson(richContent)?['type']),
    );
  }
}

class NannyMessageSender {
  final String? id;
  final String? accountId;
  final String? name;
  final String? avatar;
  final String? type;

  const NannyMessageSender({
    this.id,
    this.accountId,
    this.name,
    this.avatar,
    this.type,
  });

  factory NannyMessageSender.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const NannyMessageSender();
    }
    return NannyMessageSender(
      id: _extractString(json['id']),
      accountId: _extractString(json['account_id']),
      name: _extractString(json['full_name']) ?? _extractString(json['name']),
      avatar: _extractString(json['avatar']),
      type: _extractString(json['type']),
    );
  }
}

Map<String, dynamic> _resolveMessagePayload(Map<String, dynamic> json) {
  final messageMap = _mapFromJson(json['message']);
  if (messageMap != null) return messageMap;

  final dataMap = _mapFromJson(json['data']);
  final nestedMessage = _mapFromJson(dataMap?['message']);
  if (nestedMessage != null) return nestedMessage;

  return json;
}

String _extractContent(
  Map<String, dynamic> payload,
  Map<String, dynamic> root,
) {
  final candidates = <dynamic>[
    payload['content'],
    root['content'],
    _mapFromJson(payload['message'])?['content'],
    _mapFromJson(root['message'])?['content'],
  ];

  for (final candidate in candidates) {
    final text = _extractString(candidate);
    if (text != null) return text;
  }
  return '';
}

bool _determineOwnership({
  required String? senderId,
  required String? senderType,
  required String? currentAccountId,
  required String? role,
}) {
  if (senderId != null && currentAccountId != null) {
    return senderId == currentAccountId;
  }

  final normalizedRole = role?.toLowerCase();
  if (normalizedRole != null) {
    if (normalizedRole == 'user' ||
        normalizedRole == 'human' ||
        normalizedRole == 'customer' ||
        normalizedRole == 'owner') {
      return true;
    }
    if (normalizedRole.contains('nanny') ||
        normalizedRole.contains('agent') ||
        normalizedRole.contains('bot') ||
        normalizedRole.contains('assistant') ||
        normalizedRole.contains('ai')) {
      return false;
    }
  }

  final normalizedType = senderType?.toLowerCase();
  if (normalizedType != null) {
    if (normalizedType == 'user') return true;
    if (normalizedType == 'nanny' ||
        normalizedType == 'agent' ||
        normalizedType == 'assistant' ||
        normalizedType == 'ai') {
      return false;
    }
  }
  return false;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toLocal();
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value)?.toLocal();
  }
  return null;
}

String? _extractString(dynamic value) {
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return null;
}

Map<String, dynamic>? _mapFromJson(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return null;
}
