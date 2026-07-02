import 'package:capcat_doca/providers/pet_form_providers.dart';

enum PetGender {
  male('MALE', 'Đực'),
  female('FEMALE', 'Cái'),
  other('OTHER', 'Khác');

  final String value;
  final String label;

  const PetGender(this.value, this.label);

  static PetGender fromValue(String value) {
    return PetGender.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PetGender.other,
    );
  }
}

// ---------------------------------------------------------------------------
//  MODEL: PetPersona
// ---------------------------------------------------------------------------
class PetPersona {
  final String key;
  final String name;
  final String description;
  final String iconUrl;
  final List<String> traits;
  final List<String> tones;
  final List<String> styles;
  final List<String> hobbies;
  final String callPetAs;
  final String selfReferenceAs;

  const PetPersona({
    required this.key,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.traits,
    required this.tones,
    required this.styles,
    required this.hobbies,
    required this.callPetAs,
    required this.selfReferenceAs,
  });

  factory PetPersona.fromJson(Map<String, dynamic> json) {
    return PetPersona(
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['icon_url'] ?? '',
      traits: List<String>.from(json['traits'] ?? []),
      tones: List<String>.from(json['tones'] ?? []),
      styles: List<String>.from(json['styles'] ?? []),
      hobbies: List<String>.from(json['hobbies'] ?? []),
      callPetAs: json['call_pet_as'] ?? '',
      selfReferenceAs: json['self_reference_as'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'name': name,
    'description': description,
    'icon_url': iconUrl,
    'traits': traits,
    'tones': tones,
    'styles': styles,
    'hobbies': hobbies,
    'call_pet_as': callPetAs,
    'self_reference_as': selfReferenceAs,
  };
}

// ---------------------------------------------------------------------------
//  MODEL: PetDetail
// ---------------------------------------------------------------------------
class PetDetail {
  final String id;
  final String name;
  final String? avatarUrl;
  final List<String>? gallery;
  final int? togetherDays;
  final int? daysUntilBirthday;
  final String? birthDate;
  final double? weight;
  final String? weightSince;
  final PetGender gender;
  final String speciesCode; // <-- thay vì PetSpeciesOption
  final String breed;
  final String? hairColor;
  final String? size;
  final int? socialView;
  final int? socialComment;
  final String? appearanceDetail;
  final String? birthday;
  final String? adoptedDate;
  final int? age;
  final String? ageString;
  // NEW: tuổi người
  final double? humanAge;
  // NEW: trạng thái pet
  final String? status;
  // NEW: timestamp
  final String? createdAt;
  // NEW: timestamps
  final String? updatedAt;
  final String? shareUrl;
  final String? description;
  final int? personaTemplateId;
  final String? selfTerm;
  final String? ownerTerm;
  final bool isNeutered;
  final List<String>? hobby;
  // NEW: tính cách rời rạc
  final List<String>? personality;
  // NEW: tóm tắt sở thích/không thích/khác
  final PetBrief? brief;
  // NEW: giai đoạn phát triển
  final LifeStage? lifeStage;
  // NEW: các user profile liên quan
  final List<PetUserProfile>? userProfiles;
  // NEW: quan hệ pet - người
  final List<PetRelationship>? petRelationships;
  final PetPersona? persona;
  final String? whisper;

  PetDetail({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.gallery,
    this.togetherDays,
    this.daysUntilBirthday,
    this.birthDate,
    this.weight,
    this.weightSince,
    required this.gender,
    required this.speciesCode,
    required this.breed,
    this.hairColor,
    this.size,
    this.socialView,
    this.socialComment,
    this.appearanceDetail,
    this.birthday,
    this.adoptedDate,
    this.age,
    this.ageString,
    this.humanAge,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.shareUrl,
    this.description,
    this.personaTemplateId,
    this.selfTerm,
    this.ownerTerm,
    required this.isNeutered,
    this.hobby,
    this.personality,
    this.brief,
    this.lifeStage,
    this.userProfiles,
    this.petRelationships,
    this.persona,
    this.whisper,
  });

  PetDetail copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    List<String>? gallery,
    int? togetherDays,
    int? daysUntilBirthday,
    String? birthDate,
    double? weight,
    String? weightSince,
    PetGender? gender,
    String? speciesCode,
    String? breed,
    String? hairColor,
    String? size,
    int? socialView,
    int? socialComment,
    String? appearanceDetail,
    String? birthday,
    String? adoptedDate,
    int? age,
    String? ageString,
    double? humanAge,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? shareUrl,
    String? description,
    int? personaTemplateId,
    String? selfTerm,
    String? ownerTerm,
    bool? isNeutered,
    List<String>? hobby,
    List<String>? personality,
    PetBrief? brief,
    LifeStage? lifeStage,
    List<PetUserProfile>? userProfiles,
    List<PetRelationship>? petRelationships,
    PetPersona? persona,
    String? whisper,
  }) {
    return PetDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gallery: gallery ?? this.gallery,
      togetherDays: togetherDays ?? this.togetherDays,
      daysUntilBirthday: daysUntilBirthday ?? this.daysUntilBirthday,
      birthDate: birthDate ?? this.birthDate,
      weight: weight ?? this.weight,
      weightSince: weightSince ?? this.weightSince,
      gender: gender ?? this.gender,
      speciesCode: speciesCode ?? this.speciesCode,
      breed: breed ?? this.breed,
      hairColor: hairColor ?? this.hairColor,
      size: size ?? this.size,
      socialView: socialView ?? this.socialView,
      socialComment: socialComment ?? this.socialComment,
      appearanceDetail: appearanceDetail ?? this.appearanceDetail,
      birthday: birthday ?? this.birthday,
      adoptedDate: adoptedDate ?? this.adoptedDate,
      age: age ?? this.age,
      ageString: ageString ?? this.ageString,
      humanAge: humanAge ?? this.humanAge,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      shareUrl: shareUrl ?? this.shareUrl,
      description: description ?? this.description,
      personaTemplateId: personaTemplateId ?? this.personaTemplateId,
      selfTerm: selfTerm ?? this.selfTerm,
      ownerTerm: ownerTerm ?? this.ownerTerm,
      isNeutered: isNeutered ?? this.isNeutered,
      hobby: hobby ?? this.hobby,
      personality: personality ?? this.personality,
      brief: brief ?? this.brief,
      lifeStage: lifeStage ?? this.lifeStage,
      userProfiles: userProfiles ?? this.userProfiles,
      petRelationships: petRelationships ?? this.petRelationships,
      persona: persona ?? this.persona,
      whisper: whisper ?? this.whisper,
    );
  }

  factory PetDetail.fromForm(PetFormData data, {String? id}) {
    return PetDetail(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      avatarUrl: data.avatarUrl,
      name: data.name!,
      gender: data.gender,
      speciesCode: data.speciesCode ?? '', // <-- lấy code
      breed: data.breed ?? '',
      weight: data.weight,
      hairColor: data.hairColor,
      birthday: data.birthday,
      adoptedDate: data.adoptedDate,
      description: data.description,
      appearanceDetail: data.appearanceDetail,
      personaTemplateId: data.personaTemplateId,
      selfTerm: data.petTerm,
      ownerTerm: data.ownerTerm,
      isNeutered: data.isNeutered,
      hobby: data.hobby,
      persona: null,
      whisper: null,
    );
  }

  Map<String, dynamic> toCacheJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'gallery': gallery,
      'togetherDays': togetherDays,
      'daysUntilBirthday': daysUntilBirthday,
      'birthDate': birthDate,
      'weight': weight,
      'weightSince': weightSince,
      'gender': gender.value,
      'speciesCode': speciesCode,
      'breed': breed,
      'hairColor': hairColor,
      'size': size,
      'socialView': socialView,
      'socialComment': socialComment,
      'appearanceDetail': appearanceDetail,
      'birthday': birthday,
      'adoptedDate': adoptedDate,
      'age': age,
      'ageString': ageString,
      'shareUrl': shareUrl,
      'description': description,
      'personaTemplateId': personaTemplateId,
      'selfTerm': selfTerm,
      'ownerTerm': ownerTerm,
      'isNeutered': isNeutered,
      'hobby': hobby,
      'persona': persona?.toJson(),
      'whisper': whisper,
    };
  }

  factory PetDetail.fromCacheJson(Map<String, dynamic> json) {
    return PetDetail(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      gallery: json['gallery'] != null
          ? List<String>.from(json['gallery'] as List)
          : null,
      togetherDays: json['togetherDays'] as int?,
      daysUntilBirthday: json['daysUntilBirthday'] as int?,
      birthDate: json['birthDate'] as String?,
      weight: _toDouble(json['weight']),
      weightSince: json['weightSince'] as String?,
      gender: PetGender.fromValue(json['gender']?.toString() ?? 'OTHER'),
      speciesCode: json['speciesCode']?.toString() ?? '',
      breed: json['breed']?.toString() ?? '',
      hairColor: json['hairColor'] as String?,
      size: json['size']?.toString(),
      socialView: json['socialView'] as int?,
      socialComment: json['socialComment'] as int?,
      appearanceDetail: json['appearanceDetail'] as String?,
      birthday: json['birthday'] as String?,
      adoptedDate: json['adoptedDate'] as String?,
      age: json['age'] as int?,
      ageString: json['ageString'] as String?,
      humanAge: _toDouble(json['humanAge']),
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      shareUrl: json['shareUrl'] as String?,
      description: json['description'] as String?,
      personaTemplateId: json['personaTemplateId'] as int?,
      selfTerm: json['selfTerm'] as String?,
      ownerTerm: json['ownerTerm'] as String?,
      isNeutered: json['isNeutered'] as bool? ?? false,
      hobby: json['hobby'] != null
          ? List<String>.from(json['hobby'] as List)
          : null,
      personality: json['personality'] != null
          ? List<String>.from(json['personality'] as List)
          : null,
      brief: json['brief'] != null
          ? PetBrief.fromJson(json['brief'] as Map<String, dynamic>)
          : null,
      lifeStage: json['lifeStage'] != null
          ? LifeStage.fromJson(json['lifeStage'] as Map<String, dynamic>)
          : null,
      userProfiles: json['userProfiles'] != null
          ? (json['userProfiles'] as List)
                .map((e) => PetUserProfile.fromJson(e))
                .toList()
          : null,
      petRelationships: json['petRelationships'] != null
          ? (json['petRelationships'] as List)
                .map((e) => PetRelationship.fromJson(e))
                .toList()
          : null,
      persona: json['persona'] != null
          ? PetPersona.fromJson(json['persona'] as Map<String, dynamic>)
          : null,
      whisper: json['whisper'] as String?,
    );
  }

  // ✅ Parse from JSON
  factory PetDetail.fromJson(Map<String, dynamic> json) {
    final aiAgent = json['ai_agent'];
    final personaJson = aiAgent != null ? aiAgent['persona'] : null;
    final whisper = aiAgent != null ? aiAgent['whisper'] as String? : null;

    return PetDetail(
      id: _toString(json['id']) ?? '',
      name: _toString(json['name']) ?? '',
      avatarUrl: _toString(json['avatar']) ?? _toString(json['avatar_url']),
      speciesCode: _toString(json['species']) ?? '', // <-- chỉ lưu code
      breed: _toString(json['breed']) ?? '',
      gender: PetGender.fromValue(_toString(json['gender']) ?? 'OTHER'),
      isNeutered: _toBool(json['is_sterilized']) ?? false,
      weight: _toDouble(json['weight']),
      birthday: _toString(json['birthday']),
      adoptedDate: _toString(json['adopted_at']),
      description: _toString(json['bio']),
      appearanceDetail: _toString(json['description']),
      personaTemplateId: _toInt(json['persona_template_id']),
      selfTerm: _toString(json['self_term']),
      ownerTerm: _toString(json['owner_term']),
      hobby: _toListString(json['hobbies']),
      age: _toInt(json['age']),
      ageString: _toString(json['age_str']),
      humanAge: _toDouble(json['human_age']),
      status: _toString(json['status']),
      createdAt: _toString(json['created_at']),
      updatedAt: _toString(json['updated_at']),
      shareUrl: _toString(json['share_url']),
      togetherDays: _parseDurationToDays(json['adoptedDuration']),
      gallery: null,
      daysUntilBirthday: _toInt(json['nextBirthdayIn']),
      birthDate: _toString(json['birthday']),
      size: _toString(json['size']),
      hairColor: _toString(json['color']),
      socialView: _toInt(json['social_view']),
      socialComment: _toInt(json['social_comment']),
      personality: _toListString(json['personality']),
      brief: json['brief'] is Map<String, dynamic>
          ? PetBrief.fromJson(json['brief'] as Map<String, dynamic>)
          : null,
      lifeStage: json['life_stage'] is Map<String, dynamic>
          ? LifeStage.fromJson(json['life_stage'] as Map<String, dynamic>)
          : null,
      userProfiles: json['user_profiles'] is List
          ? (json['user_profiles'] as List)
                .map((e) => PetUserProfile.fromJson(e))
                .toList()
          : null,
      petRelationships: json['pet_relationships'] is List
          ? (json['pet_relationships'] as List)
                .map((e) => PetRelationship.fromJson(e))
                .toList()
          : null,
      persona: personaJson != null ? PetPersona.fromJson(personaJson) : null,
      whisper: whisper,
    );
  }

  static int? _parseDurationToDays(dynamic durationObj) {
    if (durationObj is Map<String, dynamic>) {
      final years = durationObj['years'] ?? 0;
      final months = durationObj['months'] ?? 0;
      final days = durationObj['days'] ?? 0;
      return (years * 365) + (months * 30) + days;
    }
    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String? _toString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    final str = value.toString().toLowerCase();
    if (str == 'true') return true;
    if (str == 'false') return false;
    return null;
  }

  static List<String>? _toListString(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return null;
  }
}

// ---------------------------------------------------------------------------
//  MODELS: LifeStage, PetBrief, UserProfiles, Relationships
// ---------------------------------------------------------------------------

class LifeStage {
  final String? key;
  final String? label;
  final int? startMonth;
  final int? endMonth;
  final LifeStageDetail? detail;

  LifeStage({
    this.key,
    this.label,
    this.startMonth,
    this.endMonth,
    this.detail,
  });

  factory LifeStage.fromJson(Map<String, dynamic> json) => LifeStage(
    key: json['key'] as String?,
    label: json['label'] as String?,
    startMonth: PetDetail._toInt(json['start_month']),
    endMonth: PetDetail._toInt(json['end_month']),
    detail: json['detail'] != null
        ? LifeStageDetail.fromJson(json['detail'] as Map<String, dynamic>)
        : null,
  );
}

class LifeStageDetail {
  final String? short;
  final List<String>? bullets;
  final List<String>? careTips;
  final List<String>? healthWatch;

  LifeStageDetail({this.short, this.bullets, this.careTips, this.healthWatch});

  factory LifeStageDetail.fromJson(Map<String, dynamic> json) =>
      LifeStageDetail(
        short: json['short'] as String?,
        bullets: json['bullets'] != null
            ? List<String>.from(json['bullets'] as List)
            : null,
        careTips: json['care_tips'] != null
            ? List<String>.from(json['care_tips'] as List)
            : null,
        healthWatch: json['health_watch'] != null
            ? List<String>.from(json['health_watch'] as List)
            : null,
      );
}

class PetBrief {
  final List<String>? traits;
  final List<String>? likes;
  final List<String>? dislikes;
  final List<String>? diet;
  final List<String>? extras;

  PetBrief({this.traits, this.likes, this.dislikes, this.diet, this.extras});

  factory PetBrief.fromJson(Map<String, dynamic> json) => PetBrief(
    traits: json['traits'] != null ? List<String>.from(json['traits']) : null,
    likes: json['likes'] != null ? List<String>.from(json['likes']) : null,
    dislikes: json['dislikes'] != null
        ? List<String>.from(json['dislikes'])
        : null,
    diet: json['diet'] != null ? List<String>.from(json['diet']) : null,
    extras: json['extras'] != null ? List<String>.from(json['extras']) : null,
  );
}

class PetUserProfile {
  final String? id;
  final String? accountId;
  final String? avatar;
  final String? fullName;
  final String? gender;
  final String? dob;
  final String? phone;
  final String? email;
  final String? address;

  PetUserProfile({
    this.id,
    this.accountId,
    this.avatar,
    this.fullName,
    this.gender,
    this.dob,
    this.phone,
    this.email,
    this.address,
  });

  factory PetUserProfile.fromJson(Map<String, dynamic> json) => PetUserProfile(
    id: json['id'] as String?,
    accountId: json['account_id'] as String?,
    avatar: json['avatar'] as String?,
    fullName: json['full_name'] as String?,
    gender: json['gender'] as String?,
    dob: json['dob'] as String?,
    phone: json['phone'] as String?,
    email: json['email'] as String?,
    address: json['address'] as String?,
  );
}

class PetRelationship {
  final String? personId;
  final String? petId;
  final String? type;
  final String? callPetAs;
  final String? selfReferenceAs;
  final String? status;

  PetRelationship({
    this.personId,
    this.petId,
    this.type,
    this.callPetAs,
    this.selfReferenceAs,
    this.status,
  });

  factory PetRelationship.fromJson(Map<String, dynamic> json) =>
      PetRelationship(
        personId: json['person_id'] as String?,
        petId: json['pet_id'] as String?,
        type: json['type'] as String?,
        callPetAs: json['call_pet_as'] as String?,
        selfReferenceAs: json['self_reference_as'] as String?,
        status: json['status'] as String?,
      );
}
