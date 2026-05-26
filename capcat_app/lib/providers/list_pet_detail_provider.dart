// file: pet_detail_providers.dart
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/repositories/pet_list_repository.dart';
import 'package:flutter_chat_mock_app/storage/pet_list_local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _petListLocalStorageProvider = Provider((_) => PetListLocalStorage());
final _petListRepositoryProvider = Provider(
  (ref) => PetListRepository(
    local: ref.read(_petListLocalStorageProvider),
    ttl: const Duration(minutes: 10),
  ),
);

final listPetDetailProvider =
    AsyncNotifierProvider<PetListController, List<PetDetail>>(
      () => PetListController(),
    );

class PetListController extends AsyncNotifier<List<PetDetail>> {
  @override
  Future<List<PetDetail>> build() async {
    final repo = ref.read(_petListRepositoryProvider);
    final policy = await repo.getLocalWithPolicy();
    final localPets = policy.localPets;
    if (localPets.isEmpty) {
      state = const AsyncLoading();
      try {
        final pets = await repo.refreshRemote();
        state = AsyncData(pets);
        return pets;
      } catch (e, st) {
        state = AsyncError(e, st);
        rethrow;
      }
    }

    state = AsyncData(localPets);

    if (policy.shouldRefresh) {
      _refreshSilently();
    }
    return localPets;
  }

  Future<void> _refreshSilently() async {
    final repo = ref.read(_petListRepositoryProvider);
    final prev = state.value ?? <PetDetail>[];
    final result = await AsyncValue.guard(repo.refreshRemote);
    result.when(
      data: (pets) => state = AsyncData(pets),
      error: (_, __) => state = AsyncData(prev),
      loading: () {},
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final repo = ref.read(_petListRepositoryProvider);
    final next = await AsyncValue.guard(repo.refreshRemote);
    state = next;
  }

  Future<void> replaceAll(List<PetDetail> pets) async {
    state = AsyncData(List<PetDetail>.from(pets));
    await ref.read(_petListRepositoryProvider).cache(pets);
  }

  Future<void> upsertPet(PetDetail pet) async {
    final current = [...(state.value ?? <PetDetail>[])];
    final index = current.indexWhere((p) => p.id == pet.id);
    if (index == -1) {
      current.add(pet);
    } else {
      current[index] = pet;
    }
    state = AsyncData(current);
    await ref.read(_petListRepositoryProvider).cache(current);
  }

  Future<void> updatePetFields({
    required String petId,
    int? personaTemplateId,
    String? selfTerm,
    String? ownerTerm,
    List<String>? hobby,
  }) async {
    final current = [...(state.value ?? <PetDetail>[])];
    final index = current.indexWhere((p) => p.id == petId);
    if (index != -1) {
      final pet = current[index];
      current[index] = pet.copyWith(
        personaTemplateId: personaTemplateId ?? pet.personaTemplateId,
        selfTerm: selfTerm ?? pet.selfTerm,
        ownerTerm: ownerTerm ?? pet.ownerTerm,
        hobby: hobby ?? pet.hobby,
      );
      state = AsyncData(current);
      await ref.read(_petListRepositoryProvider).cache(current);
    }
  }

  Future<void> addPet(PetDetail pet) async {
    final current = [...(state.value ?? <PetDetail>[])];
    current.add(pet);
    state = AsyncData(current);
    await ref.read(_petListRepositoryProvider).cache(current);
  }

  Future<void> removePet(String id) async {
    final current = [...(state.value ?? <PetDetail>[])];
    final updated = current.where((p) => p.id != id).toList();
    state = AsyncData(updated);
    await ref.read(_petListRepositoryProvider).cache(updated);
  }

  Future<void> clear() async {
    final repo = ref.read(_petListRepositoryProvider);
    await repo.clear();
    state = const AsyncData([]);
  }
}

/// Provider cho pet được chọn
final selectedPetIdProvider = StateProvider<String?>((ref) => null);

/// Provider lấy pet theo id
final petByIdProvider = Provider.family<PetDetail?, String>((ref, petId) {
  final asyncPets = ref.watch(listPetDetailProvider);
  final pets = asyncPets.value;
  if (pets == null) return null;
  try {
    return pets.firstWhere((p) => p.id == petId);
  } catch (_) {
    return null;
  }
});
