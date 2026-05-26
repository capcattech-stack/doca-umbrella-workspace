// models/pet_hobby.dart
class PetHobbyMasterData {
  final String type;
  final String code;
  final String name;
  final int? parentId;

  const PetHobbyMasterData({
    required this.type,
    required this.code,
    required this.name,
    this.parentId,
  });

  factory PetHobbyMasterData.fromJson(Map<String, dynamic> json) {
    // strict parsing
    final type = json['type'];
    final code = json['code'];
    final name = json['name'];

    if (type is! String || code is! String || name is! String) {
      throw FormatException('Invalid PetHobby json: $json');
    }

    final parentIdRaw = json['parent_id'];
    int? parentId;
    if (parentIdRaw != null) {
      if (parentIdRaw is int) {
        parentId = parentIdRaw;
      } else if (parentIdRaw is String) {
        parentId = int.tryParse(parentIdRaw);
      } else {
        throw FormatException('Invalid parent_id in PetHobby: $json');
      }
    }

    return PetHobbyMasterData(
      type: type,
      code: code,
      name: name,
      parentId: parentId,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'code': code, 'name': name, 'parent_id': parentId};
  }

  @override
  String toString() =>
      'PetHobby(type: $type, code: $code, name: $name, parentId: $parentId)';
}
