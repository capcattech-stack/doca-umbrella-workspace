import 'package:flutter_chat_mock_app/models/chat_pet.dart';
import 'package:flutter_chat_mock_app/services/chat_pet_remote_service.dart';

class ChatPetRepository {
  Future<List<ChatPet>> fetchPets() async {
    final response = await ChatPetRemoteService.getChatPets();
    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    throw Exception(
      response.message ?? 'Không tải được danh sách bé cưng, vui lòng thử lại.',
    );
  }
}
