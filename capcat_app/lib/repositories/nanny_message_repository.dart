import 'package:flutter_chat_mock_app/models/nanny_messages_page.dart';
import 'package:flutter_chat_mock_app/services/nanny_message_remote_service.dart';

class NannyMessageRepository {
  Future<NannyMessagesPage> fetchNannyMessages({
    int? cursor,
    int limit = 30,
    String? parentId,
    String? pinnedStatus,
    bool? isThread,
  }) async {
    final response = await NannyMessageRemoteService.getNannyMessages(
      cursor: cursor,
      limit: limit,
      parentId: parentId,
      pinnedStatus: pinnedStatus,
      isThread: isThread,
    );

    if (response.isSuccess && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Không tải được danh sách tin nhắn');
  }

  Future<void> setMessagePinned({
    required String messageId,
    required bool isPinned,
  }) async {
    final response = await NannyMessageRemoteService.setNannyMessagePinned(
      messageId: messageId,
      isPinned: isPinned,
    );
    if (response.isSuccess) return;
    throw Exception(response.message ?? 'Không cập nhật được trạng thái lưu');
  }
}
