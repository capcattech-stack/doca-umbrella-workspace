// file: providers/pet_species_repository_provider.dart
import 'package:flutter_chat_mock_app/storage/pet_species_local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/models/pet_species_master_data.dart';
import 'package:flutter_chat_mock_app/repositories/pet_species_repository.dart';

final _petSpeciesLocalStorageProvider = Provider(
  (_) => PetSpeciesLocalStorage(),
);

final _petSpeciesRepositoryProvider = Provider<PetSpeciesRepository>((ref) {
  return PetSpeciesRepository(local: ref.read(_petSpeciesLocalStorageProvider));
});

final petSpeciesProvider =
    AsyncNotifierProvider<PetSpeciesController, List<PetSpeciesMasterData>>(
      () => PetSpeciesController(),
    );

class PetSpeciesController extends AsyncNotifier<List<PetSpeciesMasterData>> {
  @override
  Future<List<PetSpeciesMasterData>> build() async {
    final repo = ref.read(_petSpeciesRepositoryProvider);

    // 1) đọc local trước
    final localData = await repo.local.read();
    state = AsyncData(localData ?? []);

    // 2) refresh remote sau (ngầm)
    _refreshSilently();

    return localData ?? [];
  }

  Future<void> _refreshSilently() async {
    final repo = ref.read(_petSpeciesRepositoryProvider);
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
    final repo = ref.read(_petSpeciesRepositoryProvider);
    state = await AsyncValue.guard(repo.refreshRemote);
  }

  void setFromServer(List<PetSpeciesMasterData> list) {
    state = AsyncData(list);
    final repo = ref.read(_petSpeciesRepositoryProvider);
    repo.local.save(list);
  }

  Future<void> clear() async {
    final repo = ref.read(_petSpeciesRepositoryProvider);
    await repo.clear();
    state = const AsyncData([]);
  }
}
