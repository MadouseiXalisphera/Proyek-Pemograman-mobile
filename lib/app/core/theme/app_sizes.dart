// Konstanta sizing standar untuk Cafe Amba.
// Pakai bersama context.r() / context.rf() dari responsive.dart.

class AppSizes {
  AppSizes._();

  // Spacing
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  // Icon
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // Tap target (min 44 per Material guidelines)
  static const double tapTargetMin = 44;
  static const double tapTargetMd = 48;
  static const double tapTargetLg = 56;

  // Border radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusFull = 999;

  // Font
  static const double fontXs = 10;
  static const double fontSm = 12;
  static const double fontMd = 14;
  static const double fontLg = 16;
  static const double fontXl = 20;
  static const double fontXxl = 24;
  static const double fontDisplay = 32;

  // ─── Layout adaptive ─────────────────────────────────────────────
  // Pattern baru (Pilihan B):
  // - Mobile: full-width
  // - Tablet: full-width juga (tidak ada margin samping)
  // - Desktop: max 1200, sisanya margin
  static const double maxContentDesktop = 1200;

  // Login khusus — selalu centered, tidak full-width
  // - Mobile: full-width (dibatasi padding aja)
  // - Tablet & Desktop: max 480 centered
  static const double maxLoginCentered = 480;
}
