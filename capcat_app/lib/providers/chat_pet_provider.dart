import 'package:flutter_chat_mock_app/models/chat_pet.dart';
import 'package:flutter_chat_mock_app/repositories/chat_pet_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _chatPetRepositoryProvider = Provider((_) => ChatPetRepository());

final chatPetListProvider =
    AsyncNotifierProvider<ChatPetListController, List<ChatPet>>(
      () => ChatPetListController(),
    );

class ChatPetListController extends AsyncNotifier<List<ChatPet>> {
  @override
  Future<List<ChatPet>> build() => _loadPets();

  Future<List<ChatPet>> _loadPets() async {
    final repo = ref.read(_chatPetRepositoryProvider);
    final pets = await repo.fetchPets();
    return pets;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadPets);
  }
}
