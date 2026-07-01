import 'package:flutter/material.dart';
import 'app_colors.dart';

/// CAPCAT DESIGN SYSTEM — Typography Tokens
/// Version: v1.2.0-MujiUnifiedComponents
///
/// Font Stack:
///  Primary   → Quicksand    (rounded terminals, warm & friendly)
///  Secondary → Nunito       (elegant, readable at length)
///  Numeric   → Outfit       (geometric, modern for data display)
///  Accent    → Playfair Display (serif — whisper moments only)
///
/// Ensure pubspec.yaml includes these Google Fonts packages:
///   - quicksand
///   - nunito
///   - outfit
///   - playfair_display
class AppTextStyles {
  AppTextStyles._();

  // ─────────────────────────────────────────────────────────
  // FONT FAMILIES
  // ─────────────────────────────────────────────────────────
  static const String _quicksand = 'Quicksand';
  static const String _nunito = 'Nunito';
  static const String _outfit = 'Outfit';
  static const String _playfair = 'Playfair Display';

  // ─────────────────────────────────────────────────────────
  // HIERARCHY SCALE
  // ─────────────────────────────────────────────────────────

  /// displayLarge — Tiêu đề chương, Tên Pet ở Dashboard
  /// Quicksand Bold 32px · line-height 1.2
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _quicksand,
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.deepObsidian,
  );

  /// headlineLarge — Tiêu đề Thẻ Ký ức (Moments Card)
  /// Quicksand Bold 24px · line-height 1.3
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _quicksand,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.deepObsidian,
  );

  /// titleLarge — Tên người dùng, Tiêu đề Chat, Tiêu đề Popup
  /// Quicksand SemiBold 20px · line-height 1.4
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _quicksand,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.deepObsidian,
  );

  /// bodyLarge — Nội dung tin nhắn chat (Boss & Sen)
  /// Quicksand Medium 16px · line-height 1.5
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _quicksand,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.deepObsidian,
  );

  /// bodyMedium — Mô tả hoạt động chăm sóc, thẻ phụ
  /// Nunito Regular 14px · line-height 1.5
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _nunito,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.deepObsidian,
  );

  /// buttonText — Chữ trên nút bấm bo góc tròn chính
  /// Quicksand SemiBold 15px · line-height 1.0
  static const TextStyle buttonText = TextStyle(
    fontFamily: _quicksand,
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: AppColors.pureWhite,
  );

  /// buttonTextDark — Chữ nút trên nền sáng / outline button
  /// Quicksand SemiBold 15px · line-height 1.0
  static const TextStyle buttonTextDark = TextStyle(
    fontFamily: _quicksand,
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: AppColors.deepObsidian,
  );

  /// captionText — Timestamp phụ, chú thích
  /// Nunito Regular 12px · line-height 1.4
  static const TextStyle captionText = TextStyle(
    fontFamily: _nunito,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.hintGray,
  );

  /// numericLabel — Cân nặng, phút đi dạo, mốc thời gian kỹ thuật
  /// Outfit SemiBold 13px · line-height 1.2
  static const TextStyle numericLabel = TextStyle(
    fontFamily: _outfit,
    fontSize: 13.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.deepObsidian,
  );

  /// whisperItalic — Lời thì thầm chiêm nghiệm đêm muộn [Điểm nhấn Serif ĐẶC BIỆT]
  /// Playfair Display Medium Italic 15px · line-height 1.6
  /// ⚠️ Chỉ dùng cho câu triết lý / trích dẫn thơ ca đặc biệt
  static const TextStyle whisperItalic = TextStyle(
    fontFamily: _playfair,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    height: 1.6,
    color: AppColors.deepObsidian,
  );

  // ─────────────────────────────────────────────────────────
  // INPUT FIELD
  // ─────────────────────────────────────────────────────────

  /// inputText — Chữ người dùng gõ vào ô nhập liệu
  /// Quicksand Medium 15px
  static const TextStyle inputText = TextStyle(
    fontFamily: _quicksand,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    color: Color(0xFF262626),
  );

  /// hintText — Chữ gợi ý placeholder
  /// Quicksand Regular 15px
  static const TextStyle hintText = TextStyle(
    fontFamily: _quicksand,
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    color: AppColors.hintGray,
  );

  // ─────────────────────────────────────────────────────────
  // DARK MODE VARIANTS (Cozy Dark — ticket / postcard / game)
  // ─────────────────────────────────────────────────────────

  static TextStyle get displayLargeDark =>
      displayLarge.copyWith(color: AppColors.pureWhite);

  static TextStyle get headlineLargeDark =>
      headlineLarge.copyWith(color: AppColors.pureWhite);

  static TextStyle get titleLargeDark =>
      titleLarge.copyWith(color: AppColors.pureWhite);

  static TextStyle get bodyLargeDark =>
      bodyLarge.copyWith(color: AppColors.milkBeige);

  static TextStyle get bodyMediumDark =>
      bodyMedium.copyWith(color: AppColors.milkBeige);

  static TextStyle get captionTextDark =>
      captionText.copyWith(color: Color(0xFF9E9E9E));

  static TextStyle get numericLabelDark =>
      numericLabel.copyWith(color: AppColors.milkBeige);

  static TextStyle get whisperItalicDark =>
      whisperItalic.copyWith(color: AppColors.warmAmberLight);

  /// Nút Premium (nền trắng trong dark mode)
  static TextStyle get buttonTextPremium =>
      buttonText.copyWith(color: AppColors.charcoalBlack);
}
