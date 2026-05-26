import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/models/pet_persona_template_master_data.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/services/extension/response_extension.dart';
import 'package:flutter_chat_mock_app/services/model/service_response.dart';

class PetPersonaTemplateRemoteService {
  static Future<List<PetPersonaTemplateMasterData>> getAll() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("Chưa đăng nhập hoặc token không hợp lệ");
    }

    final response = await ApiService.getPetPersonaTemplates(token);
    debugPrint('[PetPersonaTemplateRemoteService getAll()]$response');

    if (response.isSuccess) {
      final body = response.data as Map<String, dynamic>;
      final list = (body['data'] as List<dynamic>)
          .map(
            (e) => PetPersonaTemplateMasterData.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
      return list;
    }

    throw Exception(
      response.data?['message'] ?? 'Không lấy được PetPersonaTemplate',
    );
  }

  static Future<ServiceResponse> getPetPersonaTemplateDetail(
    int personaTemplateId,
  ) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
      }

      final response = await ApiService.getPetPersonaTemplateDetail(
        token,
        personaTemplateId,
      );

      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message:
              response.data['message'] ??
              'Không thể tải thông tin persona template',
        );
      }

      final data = response.data['data'];
      final persona = PetPersonaTemplateMasterData.fromJson(data);
      return ServiceResponse(isSuccess: true, data: persona);
    } catch (e) {
      debugPrint('[PetService.getPetPersonaTemplateDetail] error: $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }
}
