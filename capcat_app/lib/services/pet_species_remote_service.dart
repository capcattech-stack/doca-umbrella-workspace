import 'package:flutter/material.dart';
import 'package:capcat_doca/models/pet_species_master_data.dart';
import 'package:capcat_doca/services/api_service.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/services/extension/response_extension.dart';

class PetSpeciesRemoteService {
  /// Lấy toàn bộ species (không phân trang trong UI), nhưng vẫn support page/limit nếu backend cần
  static Future<List<PetSpeciesMasterData>> getAll({
    int page = 1,
    int limit = 100,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("Chưa đăng nhập hoặc token không hợp lệ");
    }

    final response = await ApiService.getPetMasterDataSpecies(
      token,
      page: page,
      limit: limit,
    );
    debugPrint(
      '[PetSpeciesRemoteService.getAll] status=${response.statusCode}',
    );

    if (response.isSuccess) {
      final body = response.data as Map<String, dynamic>;
      final list = (body['data'] as List<dynamic>)
          .map((e) => PetSpeciesMasterData.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    }

    throw Exception(
      response.data?['message'] ?? 'Không lấy được danh sách species',
    );
  }
}
