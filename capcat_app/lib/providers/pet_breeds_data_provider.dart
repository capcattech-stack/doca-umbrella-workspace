import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetBreedsDataState {
  final List<String> allPetBreeds;
  final List<String> recentPetBreeds;

  const PetBreedsDataState({
    this.allPetBreeds = const <String>[],
    this.recentPetBreeds = const <String>[],
  });

  PetBreedsDataState copyWith({
    List<String>? allPetBreeds,
    List<String>? recentPetBreeds,
  }) {
    return PetBreedsDataState(
      allPetBreeds: allPetBreeds ?? this.allPetBreeds,
      recentPetBreeds: recentPetBreeds ?? this.recentPetBreeds,
    );
  }
}

class PetBreedsDataNotifier extends Notifier<PetBreedsDataState> {
  @override
  PetBreedsDataState build() => const PetBreedsDataState();

  // set both lists at once (e.g. on app init)
  void setAll({List<String>? all, List<String>? recent}) {
    state = state.copyWith(
      allPetBreeds: all != null ? List.unmodifiable(all) : null,
      recentPetBreeds: recent != null ? List.unmodifiable(recent) : null,
    );
  }

  // replace entire allPetBreeds
  void replaceAll(List<String> all) {
    state = state.copyWith(allPetBreeds: List.unmodifiable(all));
  }

  // replace recent list
  void replaceRecent(List<String> recent) {
    state = state.copyWith(recentPetBreeds: List.unmodifiable(recent));
  }

  // add to all
  void addToAll(String breed) {
    state = state.copyWith(allPetBreeds: [...state.allPetBreeds, breed]);
  }

  // add to recent (move-to-front if exists)
  void addToRecent(String breed, {int maxRecent = 10}) {
    final newRecent = List<String>.from(state.recentPetBreeds);
    newRecent.remove(breed); // ensure uniqueness
    newRecent.insert(0, breed);
    if (newRecent.length > maxRecent) {
      newRecent.removeRange(maxRecent, newRecent.length);
    }
    state = state.copyWith(recentPetBreeds: List.unmodifiable(newRecent));
  }

  // remove
  void removeFromAll(String breed) => state = state.copyWith(
    allPetBreeds: state.allPetBreeds.where((b) => b != breed).toList(),
  );

  void removeFromRecent(String breed) => state = state.copyWith(
    recentPetBreeds: state.recentPetBreeds.where((b) => b != breed).toList(),
  );

  // clear recent
  void clearRecent() => state = state.copyWith(recentPetBreeds: <String>[]);
}

final petBreedsProvider =
    NotifierProvider<PetBreedsDataNotifier, PetBreedsDataState>(
      () => PetBreedsDataNotifier(),
    );
