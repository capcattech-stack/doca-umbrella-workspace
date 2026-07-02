import 'package:capcat_doca/repositories/pet_persona_template_repository.dart';
import 'package:capcat_doca/storage/pet_persona_template_local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pet_persona_template_master_data.dart';

final _petPersonaTemplateLocalStorageProvider = Provider(
  (_) => PetPersonaTemplateLocalStorage(),
);

final _petPersonaTemplateRepositoryProvider =
    Provider<PetPersonaTemplateRepository>((ref) {
      return PetPersonaTemplateRepository(
        local: ref.read(_petPersonaTemplateLocalStorageProvider),
      );
    });

final petPersonaTemplateProvider =
    AsyncNotifierProvider<
      PetPersonaTemplateController,
      List<PetPersonaTemplateMasterData>
    >(() => PetPersonaTemplateController());

class PetPersonaTemplateController
    extends AsyncNotifier<List<PetPersonaTemplateMasterData>> {
  @override
  Future<List<PetPersonaTemplateMasterData>> build() async {
    final repo = ref.read(_petPersonaTemplateRepositoryProvider);

    // 1) đọc local trước
    final localData = await repo.local.read();
    state = AsyncData(localData ?? []);

    // 2) refresh remote sau
    _refreshSilently();

    return localData ?? [];
  }

  Future<void> _refreshSilently() async {
    final repo = ref.read(_petPersonaTemplateRepositoryProvider);
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
    final repo = ref.read(_petPersonaTemplateRepositoryProvider);
    state = await AsyncValue.guard(repo.refreshRemote);
  }

  void setFromServer(List<PetPersonaTemplateMasterData> list) {
    state = AsyncData(list);
    final repo = ref.read(_petPersonaTemplateRepositoryProvider);
    repo.local.save(list);
  }

  Future<void> clear() async {
    final repo = ref.read(_petPersonaTemplateRepositoryProvider);
    await repo.clear();
    state = const AsyncData([]);
  }
}
