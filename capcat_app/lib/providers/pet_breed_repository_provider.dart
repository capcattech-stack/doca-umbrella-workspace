// providers/pet_breed_repository_provider.dart
import 'package:flutter_chat_mock_app/storage/pet_breed_local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/models/pet_breed_master_data.dart';
import 'package:flutter_chat_mock_app/repositories/pet_breed_repository.dart';

final _petBreedLocalStorageProvider = Provider((_) => PetBreedLocalStorage());

final _petBreedRepositoryProvider = Provider<PetBreedRepository>((ref) {
  return PetBreedRepository(local: ref.read(_petBreedLocalStorageProvider));
});

final petBreedProvider =
    AsyncNotifierProvider<PetBreedController, List<PetBreedMasterData>>(
      () => PetBreedController(),
    );

class PetBreedController extends AsyncNotifier<List<PetBreedMasterData>> {
  @override
  Future<List<PetBreedMasterData>> build() async {
    final repo = ref.read(_petBreedRepositoryProvider);

    // 1) Emit local trước
    final localData = await repo.local.read();
    state = AsyncData(localData ?? []);

    // 2) Refresh nền
    _refreshSilently();

    return localData ?? [];
  }

  Future<void> _refreshSilently() async {
    final repo = ref.read(_petBreedRepositoryProvider);
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
    final repo = ref.read(_petBreedRepositoryProvider);
    state = await AsyncValue.guard(repo.refreshRemote);
  }

  void setFromServer(List<PetBreedMasterData> list) {
    state = AsyncData(list);
    final repo = ref.read(_petBreedRepositoryProvider);
    repo.local.save(list);
  }

  Future<void> clear() async {
    final repo = ref.read(_petBreedRepositoryProvider);
    await repo.clear();
    state = const AsyncData([]);
  }
}
