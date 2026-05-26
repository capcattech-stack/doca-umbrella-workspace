class PetPersonaTemplateMasterData {
  final int id;
  final String key;
  final String name;
  final String description;
  final String iconUrl;
  final List<String> traits;
  final List<String> tones;
  final List<String> styles;
  final String status;

  const PetPersonaTemplateMasterData({
    required this.id,
    required this.key,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.traits,
    required this.tones,
    required this.styles,
    required this.status,
  });

  factory PetPersonaTemplateMasterData.fromJson(Map<String, dynamic> json) {
    return PetPersonaTemplateMasterData(
      id: json['id'] as int,
      key: json['key'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String,
      traits: List<String>.from(json['traits'] as List),
      tones: List<String>.from(json['tones'] as List),
      styles: List<String>.from(json['styles'] as List),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
      'traits': traits,
      'tones': tones,
      'styles': styles,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'PetPersonaTemplate(id: $id, key: $key, name: $name, description: $description, '
        'iconUrl: $iconUrl, traits: $traits, tones: $tones, styles: $styles, status: $status)';
  }
}

class PetPersonaTemplateResponse {
  final List<PetPersonaTemplateMasterData> data;

  const PetPersonaTemplateResponse({required this.data});

  factory PetPersonaTemplateResponse.fromJson(Map<String, dynamic> json) {
    return PetPersonaTemplateResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => PetPersonaTemplateMasterData.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.map((e) => e.toJson()).toList()};
  }

  @override
  String toString() => 'PetPersonaTemplateResponse(data: $data)';
}
