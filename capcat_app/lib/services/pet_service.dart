import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/models/pet_extra_note.dart';
import 'package:flutter_chat_mock_app/providers/pet_form_providers.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/services/extension/response_extension.dart';
import 'package:flutter_chat_mock_app/services/model/service_response.dart';

class PetService {
  static Future<ServiceResponse> getPetAvatarAnalyses({
    required String imageUrl,
    required String name,
    required String gender,
    required bool isSterilized,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: '');
      }
      final response = await ApiService.getPetAvatarAnalyses(
        token: token,
        imageUrl: imageUrl,
        name: name,
        gender: gender,
        isSterilized: isSterilized,
      );
      debugPrint('getPetAvatarAnalyses: ${response.statusCode}');

      if (response.isSuccess) {
        final data = response.data['data'];
        return ServiceResponse(isSuccess: true, data: data);
      }

      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint('getPetAvatarAnalyses error: $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }

  static Future<ServiceResponse> createPet(PetFormData form) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: '');
      }

      final response = await ApiService.createPet(
        token: token,
        avatar: form.avatarUrl ?? '',
        name: form.name ?? '',
        gender: form.gender.value,
        isSterilized: form.isNeutered,
        species: form.speciesCode ?? '',
        breed: form.breed ?? '',
        color: form.hairColor ?? '',
        bio: form.description,
        description: form.appearanceDetail,
        weight: form.weight ?? 0,
        birthday: form.birthday ?? '',
        adoptedAt: form.adoptedDate,
      );
      debugPrint('createPet: ${response.statusCode}');

      if (response.isSuccess) {
        final data = response.data['data'];
        return ServiceResponse(isSuccess: true, data: data);
      }

      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint('createPet error: $e');
      return ServiceResponse(isSuccess: false, message: 'Có lỗi xảy ra');
    }
  }

  static Future<ServiceResponse> updatePet(PetFormData form) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: '');
      }

      final response = await ApiService.updatePet(
        token: token,
        id: form.id!,
        avatar: form.avatarUrl ?? '',
        name: form.name ?? '',
        gender: form.gender.value,
        isSterilized: form.isNeutered,
        species: form.speciesCode ?? '',
        breed: form.breed ?? '',
        color: form.hairColor ?? '',
        bio: form.description,
        description: form.appearanceDetail,
        weight: form.weight ?? 0,
        birthday: form.birthday ?? '',
        adoptedAt: form.adoptedDate,
      );
      debugPrint('[updatePet] resp: ${response.data}');

      if (response.isSuccess) {
        final data = response.data['data'];
        return ServiceResponse(isSuccess: true, data: data);
      }

      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint('createPet error: $e');
      return ServiceResponse(isSuccess: false, message: 'Có lỗi xảy ra');
    }
  }

  /// Cập nhật thú cưng chỉ với các field cần thiết (Map key/value).
  static Future<ServiceResponse> updatePetByFields({
    required String id,
    required Map<String, dynamic> fields,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: '');
      }

      final data = Map<String, dynamic>.from(fields)
        ..removeWhere((key, value) => value == null);

      final response = await ApiService.updatePetByFields(
        token: token,
        id: id,
        data: data,
      );
      debugPrint('[updatePetByFields] resp: ${response.data}');

      if (response.isSuccess) {
        final respData = response.data['data'];
        return ServiceResponse(isSuccess: true, data: respData);
      }

      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e, st) {
      debugPrint('updatePetByFields error: $e\n$st');
      return ServiceResponse(isSuccess: false, message: 'Có lỗi xảy ra');
    }
  }

  static Future<ServiceResponse> createPetAiAgent(PetFormData form) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: '');
      }

      final response = await ApiService.createPetAiAgent(
        token: token,
        callPetAs: form.petTerm ?? '',
        selfReferenceAs: form.ownerTerm ?? '',
        hobbies: form.hobby,
        personaTemplateId: form.personaTemplateId ?? 0,
        petId: form.id ?? '',
      );
      debugPrint('createPet: ${response.statusCode}');

      if (response.isSuccess) {
        final data = response.data['data'];
        return ServiceResponse(isSuccess: true, data: data);
      }

      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint('createPet error: $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }

  static Future<ServiceResponse> updatePetBriefNotes({
    required String id,
    required List<String> traits,
    required List<String> likes,
    required List<String> dislikes,
    required List<String> diet,
    List<String>? extras,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: '');
      }

      final data = {
        'traits': traits,
        'likes': likes,
        'dislikes': dislikes,
        'diet': diet,
        if (extras != null) 'extras': extras,
      };

      final response = await ApiService.updatePetBriefNotes(
        token: token,
        id: id,
        data: data,
      );
      debugPrint('[updatePetBriefNotes] resp: ${response.data}');

      if (response.isSuccess) {
        final respData = response.data['data'];
        return ServiceResponse(isSuccess: true, data: respData);
      }

      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e, st) {
      debugPrint('updatePetBriefNotes error: $e\n$st');
      return ServiceResponse(isSuccess: false, message: 'Có lỗi xảy ra');
    }
  }

  static Future<ServiceResponse> getPetExtraNotes({required String id}) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: '');
      }

      final response = await ApiService.getPetExtraNotes(token: token, id: id);
      debugPrint('[getPetExtraNotes] resp: ${response.data}');

      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message: response.data['message'],
        );
      }

      final raw = response.data['data'];
      if (raw is List) {
        final notes = raw
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .map(PetExtraNote.fromJson)
            .toList();
        return ServiceResponse(isSuccess: true, data: notes);
      }
      if (raw is Map<String, dynamic> && raw['extras'] is List) {
        final notes = (raw['extras'] as List)
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .map(PetExtraNote.fromJson)
            .toList();
        return ServiceResponse(isSuccess: true, data: notes);
      }

      return ServiceResponse(isSuccess: true, data: <PetExtraNote>[]);
    } catch (e, st) {
      debugPrint('getPetExtraNotes error: $e\n$st');
      return ServiceResponse(isSuccess: false, message: 'Có lỗi xảy ra');
    }
  }

  static Future<ServiceResponse> addPetExtraNote({
    required String id,
    required String text,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: '');
      }

      final response = await ApiService.addPetExtraNote(
        token: token,
        id: id,
        text: text,
      );
      debugPrint('[addPetExtraNote] resp: ${response.data}');

      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message: response.data['message'],
        );
      }

      final raw = response.data['data'];
      if (raw is Map<String, dynamic>) {
        return ServiceResponse(
          isSuccess: true,
          data: PetExtraNote.fromJson(raw),
        );
      }

      return ServiceResponse(
        isSuccess: true,
        data: PetExtraNote.fromText(text),
      );
    } catch (e, st) {
      debugPrint('addPetExtraNote error: $e\n$st');
      return ServiceResponse(isSuccess: false, message: 'Có lỗi xảy ra');
    }
  }

  static Future<ServiceResponse> getPets() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
      }

      final response = await ApiService.getPets(token);
      debugPrint(response.toString());
      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message:
              response.data['message'] ?? 'Không thể tải danh sách thú cưng',
        );
      }

      final data = response.data['data'];
      debugPrint(data.toString());
      if (data == null || data is! List) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phản hồi từ server không hợp lệ',
        );
      }

      final pets = data.map((e) => PetDetail.fromJson(e)).toList();
      return ServiceResponse(isSuccess: true, data: pets);
    } catch (e, st) {
      debugPrint('[PetService.getPets] error: $e\n$st');
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi không xác định khi tải danh sách thú cưng',
      );
    }
  }

  static Future<ServiceResponse> getPetDetail(String petId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
      }

      final response = await ApiService.getPetDetail(token, petId);
      debugPrint(
        '[PetService.getPetDetail] status: ${response.statusCode}, success: ${response.isSuccess}',
      );
      debugPrint(
        '[PetService.getPetDetail] raw response: ${jsonEncode(response.data)}',
      );
      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message:
              response.data['message'] ?? 'Không thể tải thông tin thú cưng',
        );
      }

      final data = response.data['data'];
      debugPrint(
        '[PetService.getPetDetail] pet data json: ${jsonEncode(data)}',
      );
      final rawLifeStage = data is Map<String, dynamic>
          ? data['life_stage']
          : null;
      debugPrint(
        '[PetService.getPetDetail] life_stage raw json: ${jsonEncode(rawLifeStage)}',
      );
      final pet = PetDetail.fromJson(data);
      return ServiceResponse(isSuccess: true, data: pet);
    } catch (e) {
      debugPrint('[PetService.getPetDetail] error: $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }

  static Future<ServiceResponse> getPetImages(String petId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
      }

      final response = await ApiService.getPetImages(token, petId);
      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message:
              response.data['message'] ?? 'Không thể tải danh sách hình ảnh',
        );
      }

      final data = response.data['data'];
      if (data is List) {
        final urls = data
            .map((e) => (e['url'] ?? '').toString())
            .where((e) => e.isNotEmpty)
            .toList();
        return ServiceResponse(isSuccess: true, data: urls);
      }

      return ServiceResponse(
        isSuccess: false,
        message: 'Phản hồi hình ảnh không hợp lệ',
      );
    } catch (e) {
      debugPrint('[PetService.getPetImages] error: $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }
}
