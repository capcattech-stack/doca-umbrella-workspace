import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:capcat_doca/models/pet_detail.dart';
import 'package:capcat_doca/services/api_service.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/services/extension/response_extension.dart';
import 'package:capcat_doca/services/model/service_response.dart';

class PetListRemoteService {
  static Future<ServiceResponse<List<PetDetail>>> getMyPets() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
      }

      final response = await ApiService.getPets(token);
      // debugPrint('[PetListRemoteService.getMyPets] ${response.statusCode}');
      // debugPrint(
      //   '[PetListRemoteService.getMyPets] raw response: ${jsonEncode(response.data)}',
      // );

      if (response.isSuccess) {
        final data = response.data['data'];
        // debugPrint(
        //   '[PetListRemoteService.getMyPets] data field: ${jsonEncode(data)}',
        // );
        if (data is List) {
          final pets = data
              .whereType<Map<String, dynamic>>()
              .map(PetDetail.fromJson)
              .toList();
          return ServiceResponse<List<PetDetail>>(isSuccess: true, data: pets);
        }
        return ServiceResponse(
          isSuccess: false,
          message: 'Phản hồi từ server không hợp lệ',
        );
      }

      final message =
          _getSafeMessage(response.data) ?? 'Không thể tải danh sách thú cưng';
      return ServiceResponse(isSuccess: false, message: message);
    } catch (e, st) {
      debugPrint('[PetListRemoteService.getMyPets] $e\n$st');
      return ServiceResponse(
        isSuccess: false,
        message: 'Không tải được danh sách, vui lòng thử lại sau',
      );
    }
  }

  static String? _getSafeMessage(dynamic data) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return null;
  }
}
