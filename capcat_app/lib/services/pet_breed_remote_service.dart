import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/models/pet_breed_master_data.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/services/extension/response_extension.dart';

class PetBreedRemoteService {
  /// Tải toàn bộ breed (gộp các trang nếu có).
  static Future<List<PetBreedMasterData>> getAll({int pageSize = 100}) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("Chưa đăng nhập hoặc token không hợp lệ");
    }

    int currentPage = 1;
    int totalPage = 1;
    final List<PetBreedMasterData> all = [];

    do {
      final response = await ApiService.getPetMasterDataBreeds(
        token,
        page: currentPage,
        limit: pageSize,
      );
      debugPrint(
        '[PetBreedRemoteService getAll()] page=$currentPage status=${response.statusCode}',
      );

      if (!response.isSuccess) {
        // Ưu tiên message từ server
        final message = (response.data is Map<String, dynamic>)
            ? (response.data['message'] as String?)
            : null;
        throw Exception(message ?? 'Không lấy được danh sách PetBreed');
      }

      final body = response.data as Map<String, dynamic>;
      final dataList = body['data'] as List<dynamic>;
      final pageBreeds = dataList
          .map((e) => PetBreedMasterData.fromJson(e as Map<String, dynamic>))
          .toList();
      all.addAll(pageBreeds);

      // Đọc pagination
      final metadata = body['metadata'] as Map<String, dynamic>?;
      if (metadata != null) {
        totalPage = (metadata['total_page'] as num).toInt();
      } else {
        totalPage = 1;
      }

      currentPage++;
    } while (currentPage <= totalPage);

    return all;
  }
}
