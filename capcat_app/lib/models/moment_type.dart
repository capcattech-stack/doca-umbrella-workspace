import 'package:flutter/material.dart';

enum MomentType { emotion, note }

class MomentTypeMeta {
  final String icon;
  final IconData fallbackIcon;
  final String title;

  const MomentTypeMeta({
    required this.icon,
    required this.fallbackIcon,
    required this.title,
  });
}

const Map<MomentType, MomentTypeMeta> momentTypeMeta = {
  MomentType.emotion: MomentTypeMeta(
    icon: 'assets/icons/moment-type-emotion.png',
    fallbackIcon: Icons.favorite,
    title: 'Cảm xúc',
  ),
  MomentType.note: MomentTypeMeta(
    icon: 'assets/icons/moment-type-note.png',
    fallbackIcon: Icons.edit,
    title: 'Ghi chú',
  ),
};
