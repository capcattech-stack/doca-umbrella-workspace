enum ImageUploadPurpose {
  userAvatar,
  petAvatar,
  personaTemplateIcon,
  other,
  moment,
}

extension ImageUploadPurposeExtension on ImageUploadPurpose {
  String get value {
    switch (this) {
      case ImageUploadPurpose.userAvatar:
        return 'user_avatar';
      case ImageUploadPurpose.petAvatar:
        return 'pet_avatar';
      case ImageUploadPurpose.personaTemplateIcon:
        return 'persona_template_icon';
      case ImageUploadPurpose.other:
        return 'other';
      case ImageUploadPurpose.moment:
        return 'moment';
    }
  }

  static ImageUploadPurpose? fromValue(String? value) {
    switch (value) {
      case 'user_avatar':
        return ImageUploadPurpose.userAvatar;
      case 'pet_avatar':
        return ImageUploadPurpose.petAvatar;
      case 'persona_template_icon':
        return ImageUploadPurpose.personaTemplateIcon;
      case 'other':
        return ImageUploadPurpose.other;
      case 'moment':
        return ImageUploadPurpose.moment;
      default:
        return null;
    }
  }
}
