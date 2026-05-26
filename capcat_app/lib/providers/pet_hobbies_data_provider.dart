import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetHobbiesDataState {
  final List<String> allPetHobbies;
  final List<String> recentPetHobbies;

  const PetHobbiesDataState({
    this.allPetHobbies = const <String>[],
    this.recentPetHobbies = const <String>[],
  });

  PetHobbiesDataState copyWith({
    List<String>? allPetHobbies,
    List<String>? recentPetHobbies,
  }) {
    return PetHobbiesDataState(
      allPetHobbies: allPetHobbies ?? this.allPetHobbies,
      recentPetHobbies: recentPetHobbies ?? this.recentPetHobbies,
    );
  }
}

class PetHobbiesDataNotifier extends Notifier<PetHobbiesDataState> {
  @override
  PetHobbiesDataState build() => const PetHobbiesDataState();

  // set both lists at once (e.g. on app init)
  void setAll({List<String>? all, List<String>? recent}) {
    state = state.copyWith(
      allPetHobbies: all != null ? List.unmodifiable(all) : null,
      recentPetHobbies: recent != null ? List.unmodifiable(recent) : null,
    );
  }

  // replace entire allPetHobbies
  void replaceAll(List<String> all) {
    state = state.copyWith(allPetHobbies: List.unmodifiable(all));
  }

  // replace recent list
  void replaceRecent(List<String> recent) {
    state = state.copyWith(recentPetHobbies: List.unmodifiable(recent));
  }

  // add to all
  void addToAll(String hobby) {
    state = state.copyWith(allPetHobbies: [...state.allPetHobbies, hobby]);
  }

  // add to recent (move-to-front if exists)
  void addToRecent(String hobby, {int maxRecent = 10}) {
    final newRecent = List<String>.from(state.recentPetHobbies);
    newRecent.remove(hobby); // ensure uniqueness
    newRecent.insert(0, hobby);
    if (newRecent.length > maxRecent) {
      newRecent.removeRange(maxRecent, newRecent.length);
    }
    state = state.copyWith(recentPetHobbies: List.unmodifiable(newRecent));
  }

  // remove
  void removeFromAll(String hobby) => state = state.copyWith(
    allPetHobbies: state.allPetHobbies.where((h) => h != hobby).toList(),
  );

  void removeFromRecent(String hobby) => state = state.copyWith(
    recentPetHobbies: state.recentPetHobbies.where((h) => h != hobby).toList(),
  );

  // clear recent
  void clearRecent() => state = state.copyWith(recentPetHobbies: <String>[]);
}

final petHobbiesProvider =
    NotifierProvider<PetHobbiesDataNotifier, PetHobbiesDataState>(
      () => PetHobbiesDataNotifier(),
    );
