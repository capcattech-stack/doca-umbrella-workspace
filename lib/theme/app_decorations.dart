import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// CAPCAT DESIGN SYSTEM — Decoration & Shape Tokens
/// Version: v1.2.0-MujiUnifiedComponents
///
/// Covers:
///  - Border Radius (cozyCard, cozyButton, cozyTag, cozyAvatar)
///  - BoxDecoration presets (Light card, Dark ticket, Input, Badge)
///  - Shadow specs (Cozy Light, Cozy Dark)
///  - Glassmorphism containers
///  - InputDecoration factory
class AppDecorations {
  AppDecorations._();

  // ─────────────────────────────────────────────────────────
  // BORDER RADIUS TOKENS
  // ─────────────────────────────────────────────────────────

  /// Thẻ bài chính, pop-up dialog
  static const double radiusCard = 16.0;

  /// Nút bấm, panel tương tác, thanh input chat
  static const double radiusButton = 12.0;

  /// Tag phân loại nhỏ (loài pet, nhãn thời gian)
  static const double radiusTag = 8.0;

  /// Avatar phụ của Pet / người dùng
  static const double radiusAvatar = 8.0;

  /// Bottom sheet — góc trên bo, góc dưới vuông
  static const double radiusBottomSheet = 24.0;

  // ─────────────────────────────────────────────────────────
  // SHADOWS — Cozy Ambient Shadows
  // ─────────────────────────────────────────────────────────

  /// Bóng đổ sáng (Light mode) — tán xạ siêu loãng xám yến mạch
  static const List<BoxShadow> cozyShadowLight = [
    BoxShadow(
      color: Color(0x081C1C1E), // rgba(28,28,30, 0.03)
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 8),
    ),
  ];

  /// Bóng đổ tối (Dark mode) — hào quang ấm cam dịu
  static const List<BoxShadow> cozyShadowDark = [
    BoxShadow(
      color: Color(0x0AFFD1BA), // rgba(255,209,186, 0.04)
      blurRadius: 30,
      spreadRadius: 2,
      offset: Offset(0, 10),
    ),
  ];

  /// Bóng nhẹ card (siêu loãng — dùng trong grid)
  static const List<BoxShadow> cozyShadowCardLight = [
    BoxShadow(
      color: Color(0x031C1C1E), // rgba(28,28,30, 0.01)
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];

  // ─────────────────────────────────────────────────────────
  // CARD DECORATIONS — Muji Flat Cards
  // ─────────────────────────────────────────────────────────

  /// Thẻ bài chính (Light mode) — Modernist Flat Card
  static final BoxDecoration lightCardDecoration = BoxDecoration(
    color: AppColors.pureWhite,
    borderRadius: BorderRadius.circular(radiusCard),
    border: Border.all(color: AppColors.borderLight, width: 1.0),
    boxShadow: cozyShadowLight,
  );

  /// Thẻ bài nhỏ dạng lưới (Grid category card)
  static final BoxDecoration lightGridCardDecoration = BoxDecoration(
    color: AppColors.pureWhite,
    borderRadius: BorderRadius.circular(radiusTag),
    border: Border.all(color: AppColors.borderLight, width: 1.0),
    boxShadow: cozyShadowCardLight,
  );

  /// Thẻ Moments (nền giấy Milk Beige)
  static final BoxDecoration momentsCardDecoration = BoxDecoration(
    color: AppColors.milkBeige,
    borderRadius: BorderRadius.circular(radiusCard),
    border: Border.all(color: AppColors.borderLight, width: 1.0),
    boxShadow: cozyShadowLight,
  );

  /// Thẻ Ticket / Postcard / Boarding Pass (Cozy Dark)
  static final BoxDecoration darkTicketDecoration = BoxDecoration(
    color: AppColors.ticketCharcoal,
    borderRadius: BorderRadius.circular(radiusCard),
    border: Border.all(color: AppColors.ticketBorder, width: 1.0),
    boxShadow: cozyShadowDark,
  );

  /// Thẻ Ticket bo góc đặc biệt 28px (Boarding Pass cao cấp)
  static final BoxDecoration boardingPassDecoration = BoxDecoration(
    color: AppColors.ticketCharcoal,
    borderRadius: BorderRadius.circular(28.0),
    border: Border.all(color: AppColors.ticketBorder, width: 1.0),
    boxShadow: cozyShadowDark,
  );

  // ─────────────────────────────────────────────────────────
  // BUTTON DECORATIONS
  // ─────────────────────────────────────────────────────────

  /// Nút hành động chính (Primary) — Light mode
  static final BoxDecoration primaryButtonDecoration = BoxDecoration(
    color: AppColors.charcoalBlack,
    borderRadius: BorderRadius.circular(radiusButton),
  );

  /// Nút hành động chính (Primary) — Dark mode (Premium)
  static final BoxDecoration primaryButtonDarkDecoration = BoxDecoration(
    color: AppColors.pureWhite,
    borderRadius: BorderRadius.circular(radiusButton),
  );

  /// Nút hành động phụ (Secondary Outline)
  static final BoxDecoration secondaryButtonDecoration = BoxDecoration(
    color: AppColors.oatmealBg,
    borderRadius: BorderRadius.circular(radiusButton),
    border: Border.all(color: AppColors.borderLight, width: 1.0),
  );

  /// Nút phụ kính mờ (Dark mode — glassmorphism)
  static final BoxDecoration glassButtonDecoration = BoxDecoration(
    color: AppColors.glassDarkTint,
    borderRadius: BorderRadius.circular(radiusButton),
    border: Border.all(color: AppColors.frostedBorderLight, width: 1.0),
  );

  /// Nút cảm xúc Mèo (Sakura Pink pastel)
  static final BoxDecoration catButtonDecoration = BoxDecoration(
    color: AppColors.sakuraPinkSurface,
    borderRadius: BorderRadius.circular(radiusButton),
  );

  /// Nút cảm xúc Chó (Matcha Green pastel)
  static final BoxDecoration dogButtonDecoration = BoxDecoration(
    color: AppColors.matchaGreenSurface,
    borderRadius: BorderRadius.circular(radiusButton),
  );

  // ─────────────────────────────────────────────────────────
  // BOTTOM SHEET
  // ─────────────────────────────────────────────────────────

  /// Nền Bottom Sheet chuẩn Muji
  static final BoxDecoration bottomSheetDecoration = BoxDecoration(
    color: AppColors.paperCream,
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(radiusBottomSheet),
    ),
    border: Border(
      top: BorderSide(color: AppColors.borderLight, width: 1.0),
    ),
  );

  // ─────────────────────────────────────────────────────────
  // DIALOG
  // ─────────────────────────────────────────────────────────

  /// Hộp thoại chuẩn Muji Warm Dialog
  static final BoxDecoration mujiDialogDecoration = BoxDecoration(
    color: AppColors.pureWhite,
    borderRadius: BorderRadius.circular(radiusCard),
    border: Border.all(color: AppColors.borderLight, width: 1.0),
    boxShadow: cozyShadowLight,
  );

  // ─────────────────────────────────────────────────────────
  // BADGE / TAG
  // ─────────────────────────────────────────────────────────

  static final BoxDecoration successBadge = BoxDecoration(
    color: AppColors.successBg,
    borderRadius: BorderRadius.circular(radiusTag),
  );

  static final BoxDecoration warningBadge = BoxDecoration(
    color: AppColors.warningBg,
    borderRadius: BorderRadius.circular(radiusTag),
  );

  static final BoxDecoration errorBadge = BoxDecoration(
    color: AppColors.errorBg,
    borderRadius: BorderRadius.circular(radiusTag),
  );

  static final BoxDecoration infoBadge = BoxDecoration(
    color: AppColors.infoBg,
    borderRadius: BorderRadius.circular(radiusTag),
  );

  // ─────────────────────────────────────────────────────────
  // INPUT DECORATION FACTORY
  // ─────────────────────────────────────────────────────────

  /// Ô nhập liệu chuẩn Muji Flat Input
  static InputDecoration mujiInput({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Quicksand',
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8C8C8C),
      ),
      fillColor: AppColors.paperCream,
      filled: true,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 14.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusTag),
        borderSide: const BorderSide(
          color: AppColors.borderLight,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusTag),
        borderSide: const BorderSide(
          color: AppColors.charcoalBlack,
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusTag),
        borderSide: const BorderSide(
          color: AppColors.errorBg,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusTag),
        borderSide: const BorderSide(
          color: Color(0xFFB71C1C),
          width: 1.0,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // GLASSMORPHISM CONTAINER BUILDER
  // ─────────────────────────────────────────────────────────

  /// Tạo container kính mờ cho panel bổ trợ (Dark mode)
  /// Backdrop blur: sigmaX / sigmaY = 8.0 ~ 12.0
  static Widget buildGlassContainer({
    required Widget child,
    double sigma = 10.0,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
  }) {
    final radius = borderRadius ?? BorderRadius.circular(radiusCard);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.glassDarkTint,
            borderRadius: radius,
            border: Border.all(
              color: AppColors.frostedBorderLight,
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // DRAG HANDLE (Bottom Sheet)
  // ─────────────────────────────────────────────────────────

  /// Thanh kéo tối giản — 40×4px xám nhạt mờ
  static Widget dragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.borderLight,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
