import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';

class PetFormData {
  final String? id;
  final String? avatarUrl;
  final String? name;
  final PetGender gender;
  final String? speciesCode; // ✅ Thay thế PetSpeciesMasterData
  final String? breed;
  final double? weight;
  final String? hairColor;
  final String? birthday;
  final String? adoptedDate;
  final String? description;
  final String? appearanceDetail;
  final int? personaTemplateId;
  final String? petTerm;
  final String? ownerTerm;
  final bool isNeutered;
  final List<String>? hobby;

  const PetFormData({
    this.id,
    this.avatarUrl,
    this.name,
    this.gender = PetGender.female,
    this.speciesCode, // ✅
    this.breed,
    this.weight,
    this.hairColor,
    this.birthday,
    this.adoptedDate,
    this.description,
    this.appearanceDetail,
    this.personaTemplateId,
    this.petTerm,
    this.ownerTerm,
    this.isNeutered = false,
    this.hobby,
  });

  PetFormData copyWith({
    String? id,
    String? avatarUrl,
    String? name,
    PetGender? gender,
    String? speciesCode, // ✅
    String? breed,
    double? weight,
    String? hairColor,
    String? birthday,
    String? adoptedDate,
    String? description,
    String? appearanceDetail,
    int? personaTemplateId,
    String? petTerm,
    String? ownerTerm,
    bool? isNeutered,
    List<String>? hobby,
  }) {
    return PetFormData(
      id: id ?? this.id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      speciesCode: speciesCode ?? this.speciesCode,
      breed: breed ?? this.breed,
      weight: weight ?? this.weight,
      hairColor: hairColor ?? this.hairColor,
      birthday: birthday ?? this.birthday,
      adoptedDate: adoptedDate ?? this.adoptedDate,
      description: description ?? this.description,
      appearanceDetail: appearanceDetail ?? this.appearanceDetail,
      personaTemplateId: personaTemplateId ?? this.personaTemplateId,
      petTerm: petTerm ?? this.petTerm,
      ownerTerm: ownerTerm ?? this.ownerTerm,
      isNeutered: isNeutered ?? this.isNeutered,
      hobby: hobby ?? this.hobby,
    );
  }

  factory PetFormData.fromPet(PetDetail pet) {
    return PetFormData(
      id: pet.id,
      avatarUrl: pet.avatarUrl,
      name: pet.name,
      gender: pet.gender,
      speciesCode: pet.speciesCode, // ✅
      breed: pet.breed,
      weight: pet.weight,
      hairColor: pet.hairColor,
      birthday: pet.birthday,
      adoptedDate: pet.adoptedDate,
      description: pet.description,
      appearanceDetail: pet.appearanceDetail,
      personaTemplateId: pet.personaTemplateId,
      petTerm: pet.selfTerm,
      ownerTerm: pet.ownerTerm,
      isNeutered: pet.isNeutered,
      hobby: pet.hobby,
    );
  }

  @override
  String toString() {
    return 'PetFormData(id: $id, name: $name, gender: ${gender.name}, avatarUrl: $avatarUrl, '
        'speciesCode: $speciesCode, breed: $breed, weight: $weight, hairColor: $hairColor, '
        'birthday: $birthday, adoptedDate: $adoptedDate, description: $description, '
        'appearanceDetail: $appearanceDetail, personality: $personaTemplateId, '
        'selfTerm: $petTerm, ownerTerm: $ownerTerm, isNeutered: $isNeutered, '
        'hobby: $hobby)';
  }
}

class PetFormDataNotifier extends Notifier<PetFormData> {
  final PetDetail? initialPet;

  PetFormDataNotifier({this.initialPet});

  @override
  PetFormData build() {
    ref.keepAlive();
    return initialPet != null
        ? PetFormData.fromPet(initialPet!)
        : const PetFormData();
  }

  void reset() {
    state = const PetFormData();
    debugPrint('[petFormDataProvider] reset()');
  }

  void setId(String? value) {
    state = state.copyWith(id: value);
    debugPrint('id: $value');
  }

  void setAvatarUrl(String? value) {
    state = state.copyWith(avatarUrl: value);
    debugPrint('avatarUrl: $value');
  }

  void removeAvatarUrl() {
    state = state.copyWith(avatarUrl: '');
  }

  void setName(String? value) {
    state = state.copyWith(name: value);
    debugPrint('name: $value');
  }

  void setGender(PetGender value) {
    state = state.copyWith(gender: value);
    debugPrint('gender: ${value.name}');
  }

  void setSpeciesCode(String? value) {
    state = state.copyWith(speciesCode: value);
    debugPrint('speciesCode: $value');
  }

  void setBreed(String? value) {
    state = state.copyWith(breed: value);
    debugPrint('breed: $value');
  }

  void setWeight(double? value) {
    state = state.copyWith(weight: value);
    debugPrint('weight: $value');
  }

  void setHairColor(String? value) {
    state = state.copyWith(hairColor: value);
    debugPrint('hairColor: $value');
  }

  void setBirthday(String? value) {
    state = state.copyWith(birthday: value);
    debugPrint('birthday: $value');
  }

  void setAdoptedDay(String? value) {
    state = state.copyWith(adoptedDate: value);
    debugPrint('adoptedDate: $value');
  }

  void setDescription(String? value) {
    state = state.copyWith(description: value);
    debugPrint('description: $value');
  }

  void setAppearanceDetail(String? value) {
    state = state.copyWith(appearanceDetail: value);
    debugPrint('appearanceDetail: $value');
  }

  void setPersonality(int? value) {
    state = state.copyWith(personaTemplateId: value);
    debugPrint('personality: $value');
  }

  void setPetTerm(String? value) {
    state = state.copyWith(petTerm: value);
    debugPrint('selfTerm: $value');
  }

  void setOwnerTerm(String? value) {
    state = state.copyWith(ownerTerm: value);
    debugPrint('ownerTerm: $value');
  }

  void setIsNeutered(bool value) {
    state = state.copyWith(isNeutered: value);
    debugPrint('isNeutered: $value');
  }

  void setHobby(List<String>? value) {
    state = state.copyWith(hobby: value);
    debugPrint('hobby: $value');
  }

  void addHobby(String hobby) {
    final newList = List<String>.from(state.hobby ?? []);
    newList.add(hobby);
    state = state.copyWith(hobby: newList);
    debugPrint('add hobby: $hobby');
  }

  void removeHobby(String hobby) {
    final newList = List<String>.from(state.hobby ?? []);
    newList.remove(hobby);
    state = state.copyWith(hobby: newList);
    debugPrint('remove hobby: $hobby');
  }
}

final petFormDataProvider = NotifierProvider<PetFormDataNotifier, PetFormData>(
  () => PetFormDataNotifier(),
);

final petAnalysisDoneProvider = StateProvider<bool>((ref) => false);
final petMasterDataReadyProvider = StateProvider<bool>((ref) => false);
