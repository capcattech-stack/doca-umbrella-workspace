import 'product.dart';

class Message {
  final String? id;
  final String? conversationId;
  final String? senderId;
  final String? role;
  final String text;
  final bool isSentByUser;
  final List<String>? imageUrls;
  final List<Product>? products;
  final DateTime timestamp;
  final DateTime? updatedAt;
  final DateTime? pinnedAt;
  final dynamic richContent;
  final String? richContentType;
  final MessageSender? sender;
  final String? parentId;
  final bool? isThreadRoot;
  final int? replyCount;

  Message({
    required this.text,
    required this.isSentByUser,
    this.imageUrls,
    this.products,
    DateTime? timestamp,
    this.id,
    this.conversationId,
    this.senderId,
    this.role,
    this.updatedAt,
    this.pinnedAt,
    this.richContent,
    this.richContentType,
    this.sender,
    this.parentId,
    this.isThreadRoot,
    this.replyCount,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get hasImages => imageUrls != null && imageUrls!.isNotEmpty;
  bool get isPinned => pinnedAt != null;

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? role,
    String? text,
    bool? isSentByUser,
    List<String>? imageUrls,
    List<Product>? products,
    DateTime? timestamp,
    DateTime? updatedAt,
    DateTime? pinnedAt,
    bool clearPinnedAt = false,
    dynamic richContent,
    String? richContentType,
    MessageSender? sender,
    String? parentId,
    bool? isThreadRoot,
    int? replyCount,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      role: role ?? this.role,
      text: text ?? this.text,
      isSentByUser: isSentByUser ?? this.isSentByUser,
      imageUrls: imageUrls ?? this.imageUrls,
      products: products ?? this.products,
      timestamp: timestamp ?? this.timestamp,
      updatedAt: updatedAt ?? this.updatedAt,
      pinnedAt: clearPinnedAt ? null : (pinnedAt ?? this.pinnedAt),
      richContent: richContent ?? this.richContent,
      richContentType: richContentType ?? this.richContentType,
      sender: sender ?? this.sender,
      parentId: parentId ?? this.parentId,
      isThreadRoot: isThreadRoot ?? this.isThreadRoot,
      replyCount: replyCount ?? this.replyCount,
    );
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    String? currentAccountId,
  }) {
    // final senderId = _castNullableInt(json['sender_id'])
    final senderId = (json['sender_id'] as String?)?.trim();
    final createdAt = _parseDate(json['created_at']) ?? DateTime.now();
    final updatedAt = _parseDate(json['updated_at']);
    final role = (json['role'] as String?)?.trim();
    final rawRichContent = json['rich_content'];
    final richContentMap = _mapFromJson(rawRichContent);
    final sender = MessageSender.fromJson(json['sender']);

    final extractedText = _extractText(json['content'], rawRichContent);
    final imageUrls = _extractImageUrls(richContentMap);
    final text = extractedText.isNotEmpty
        ? extractedText
        : imageUrls != null && imageUrls.isNotEmpty
        ? ''
        : '[Tin nhắn]';

    final isMine = _determineOwnership(
      senderId: senderId,
      currentAccountId: currentAccountId,
      role: role,
    );

    return Message(
      //id: _castNullableInt(json['id']),
      id: json['id'],
      // conversationId: _castNullableInt(json['conversation_id']),
      conversationId: (json['conversation_id'] as String?)?.trim(),
      senderId: senderId,
      role: role,
      text: text,
      isSentByUser: isMine,
      timestamp: createdAt,
      updatedAt: updatedAt,
      pinnedAt: _parseDate(json['pinned_at']),
      richContent: rawRichContent,
      richContentType: _extractString(richContentMap?['type']),
      imageUrls: imageUrls,
      sender: sender,
      parentId: (json['parent_id'] as String?)?.trim(),
      isThreadRoot: _castNullableBool(json['is_thread_root']),
      replyCount: _castNullableInt(json['reply_count']),
    );
  }
}

class MessageSender {
  final String? id;
  final String? accountId;
  final String? name;
  final String? avatar;
  final String? type;

  const MessageSender({
    this.id,
    this.accountId,
    this.name,
    this.avatar,
    this.type,
  });

  factory MessageSender.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final name =
          _extractString(json['full_name']) ?? _extractString(json['name']);
      final avatar = _extractString(json['avatar']);
      if (name != null || avatar != null) {
        return MessageSender(
          // id: _castNullableInt(json['id']),
          id: json['id'],
          // accountId: _castNullableInt(json['account_id']),
          accountId: json['account_id'],
          name: name,
          avatar: avatar,
          type: _extractString(json['type']),
        );
      }
    }
    return const MessageSender();
  }

  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;
}

String _extractText(dynamic content, dynamic richContent) {
  if (content is String && content.trim().isNotEmpty) {
    return content.trim();
  }
  if (richContent is String && richContent.trim().isNotEmpty) {
    return richContent.trim();
  }
  if (richContent is Map<String, dynamic>) {
    final text = richContent['text'];
    if (text is String && text.trim().isNotEmpty) {
      return text.trim();
    }
  }
  return '';
}

List<String>? _extractImageUrls(Map<String, dynamic>? richContent) {
  if (richContent == null) return null;
  final type = (_extractString(richContent['type']) ?? '').toLowerCase();

  if (type == 'image') {
    final url = _extractString(richContent['url']);
    if (url != null && url.isNotEmpty) {
      return [url];
    }
    return null;
  }

  if (type == 'images') {
    final urls = richContent['urls'];
    if (urls is List) {
      final normalized = urls
          .whereType<String>()
          .map((url) => url.trim())
          .where((url) => url.isNotEmpty)
          .toList();
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }
  }

  return null;
}

bool _determineOwnership({
  required String? senderId,
  required String? currentAccountId,
  required String? role,
}) {
  if (senderId != null && currentAccountId != null) {
    return senderId == currentAccountId;
  }
  if (role != null) {
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
  return false;
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

bool? _castNullableBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
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
