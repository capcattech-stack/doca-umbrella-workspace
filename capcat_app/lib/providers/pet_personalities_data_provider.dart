import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetPersonalitiesDataState {
  final List<String> allPetPersonalities;
  final List<String> recentPetPersonalities;

  const PetPersonalitiesDataState({
    this.allPetPersonalities = const <String>[],
    this.recentPetPersonalities = const <String>[],
  });

  PetPersonalitiesDataState copyWith({
    List<String>? allPetPersonalities,
    List<String>? recentPetPersonalities,
  }) {
    return PetPersonalitiesDataState(
      allPetPersonalities: allPetPersonalities ?? this.allPetPersonalities,
      recentPetPersonalities:
          recentPetPersonalities ?? this.recentPetPersonalities,
    );
  }
}

class PetPersonalitiesDataNotifier extends Notifier<PetPersonalitiesDataState> {
  @override
  PetPersonalitiesDataState build() => const PetPersonalitiesDataState();

  // set both lists at once (e.g. on app init)
  void setAll({List<String>? all, List<String>? recent}) {
    state = state.copyWith(
      allPetPersonalities: all != null ? List.unmodifiable(all) : null,
      recentPetPersonalities: recent != null ? List.unmodifiable(recent) : null,
    );
  }

  // replace entire allPetPersonalities
  void replaceAll(List<String> all) {
    state = state.copyWith(allPetPersonalities: List.unmodifiable(all));
  }

  // replace recent list
  void replaceRecent(List<String> recent) {
    state = state.copyWith(recentPetPersonalities: List.unmodifiable(recent));
  }

  // add to all
  void addToAll(String breed) {
    state = state.copyWith(
      allPetPersonalities: [...state.allPetPersonalities, breed],
    );
  }

  // add to recent (move-to-front if exists)
  void addToRecent(String breed, {int maxRecent = 10}) {
    final newRecent = List<String>.from(state.recentPetPersonalities);
    newRecent.remove(breed); // ensure uniqueness
    newRecent.insert(0, breed);
    if (newRecent.length > maxRecent) {
      newRecent.removeRange(maxRecent, newRecent.length);
    }
    state = state.copyWith(
      recentPetPersonalities: List.unmodifiable(newRecent),
    );
  }

  // remove
  void removeFromAll(String breed) => state = state.copyWith(
    allPetPersonalities: state.allPetPersonalities
        .where((b) => b != breed)
        .toList(),
  );

  void removeFromRecent(String breed) => state = state.copyWith(
    recentPetPersonalities: state.recentPetPersonalities
        .where((b) => b != breed)
        .toList(),
  );

  // clear recent
  void clearRecent() =>
      state = state.copyWith(recentPetPersonalities: <String>[]);
}

final petPersonalitiesProvider =
    NotifierProvider<PetPersonalitiesDataNotifier, PetPersonalitiesDataState>(
      () => PetPersonalitiesDataNotifier(),
    );
