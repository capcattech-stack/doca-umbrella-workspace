import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:capcat_doca/enums/image_upload_purpose.dart';
import 'package:capcat_doca/providers/social_register_data_provider.dart';

class ApiService {
  static Options get _systemHeader =>
      Options(headers: {'system': 'capcat_app'});

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://18.138.61.29:3000',
      //baseUrl: 'http://192.168.1.3:3000',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (_) => true,
      // validateStatus: (status) {
      //   return status != null && status >= 200 && status < 500;
      // },
    ),
  );

  static Future<Response> phoneRegister(
    String name,
    String phoneNumber,
    String password,
    String otp,
  ) {
    return _dio.post(
      '/v1/api/app/auth/register',
      options: _systemHeader,
      data: {
        'name': name,
        'phone': phoneNumber,
        'password': password,
        'otp_code': otp,
      },
    );
  }

  static Future<Response> phoneLogin(String phoneNumber, String password) {
    return _dio.post(
      '/v1/api/app/auth/login',
      options: _systemHeader,
      data: {'phone': phoneNumber, 'password': password},
    );
  }

  static Future<Response> socialRegister(
    SocialRegisterData socialRegisterData,
    String otpCode,
  ) {
    return _dio.post(
      '/v1/api/app/auth/social-register',
      options: _systemHeader,
      data: {
        'external_id': socialRegisterData.externalId,
        'provider': socialRegisterData.provider,
        'first_name': socialRegisterData.firstName,
        'last_name': socialRegisterData.lastName,
        'avatar': socialRegisterData.avatar,
        'email': socialRegisterData.email,
        'expires_at': socialRegisterData.expiresAt,
        'phone': socialRegisterData.phoneNumber,
        'otp_code': otpCode,
      },
    );
  }

  static Future<Response> socialLogin(
    String firebaseUid,
    String socialPlatform,
    String expTimeInString,
  ) {
    return _dio.post(
      '/v1/api/app/auth/social-login',
      options: _systemHeader,
      data: {
        'external_id': firebaseUid,
        'provider': socialPlatform,
        'expires_at': expTimeInString,
      },
    );
  }

  static Future<Response> requestOtp(String phone, String otpType) {
    return _dio.post(
      '/v1/api/app/auth/request-otp',
      options: _systemHeader,
      data: {'phone': phone, "type": otpType},
    );
  }

  static Future<Response> verifyOtp(String phone, String otp) {
    return _dio.post(
      '/v1/api/app/auth/verify-otp',
      options: _systemHeader,
      data: {'phone': phone, 'otp': otp},
    );
  }

  static Future<Response> changeForgotPassword(
    String phone,
    String otp,
    String newPassword,
  ) {
    return _dio.post(
      '/v1/api/app/auth/forgot-password/set-password',
      options: _systemHeader,
      data: {'phone': phone, 'otp': otp, 'new_password': newPassword},
    );
  }

  static Future<Response> changePassword(
    String token,
    String currentPassword,
    String newPassword,
  ) {
    return _dio.put(
      '/v1/api/app/accounts/password',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {'current_password': currentPassword, 'new_password': newPassword},
    );
  }

  static Future<Response> getMyProfile(String token) {
    return _dio.get(
      '/v1/api/app/user-profiles/me',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> updateMyProfile(
    Map<String, dynamic> body,
    String token,
  ) {
    return _dio.put(
      '/v1/api/app/user-profiles/me',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: body,
    );
  }

  static Future<Response> updateUserAvatar(
    String token,
    String imagePath,
    String mimeType,
  ) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imagePath,
        filename: 'avatar.png',
        contentType: DioMediaType.parse(mimeType),
      ),
      // 'image': await File(imagePath).readAsBytes(),
    });
    return _dio.put(
      '/v1/api/app/user-profiles/me/avatar',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: formData,
    );
  }

  static Future<Response> getUploadUrl(
    String token,
    ImageUploadPurpose imageUploadPurpose,
    String mimeType,
  ) {
    return _dio.post(
      '/v1/api/app/stored-files/presigned-upload',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {'purpose': imageUploadPurpose.value, 'mime_type': mimeType},
    );
  }

  static Future<Response> getUploadUrlsMultiple(
    String token,
    ImageUploadPurpose imageUploadPurpose,
    List<String> mimeTypes,
  ) {
    return _dio.post(
      '/v1/api/app/stored-files/presigned-upload/multiple',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {'purpose': imageUploadPurpose.value, 'mime_types': mimeTypes},
    );
  }

  static Future<Response> createMoment({
    required String token,
    required Map<String, dynamic> body,
  }) {
    return _dio.post(
      '/v1/api/app/moments',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: body,
    );
  }

  static Future<Response> updateMoment({
    required String token,
    required String id,
    required Map<String, dynamic> body,
  }) {
    return _dio.put(
      '/v1/api/app/moments/$id',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: body,
    );
  }

  static Future<Response> deleteMoment({
    required String token,
    required String id,
  }) {
    return _dio.delete(
      '/v1/api/app/moments/$id',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> uploadImage(
    String token,
    String uploadUrl,
    String mimeType,
    Uint8List bytes,
  ) {
    return _dio.put(
      uploadUrl,
      // options: Options(headers: {'Authorization': 'Bearer $token'}),
      options: Options(
        headers: {
          Headers.contentTypeHeader: mimeType,
          Headers.contentLengthHeader: bytes.length.toString(),
        },
      ),
      data: Stream.fromIterable([bytes]),
    );
  }

  static Future<Response> getPetAvatarAnalyses({
    required String token,
    required String imageUrl,
    required String name,
    required String gender,
    required bool isSterilized,
  }) {
    return _dio.post(
      '/v1/api/app/ai/pet-avatar-analyses',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {
        'image_url': imageUrl,
        'name': name,
        'gender': gender,
        'is_sterilized': isSterilized,
      },
    );
  }

  static Future<Response> getPetMasterDataSpecies(
    String token, {
    int? page,
    int? limit,
  }) {
    return _dio.get(
      '/v1/api/app/master-data',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      queryParameters: {
        'type': 'species',
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      },
    );
  }

  static Future<Response> getPetMasterDataBreeds(
    String token, {
    int? page,
    int? limit,
  }) {
    return _dio.get(
      '/v1/api/app/master-data',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      queryParameters: {
        'type': 'breed',
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      },
    );
  }

  static Future<Response> getPetPersonaTemplates(String token) {
    return _dio.get(
      '/v1/api/app/persona-templates',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> getPetMasterDataHobbies(
    String token, {
    int? page,
    int? limit,
  }) {
    return _dio.get(
      '/v1/api/app/master-data',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      queryParameters: {
        'type': 'hobby',
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
      },
    );
  }

  static Future<Response> createPet({
    required String token,
    required String avatar,
    required String name,
    required String gender,
    required bool isSterilized,
    required String species,
    required String breed,
    required String color,
    String? bio,
    String? description,
    required double weight,
    required String birthday,
    String? adoptedAt,
    int? id,
  }) {
    return _dio.post(
      '/v1/api/app/pets',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {
        'avatar': avatar,
        'name': name,
        'gender': gender,
        'is_sterilized': isSterilized,
        'species': species,
        'breed': breed,
        'color': color,
        'bio': bio,
        'description': description,
        'weight': weight,
        'birthday': birthday,
        'adopted_at': adoptedAt,
      },
    );
  }

  static Future<Response> updatePet({
    required String token,
    required String id,
    required String avatar,
    required String name,
    required String gender,
    required bool isSterilized,
    required String species,
    required String breed,
    required String color,
    String? bio,
    String? description,
    required double weight,
    required String birthday,
    String? adoptedAt,
  }) {
    final data = {
      'avatar': avatar,
      'name': name,
      'gender': gender,
      'is_sterilized': isSterilized,
      'species': species,
      'breed': breed,
      'color': color,
      'bio': bio,
      'description': description,
      'weight': weight,
      'birthday': birthday,
      'adopted_at': adoptedAt,
    };

    debugPrint('[updatePet] Sending data:\n${data.toString()}');

    return _dio.put(
      '/v1/api/app/pets/$id',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: data,
    );
  }

  static Future<Response> updatePetByFields({
    required String token,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    debugPrint('[updatePetByFields] Sending data:\n${data.toString()}');

    final resp = await _dio.put(
      '/v1/api/app/pets/$id',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: data,
    );
    debugPrint(
      '[updatePetByFields] Response status: ${resp.statusCode}, data: ${resp.data}',
    );
    return resp;
  }

  static Future<Response> updatePetBriefNotes({
    required String token,
    required String id,
    required Map<String, dynamic> data,
  }) {
    debugPrint('[updatePetBriefNotes] Sending data:\n${data.toString()}');
    return _dio.put(
      '/v1/api/app/pets/$id/brief-notes',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: data,
    );
  }

  static Future<Response> getPetExtraNotes({
    required String token,
    required String id,
  }) {
    return _dio.get(
      '/v1/api/app/pets/$id/extra-notes',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> addPetExtraNote({
    required String token,
    required String id,
    required String text,
  }) {
    return _dio.post(
      '/v1/api/app/pets/$id/extra-notes',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {'pet_id': id, 'text': text},
    );
  }

  static Future<Response> createPetAiAgent({
    required String token,
    required String callPetAs,
    required String selfReferenceAs,
    List<String>? hobbies,
    required int personaTemplateId,
    required String petId,
  }) {
    return _dio.post(
      '/v1/api/app/ai-agents',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {
        'call_pet_as': callPetAs,
        'self_reference_as': selfReferenceAs,
        'hobbies': hobbies,
        'persona_template_id': personaTemplateId,
        'pet_id': petId,
      },
    );
  }

  static Future<Response> getPets(String token) {
    return _dio.get(
      '/v1/api/app/pets',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> getChatConversations(
    String token, {
    int page = 1,
    int limit = 20,
    String? agentType,
  }) {
    return _dio.get(
      '/v1/api/app/chat/conversations',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (agentType != null) 'agent_type': agentType,
      },
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> getChatPets(String token) {
    return _dio.get(
      '/v1/api/app/chat/pets',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> getChatWelcome(String token) {
    return _dio.get(
      '/v1/api/app/chat/welcome',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> startChat({
    required String token,
    required String petId,
  }) {
    return _dio.post(
      '/v1/api/app/chat/start',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {'pet_id': petId},
    );
  }

  static Future<Response> getConversationMessages(
    String token, {
    required String conversationId,
    int? cursor,
    int limit = 30,
    String? parentId,
  }) {
    final queryParameters = {
      'limit': limit,
      if (cursor != null) 'cursor': cursor,
      if (parentId != null) 'parent_id': parentId,
    };
    return _dio.get(
      '/v1/api/app/chat/conversations/$conversationId/messages',
      queryParameters: queryParameters,
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> getNannyMessages(
    String token, {
    int? cursor,
    int limit = 30,
    String? parentId,
    String? pinnedStatus,
    bool? isThread,
  }) {
    final queryParameters = {
      'limit': limit,
      if (cursor != null) 'cursor': cursor,
      if (parentId != null && parentId.isNotEmpty) 'parent_id': parentId,
      if (pinnedStatus != null && pinnedStatus.isNotEmpty)
        'pinned_status': pinnedStatus,
      if (isThread != null) 'is_thread': isThread,
    };
    return _dio.get(
      '/v1/api/app/chat/nanny/messages',
      queryParameters: queryParameters,
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> startNanny(String token) {
    return _dio.post(
      '/v1/api/app/chat/nanny/start',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> getNannyWelcome(String token) {
    return _dio.get(
      '/v1/api/app/chat/nanny/welcome',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> setChatMessagePinned({
    required String token,
    required String messageId,
    required bool isPinned,
  }) {
    return _dio.put(
      '/v1/api/app/chat/messages/$messageId/pin',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {'is_pinned': isPinned},
    );
  }

  // static Future<Response> getChatAttachmentPresignedUpload({
  //   required String token,
  //   required int conversationId,
  //   required String mimeType,
  // }) {
  //   return _dio.post(
  //     '/v1/api/app/chat/attachments/presigned-upload',
  //     options: Options(
  //       headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
  //     ),
  //     data: {'conversation_id': conversationId, 'mime_type': mimeType},
  //   );
  // }

  static Future<Response> getChatAttachmentPresignedUploads({
    required String token,
    required String conversationId,
    required List<String> mimeTypes,
  }) {
    return _dio.post(
      '/v1/api/app/chat/attachments/presigned-upload',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {'conversation_id': conversationId, 'mime_types': mimeTypes},
    );
  }

  static Future<Response> getPetDetail(String token, String petId) {
    return _dio.get(
      '/v1/api/app/pets/$petId',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> getPetImages(String token, String petId) {
    return _dio.get(
      '/v1/api/app/pets/$petId/images',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> getPetPersonaTemplateDetail(
    String token,
    int personaTemplateId,
  ) {
    return _dio.get(
      '/v1/api/app/persona-templates/$personaTemplateId',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }

  static Future<Response> sendNumerology({
    required String token,
    required String conversationId,
    required String fullName,
    required String birthdate,
  }) {
    return _dio.post(
      '/v1/api/app/abilities/numerology',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {
        'conversation_id': conversationId,
        'full_name': fullName,
        'birthdate': birthdate,
      },
    );
  }

  static Future<Response> sendZodiac({
    required String token,
    required String conversationId,
    required String birthdate,
    required List<String> zodiacOptions,
  }) {
    return _dio.post(
      '/v1/api/app/abilities/zodiac',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {
        'conversation_id': conversationId,
        'birthdate': birthdate,
        'zodiac_options': zodiacOptions,
      },
    );
  }

  static Future<Response> sendContentGenerate({
    required String token,
    required String conversationId,
    required String imageUrl,
    required String mood,
    required String style,
    required String length,
  }) {
    return _dio.post(
      '/v1/api/app/abilities/content/generate',
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
      data: {
        'conversation_id': conversationId,
        'image_url': imageUrl,
        'mood': mood,
        'style': style,
        'length': length,
      },
    );
  }

  static Future<Response> getMoments({
    required String token,
    int page = 1,
    int limit = 20,
    bool group = false,
  }) {
    return _dio.get(
      '/v1/api/app/moments',
      queryParameters: {'page': page, 'limit': limit, if (group) 'group': true},
      options: Options(
        headers: {'system': 'capcat_app', 'Authorization': 'Bearer $token'},
      ),
    );
  }
}
