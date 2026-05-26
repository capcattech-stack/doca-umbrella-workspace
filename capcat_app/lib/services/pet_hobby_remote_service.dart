// services/remote/pet_hobby_remote_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/services/extension/response_extension.dart';
import 'package:flutter_chat_mock_app/models/pet_hobby_master_data.dart';

class PetHobbyRemoteService {
  static Future<List<PetHobbyMasterData>> getAll() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("Chưa đăng nhập hoặc token không hợp lệ");
    }

    final response = await ApiService.getPetMasterDataHobbies(token);
    debugPrint(
      '[PetHobbyRemoteService getAll()] ${response.statusCode} ${response.data}',
    );

    if (response.isSuccess) {
      final body = response.data as Map<String, dynamic>;
      final listRaw = body['data'];
      if (listRaw is! List) {
        throw Exception(
          'Response không đúng định dạng: thiếu "data" dạng List',
        );
      }
      return listRaw
          .map((e) => PetHobbyMasterData.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      (response.data is Map && (response.data as Map)['message'] != null)
          ? (response.data as Map)['message']
          : 'Không lấy được PetHobby',
    );
  }
}
