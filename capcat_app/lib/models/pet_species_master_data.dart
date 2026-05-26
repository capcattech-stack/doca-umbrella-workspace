class PetSpeciesMasterData {
  final int id;
  final String type;
  final String code;
  final String name;
  final int? parentId;

  const PetSpeciesMasterData({
    required this.id,
    required this.type,
    required this.code,
    required this.name,
    required this.parentId,
  });

  factory PetSpeciesMasterData.fromJson(Map<String, dynamic> json) {
    return PetSpeciesMasterData(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      parentId: json['parent_id'] == null
          ? null
          : (json['parent_id'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'code': code,
      'name': name,
      'parent_id': parentId,
    };
  }

  static PetSpeciesMasterData? fromCode(
    String code,
    List<PetSpeciesMasterData> all,
  ) {
    try {
      return all.firstWhere((e) => e.code == code);
    } catch (_) {
      return null;
    }
  }

  static String fromCodeToName(String? code) {
    switch (code) {
      case 'dog':
        return 'Chó';
      case 'cat':
        return 'Mèo';
      default:
        return 'Khác';
    }
  }

  // ✅ So sánh dựa trên code
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PetSpeciesMasterData && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() =>
      'PetSpeciesOption(id: $id, type: $type, code: $code, name: $name, parentId: $parentId)';
}
