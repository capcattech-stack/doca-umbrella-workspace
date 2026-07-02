import 'package:capcat_doca/models/chat_pet.dart';
import 'package:capcat_doca/services/chat_pet_remote_service.dart';

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
