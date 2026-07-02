import 'package:flutter/foundation.dart';
import 'package:capcat_doca/models/moment.dart';
import 'package:capcat_doca/services/api_service.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/services/extension/response_extension.dart';
import 'package:capcat_doca/services/model/service_response.dart';

class MomentRemoteService {
  static Future<ServiceResponse<List<Moment>>> fetchMoments({
    int page = 1,
    int limit = 20,
    bool group = true,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }

    try {
      final resp = await ApiService.getMoments(
        token: token,
        page: page,
        limit: limit,
        group: group,
      );
      final raw = resp.data;
      debugPrint('[Moment.fromJson] raw moments: $raw');
      final serverMessage = _extractMessage(raw);

      if (!resp.isSuccess || raw is! Map<String, dynamic>) {
        return ServiceResponse(
          isSuccess: false,
          message: serverMessage ?? 'Không tải được moments',
        );
      }

      final data = raw['data'];
      if (data is! List) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Danh sách moments không hợp lệ',
        );
      }

      final moments = <Moment>[];
      for (final group in data.whereType<Map<String, dynamic>>()) {
        final items = group['items'];
        if (items is List) {
          moments.addAll(
            items
                .whereType<Map<String, dynamic>>()
                .map(Moment.fromJson)
                .toList(),
          );
        }
      }

      return ServiceResponse(isSuccess: true, data: moments);
    } catch (_) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
      );
    }
  }

  static Future<ServiceResponse<Moment>> createMoment({
    required String caption,
    required List<String> petIds,
    required List<String> mediaUrls,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }
    try {
      final body = {
        'caption': caption,
        'pet_ids': petIds,
        'media': mediaUrls.map((e) => {'url': e}).toList(),
      };
      final resp = await ApiService.createMoment(token: token, body: body);
      final raw = resp.data;
      final serverMessage = _extractMessage(raw);
      if (!resp.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message: serverMessage ?? 'Đăng kỷ niệm thất bại',
        );
      }
      if (raw is! Map<String, dynamic>) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phản hồi không hợp lệ',
        );
      }
      final data = raw['data'];
      if (data is! Map<String, dynamic>) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Dữ liệu kỷ niệm không hợp lệ',
        );
      }
      return ServiceResponse(isSuccess: true, data: Moment.fromJson(data));
    } catch (_) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
      );
    }
  }

  static Future<ServiceResponse<Moment>> updateMoment({
    required String id,
    required String caption,
    required List<String> petIds,
    required List<String> mediaUrls,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }
    try {
      final body = {
        'caption': caption,
        'pet_ids': petIds,
        'media': mediaUrls.map((e) => {'url': e}).toList(),
      };
      debugPrint('[MomentRemoteService] update body: $body');
      final resp = await ApiService.updateMoment(
        token: token,
        id: id,
        body: body,
      );
      final raw = resp.data;
      final serverMessage = _extractMessage(raw);
      if (!resp.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message: serverMessage ?? 'Cập nhật kỷ niệm thất bại',
        );
      }
      if (raw is! Map<String, dynamic>) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phản hồi không hợp lệ',
        );
      }
      final data = raw['data'];
      if (data is! Map<String, dynamic>) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Dữ liệu kỷ niệm không hợp lệ',
        );
      }
      return ServiceResponse(isSuccess: true, data: Moment.fromJson(data));
    } catch (_) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
      );
    }
  }

  static Future<ServiceResponse<bool>> deleteMoment(String id) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }
    try {
      final resp = await ApiService.deleteMoment(token: token, id: id);
      if (resp.isSuccess) {
        return ServiceResponse(isSuccess: true, data: true);
      }
      final serverMessage = _extractMessage(resp.data);
      return ServiceResponse(
        isSuccess: false,
        message: serverMessage ?? 'Xóa kỷ niệm thất bại',
      );
    } catch (_) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
      );
    }
  }

  static String? _extractMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      final message = body['message'];
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
}
