import 'package:flutter_chat_mock_app/repositories/pet_hobby_repository.dart';
import 'package:flutter_chat_mock_app/storage/pet_hobby_local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/models/pet_hobby_master_data.dart';

final _petHobbyLocalStorageProvider = Provider((_) => PetHobbyLocalStorage());

final _petHobbyRepositoryProvider = Provider<PetHobbyRepository>((ref) {
  return PetHobbyRepository(local: ref.read(_petHobbyLocalStorageProvider));
});

final petHobbyProvider =
    AsyncNotifierProvider<PetHobbyController, List<PetHobbyMasterData>>(
      () => PetHobbyController(),
    );

class PetHobbyController extends AsyncNotifier<List<PetHobbyMasterData>> {
  @override
  Future<List<PetHobbyMasterData>> build() async {
    final repo = ref.read(_petHobbyRepositoryProvider);

    // 1) emit local trước (nếu có)
    final localData = await repo.local.read();
    state = AsyncData(localData ?? []);

    // 2) refresh nền sau
    _refreshSilently();

    return localData ?? [];
  }

  Future<void> _refreshSilently() async {
    final repo = ref.read(_petHobbyRepositoryProvider);
    final prev = state.value ?? [];
    final result = await AsyncValue.guard(repo.refreshRemote);
    result.when(
      data: (list) => state = AsyncData(list),
      error: (_, __) => state = AsyncData(prev),
      loading: () {},
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final repo = ref.read(_petHobbyRepositoryProvider);
    state = await AsyncValue.guard(repo.refreshRemote);
  }

  void setFromServer(List<PetHobbyMasterData> list) {
    state = AsyncData(list);
    ref.read(_petHobbyRepositoryProvider).local.save(list);
  }

  Future<void> clear() async {
    final repo = ref.read(_petHobbyRepositoryProvider);
    await repo.clear();
    state = const AsyncData([]);
  }
}
