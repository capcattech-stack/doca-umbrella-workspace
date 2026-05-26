import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_chat_mock_app/models/message.dart';
import 'package:flutter_chat_mock_app/models/nanny_messages_page.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/services/extension/response_extension.dart';
import 'package:flutter_chat_mock_app/services/model/service_response.dart';

class NannyMessageRemoteService {
  static Future<ServiceResponse<NannyMessagesPage>> getNannyMessages({
    int? cursor,
    int limit = 30,
    String? currentAccountId,
    String? parentId,
    String? pinnedStatus,
    bool? isThread,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }

    try {
      final response = await ApiService.getNannyMessages(
        token,
        cursor: cursor,
        limit: limit,
        parentId: parentId,
        pinnedStatus: pinnedStatus,
        isThread: isThread,
      );
      final raw = response.data;
      _debugPrintRawNannyMessagesJson(raw);
      final serverMessage = _extractMessage(raw);

      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message: serverMessage ?? 'Không tải được tin nhắn trợ lý',
        );
      }

      if (raw is! Map<String, dynamic>) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phản hồi từ server không hợp lệ',
        );
      }

      final data = raw['data'];
      if (data is! List) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Danh sách tin nhắn trợ lý không hợp lệ',
        );
      }

      final metadata = raw['metadata'];
      final nextCursor = _castNullableInt(
        metadata is Map<String, dynamic> ? metadata['next_cursor'] : null,
      );
      final hasMore = metadata is Map<String, dynamic>
          ? metadata['has_more'] == true
          : false;
      final hasUserMessagedRecently =
          _castNullableBool(
            metadata is Map<String, dynamic>
                ? metadata['has_user_messaged_recently']
                : null,
          ) ??
          true;

      final messages = data
          .whereType<Map<String, dynamic>>()
          .map(
            (json) => Message.fromJson(
              _normalizeMessagePayload(json),
              currentAccountId: currentAccountId,
            ),
          )
          .toList();

      return ServiceResponse(
        isSuccess: true,
        data: NannyMessagesPage(
          messages: messages,
          nextCursor: nextCursor,
          hasMore: hasMore,
          hasUserMessagedRecently: hasUserMessagedRecently,
        ),
      );
    } catch (_) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
      );
    }
  }

  static Future<ServiceResponse<void>> setNannyMessagePinned({
    required String messageId,
    required bool isPinned,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }

    try {
      final response = await ApiService.setChatMessagePinned(
        token: token,
        messageId: messageId,
        isPinned: isPinned,
      );
      final raw = response.data;
      final serverMessage = _extractMessage(raw);

      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message:
              serverMessage ??
              (isPinned
                  ? 'Không thể lưu tin nhắn'
                  : 'Không thể bỏ lưu tin nhắn'),
        );
      }

      return ServiceResponse(isSuccess: true);
    } catch (_) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
      );
    }
  }

  static String? _extractMessage(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final message = raw['message'];
      if (message is String) return message;
      if (message is List && message.isNotEmpty) {
        final first = message.first;
        if (first is Map<String, dynamic>) {
          final value = first['value'];
          if (value is String) return value;
        }
      }
    }
    return null;
  }

  static int? _castNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static bool? _castNullableBool(dynamic value) {
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
}

void _debugPrintRawNannyMessagesJson(dynamic raw) {
  String text;
  try {
    text = jsonEncode(raw);
  } catch (_) {
    text = raw?.toString() ?? 'null';
  }

  debugPrint('🧾 [NannyMessages][RAW-JSON] START');
  const chunkSize = 800;
  for (var i = 0; i < text.length; i += chunkSize) {
    final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
    debugPrint(text.substring(i, end));
  }
  debugPrint('🧾 [NannyMessages][RAW-JSON] END');
}

Map<String, dynamic> _normalizeMessagePayload(Map<String, dynamic> json) {
  final messageMap = _asMap(json['message']);
  if (messageMap != null) {
    return _withOwnershipHints({...json, ...messageMap});
  }

  final dataMap = _asMap(json['data']);
  final nestedMessage = _asMap(dataMap?['message']);
  if (nestedMessage != null) {
    return _withOwnershipHints({...json, ...nestedMessage});
  }

  return _withOwnershipHints(json);
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return null;
}

Map<String, dynamic> _withOwnershipHints(Map<String, dynamic> raw) {
  final sender = _asMap(raw['sender']);
  final role = raw['role'] ?? sender?['type'];
  final senderId = raw['sender_id'] ?? sender?['account_id'] ?? sender?['id'];

  return {
    ...raw,
    if (role != null) 'role': role,
    if (senderId != null) 'sender_id': senderId,
  };
}
