import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_decorations.dart';

/// CAPCAT DESIGN SYSTEM — ThemeData
/// Version: v1.2.0-MujiUnifiedComponents
///
/// Usage in main.dart:
///
///   MaterialApp(
///     theme: AppTheme.light,
///     darkTheme: AppTheme.dark,
///     themeMode: ThemeMode.system,
///     ...
///   )
class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────────────────
  // COZY LIGHT THEME (Chủ đạo — Trang chủ, Chat, Thư viện)
  // ─────────────────────────────────────────────────────────
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Quicksand',

      // Color Scheme
      colorScheme: const ColorScheme.light(
        background: AppColors.pureWhite,
        surface: AppColors.milkBeige,
        primary: AppColors.charcoalBlack,
        onPrimary: AppColors.pureWhite,
        secondary: AppColors.sakuraPink,
        onSecondary: AppColors.deepObsidian,
        tertiary: AppColors.matchaGreen,
        onTertiary: AppColors.deepObsidian,
        error: Color(0xFFB71C1C),
        onError: AppColors.pureWhite,
        onBackground: AppColors.deepObsidian,
        onSurface: AppColors.deepObsidian,
        outline: AppColors.borderLight,
        surfaceVariant: AppColors.oatmealBg,
        onSurfaceVariant: AppColors.hintGray,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.pureWhite,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.pureWhite,
        foregroundColor: AppColors.deepObsidian,
        elevation: 0,
        shadowColor: Colors.transparent,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: AppTextStyles.titleLarge,
        iconTheme: IconThemeData(color: AppColors.deepObsidian, size: 22),
      ),

      // Card
      cardTheme: CardTheme(
        color: AppColors.pureWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusCard),
          side: const BorderSide(color: AppColors.borderLight, width: 1.0),
        ),
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),

      // ElevatedButton (Primary)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.charcoalBlack,
          foregroundColor: AppColors.pureWhite,
          disabledBackgroundColor: AppColors.borderLight,
          disabledForegroundColor: AppColors.hintGray,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppDecorations.radiusButton),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.buttonText,
        ),
      ),

      // OutlinedButton (Secondary)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.oatmealBg,
          foregroundColor: AppColors.deepObsidian,
          side: const BorderSide(color: AppColors.borderLight, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppDecorations.radiusButton),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.buttonTextDark,
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.deepObsidian,
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),

      // InputDecoration (shared default)
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.paperCream,
        filled: true,
        hintStyle: AppTextStyles.hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppDecorations.radiusTag),
          borderSide:
              const BorderSide(color: AppColors.borderLight, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppDecorations.radiusTag),
          borderSide: const BorderSide(
              color: AppColors.charcoalBlack, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppDecorations.radiusTag),
          borderSide:
              const BorderSide(color: Color(0xFFB71C1C), width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppDecorations.radiusTag),
          borderSide:
              const BorderSide(color: Color(0xFFB71C1C), width: 1.5),
        ),
      ),

      // BottomSheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.paperCream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDecorations.radiusBottomSheet),
          ),
        ),
        constraints: BoxConstraints(maxHeight: double.infinity),
      ),

      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusCard),
          side: const BorderSide(color: AppColors.borderLight, width: 1.0),
        ),
        titleTextStyle: AppTextStyles.titleLarge,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1.0,
        space: 0,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        headlineLarge: AppTextStyles.headlineLarge,
        titleLarge: AppTextStyles.titleLarge,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.captionText,
        labelSmall: AppTextStyles.numericLabel,
        labelLarge: AppTextStyles.buttonText,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AppColors.deepObsidian,
        size: 22.0,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.charcoalBlack,
        contentTextStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusButton),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.oatmealBg,
        disabledColor: AppColors.borderLight,
        selectedColor: AppColors.charcoalBlack,
        secondarySelectedColor: AppColors.charcoalBlack,
        labelStyle: AppTextStyles.captionText,
        secondaryLabelStyle:
            AppTextStyles.captionText.copyWith(color: AppColors.pureWhite),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusTag),
          side: const BorderSide(color: AppColors.borderLight),
        ),
        elevation: 0,
        pressElevation: 0,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // COZY DARK THEME (Chuyên biệt — Swipe Game, Postcard, Ticket)
  // ─────────────────────────────────────────────────────────
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Quicksand',

      colorScheme: const ColorScheme.dark(
        background: AppColors.darkSlate,
        surface: AppColors.ticketCharcoal,
        primary: AppColors.pureWhite,
        onPrimary: AppColors.charcoalBlack,
        secondary: AppColors.neonHealingGreen,
        onSecondary: AppColors.charcoalBlack,
        error: Color(0xFFFFCDD2),
        onError: Color(0xFFB71C1C),
        onBackground: AppColors.milkBeige,
        onSurface: AppColors.pureWhite,
        outline: AppColors.ticketBorder,
      ),

      scaffoldBackgroundColor: AppColors.darkSlate,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSlate,
        foregroundColor: AppColors.pureWhite,
        elevation: 0,
        shadowColor: Colors.transparent,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(color: AppColors.pureWhite, size: 22),
      ),

      cardTheme: CardTheme(
        color: AppColors.ticketCharcoal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.radiusCard),
          side: const BorderSide(color: AppColors.ticketBorder, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pureWhite,
          foregroundColor: AppColors.charcoalBlack,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppDecorations.radiusButton),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLargeDark,
        headlineLarge: AppTextStyles.headlineLargeDark,
        titleLarge: AppTextStyles.titleLargeDark,
        bodyLarge: AppTextStyles.bodyLargeDark,
        bodyMedium: AppTextStyles.bodyMediumDark,
        bodySmall: AppTextStyles.captionTextDark,
        labelSmall: AppTextStyles.numericLabelDark,
      ),

      iconTheme: const IconThemeData(
        color: AppColors.pureWhite,
        size: 22.0,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.ticketBorder,
        thickness: 1.0,
        space: 0,
      ),
    );
  }
}
