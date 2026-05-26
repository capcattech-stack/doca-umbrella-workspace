// models/pet_breed.dart
class PetBreedMasterData {
  final String type; // "breed"
  final String code; // ví dụ: "phu_quoc"
  final String name; // ví dụ: "Chó Phú Quốc"
  final int parentId; // 1 = dog, 2 = cat (theo backend của bạn)

  const PetBreedMasterData({
    required this.type,
    required this.code,
    required this.name,
    required this.parentId,
  });

  factory PetBreedMasterData.fromJson(Map<String, dynamic> json) {
    // Strict parsing: field nào thiếu/sai kiểu sẽ throw
    return PetBreedMasterData(
      type: json['type'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      parentId: json['parent_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'code': code, 'name': name, 'parent_id': parentId};
  }

  @override
  String toString() =>
      'PetBreed(type: $type, code: $code, name: $name, parentId: $parentId)';
}
