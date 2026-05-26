class PetExtraNote {
  final String? id;
  final String? type;
  final PetExtraNoteData? data;
  final PetExtraNoteCreatedByInfo? createdByInfo;

  const PetExtraNote({this.id, this.type, this.data, this.createdByInfo});

  String get text => data?.text?.trim() ?? '';
  bool get isCreatedByAgent => createdByInfo?.type == 'agent';

  factory PetExtraNote.fromJson(Map<String, dynamic> json) {
    return PetExtraNote(
      id: json['id']?.toString(),
      type: json['type']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? PetExtraNoteData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      createdByInfo: json['created_by_info'] is Map<String, dynamic>
          ? PetExtraNoteCreatedByInfo.fromJson(
              json['created_by_info'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  factory PetExtraNote.fromText(String value) {
    return PetExtraNote(
      type: 'note',
      data: PetExtraNoteData(text: value),
    );
  }
}

class PetExtraNoteCreatedByInfo {
  final String? type;

  const PetExtraNoteCreatedByInfo({this.type});

  factory PetExtraNoteCreatedByInfo.fromJson(Map<String, dynamic> json) {
    return PetExtraNoteCreatedByInfo(type: json['type']?.toString());
  }
}

class PetExtraNoteData {
  final String? text;

  const PetExtraNoteData({this.text});

  factory PetExtraNoteData.fromJson(Map<String, dynamic> json) {
    return PetExtraNoteData(text: json['text']?.toString());
  }
}
