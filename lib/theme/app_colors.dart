import 'package:flutter/material.dart';

/// CAPCAT DESIGN SYSTEM — Color Tokens
/// Version: v1.2.0-MujiUnifiedComponents
/// Philosophy: Iyashikei · Muji Warmth · Cozy Healing
///
/// Palette is split into:
///  - Cozy Light (default, used in Home / Library / Chat / Settings)
///  - Cozy Dark  (specialised: Swipe Game / Postcard / Boarding Pass / Premium)
///  - Emotional Accents (Japanese cultural identity)
///  - Semantic Soft Colors (system feedback)
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────────────────
  // COZY LIGHT — Chủ đạo hệ thống (Default)
  // ─────────────────────────────────────────────────────────

  /// Nền ứng dụng chính — sạch sẽ, rộng rãi, chuẩn Muji (Cloud)
  static const Color pureWhite = Color(0xFFFBFAF6);

  /// Nền phụ / nền lưới danh mục — Oatmeal Background (Sand)
  static const Color oatmealBg = Color(0xFFE8E3D6);

  /// Bề mặt giấy thủ công — nền thẻ Moments (Paper)
  static const Color milkBeige = Color(0xFFF4F1E9);

  /// Nền input / bottom sheet — giấy tái chế kem nhạt (Cloud)
  static const Color paperCream = Color(0xFFFBFAF6);

  /// Chữ chính trên nền sáng — dịu mắt nhưng rõ nét (Charcoal)
  static const Color deepObsidian = Color(0xFF15170F);

  /// Nút hành động chính (Primary Button) — đen than đá sẫm (Charcoal)
  static const Color charcoalBlack = Color(0xFF15170F);

  /// Viền / đường phân cách tối giản
  static const Color borderLight = Color(0xFFEAEAEA);

  /// Chữ gợi ý (Hint Text) — xám tro mờ
  static const Color hintGray = Color(0xFF8C8C8C);

  // ─────────────────────────────────────────────────────────
  // COZY DARK — Chuyên biệt (Swipe Game · Postcard · Ticket)
  // ─────────────────────────────────────────────────────────

  /// Bóng đêm vô cực — nền Game quẹt thẻ / Postcard
  static const Color darkSlate = Color(0xFF0D0D0D);

  /// Thẻ Ticket / Boarding Pass — bo góc 28px sang trọng
  static const Color ticketCharcoal = Color(0xFF1E1F24);

  /// Viền thẻ Ticket — xám tối tế nhị
  static const Color ticketBorder = Color(0xFF2C2C2E);

  /// Màu nhấn phát sáng — mục tiêu, mốc đo lường, nút Premium
  static const Color neonHealingGreen = Color(0xFF76C123);

  /// Ánh đèn ngủ ấm áp — vạt nắng dịu đêm
  static const Color warmAmberLight = Color(0xFFFFF9C4);

  // ─────────────────────────────────────────────────────────
  // EMOTIONAL ACCENTS — Màu nhấn truyền thống Nhật Bản (Matcha & Sakura V2)
  // ─────────────────────────────────────────────────────────

  // Sakura Pink (Hồng Anh Đào) - 3 Phiên bản mới
  /// Hồng Anh Đào Pastel — Boss Mèo, tim thân mật, ngọt ngào mùa xuân (Mặc định)
  static const Color sakuraPink = Color(0xFFF4ABBE);
  static const Color sakuraPinkPastel = Color(0xFFF4ABBE);
  /// Hồng Anh Đào Rực — Tương phản mạnh với Brand green
  static const Color sakuraPinkBright = Color(0xFFE07090);
  /// Tím Hồng Mauve — Hơi hướng bí ẩn, sang trọng
  static const Color sakuraPinkMauve = Color(0xFFC470A0);

  /// Nền nút cưng nựng Mèo (sakuraPinkPastel @ 15%)
  static const Color sakuraPinkSurface = Color(0x26F4ABBE);

  // Matcha Green (Earthy Zen) - 3 Phiên bản mới
  /// Xanh Matcha Ấm Áp — Boss Chó, cảm giác gần gũi, đi dạo (Mặc định)
  static const Color matchaGreen = Color(0xFF8FBF4F);
  static const Color matchaGreenWarm = Color(0xFF8FBF4F);
  /// Xanh Matcha Đậm / Lá Rừng — Dùng làm nền banner, độ tương phản cao
  static const Color matchaGreenForest = Color(0xFF4A8A2E);
  /// Xanh Matcha Nền Tối — Nền tối, phong cách premium kết hợp với brand green
  static const Color matchaGreenDark = Color(0xFF1F3E12);
  /// Nền kem Matcha ấm áp phối cùng Matcha Warm
  static const Color matchaCreamWarm = Color(0xFFF5EDD5);

  /// Nền nút cưng nựng Chó (matchaGreenWarm @ 15%)
  static const Color matchaGreenSurface = Color(0x268FBF4F);

  // Wood Accents (3 màu gỗ Nhật Bản truyền thống)
  /// Gỗ Sugi (Tuyết tùng) — Ấm áp, trung tính
  static const Color woodSugi = Color(0xFF8B5E3C);
  /// Gỗ Kogecha (Nâu cháy) — Đậm đà, nền tối truyền thống
  static const Color woodKogecha = Color(0xFF4A2418);
  /// Gỗ Kohaku (Hổ phách) — Sơn mài, tre già vàng óng
  static const Color woodKohaku = Color(0xFFB8860A);

  /// Chat bubble của Sen (người dùng) — Peach ấm áp
  static const Color catPastelPeach = Color(0xFFFFD1BA);

  // ─────────────────────────────────────────────────────────
  // SEMANTIC SOFT COLORS — Màu nhận diện trạng thái hệ thống
  // ─────────────────────────────────────────────────────────

  /// Thành công — Cozy Success (Pastel Sage Green)
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color successText = Color(0xFF4E6A3E);

  /// Cảnh báo — Cozy Warning (Soft Apricot Orange)
  static const Color warningBg = Color(0xFFFFE0B2);
  static const Color warningText = Color(0xFF7A4E00);

  /// Lỗi / Khẩn cấp — Cozy Error (Dusty Cherry Pink)
  static const Color errorBg = Color(0xFFFFCDD2);
  static const Color errorText = Color(0xFFB71C1C);

  /// Thông tin — Cozy Info (Pale Sky Blue)
  static const Color infoBg = Color(0xFFE1F5FE);
  static const Color infoText = Color(0xFF01579B);

  // ─────────────────────────────────────────────────────────
  // GRADIENTS — Dải màu chuyển cảm xúc
  // ─────────────────────────────────────────────────────────

  /// 1. Vạt Nắng Xiên (Warm Sunbeams) — loading, Moments ban ngày
  static const Gradient warmSunbeams = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF9C4), // Warm Amber Light 100%
      Color(0x66FFD1BA), // Cat Pastel Peach 40%
    ],
  );

  /// 2. Hoàng Hôn Ga Tàu (Twilight Station) — giao diện chat đêm muộn
  static const Gradient twilightStation = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF120E2E),
      Color(0xFF121212),
    ],
  );

  /// 3. Hơi Ấm Trái Tim (Heartbeat Warmth) — mở khóa Ký Ức, nâng cấp thân mật
  static const Gradient heartbeatWarmth = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFE5D9),
      Color(0xFFFFFFFF),
    ],
  );

  // ─────────────────────────────────────────────────────────
  // GLASSMORPHISM TINT COLORS
  // ─────────────────────────────────────────────────────────

  /// Kính mờ — Cozy Dark tint overlay
  static const Color glassDarkTint = Color(0x0FFFFFFF); // white 6%
  static const Color glassDarkOverlay = Color(0x66000000); // black 40%

  /// Kính mờ — Cozy Light tint overlay
  static const Color glassLightTint = Color(0xB3FFFFFF); // white 70%

  /// Frosted border top-left
  static const Color frostedBorderLight = Color(0x14FFFFFF); // white 8%

  /// Frosted border bottom-right
  static const Color frostedBorderDark = Color(0x05FFFFFF); // white 2%
}
