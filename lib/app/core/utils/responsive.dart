import 'package:flutter/widgets.dart';

/// Extension pada BuildContext untuk akses scale factor responsive.
///
/// Breakpoint:
/// - Mobile  : width < 600
/// - Tablet  : 600 <= width < 1024
/// - Desktop : width >= 1024
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  /// Scale factor untuk size element (icon, padding, button, dll)
  double get scale {
    if (isDesktop) return 1.5;
    if (isTablet) return 1.3;
    return 1.0;
  }

  /// Scale factor untuk font (lebih halus dari scale element)
  double get fontScale {
    if (isDesktop) return 1.25;
    if (isTablet) return 1.15;
    return 1.0;
  }

  /// Kalikan nilai mobile dengan scale element.
  /// Contoh: context.r(20) → 20 di hp, 26 di tablet, 30 di laptop
  double r(double mobileValue) => mobileValue * scale;

  /// Kalikan nilai font mobile dengan font scale.
  /// Contoh: context.rf(16) → 16 di hp, 18.4 di tablet, 20 di laptop
  double rf(double mobileFontSize) => mobileFontSize * fontScale;

  /// Helper: jumlah kolom grid untuk daftar menu.
  /// Mobile = 1, Tablet = 2, Desktop = 3
  int get menuGridColumns {
    if (isDesktop) return 3;
    if (isTablet) return 2;
    return 1;
  }

  /// Helper: pilih nilai berdasarkan device size.
  /// Contoh: context.rv(mobile: 16, tablet: 24, desktop: 32)
  /// Nama dipersingkat supaya tidak bentrok dengan GetX responsiveValue.
  T rv<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }
}
