import 'package:flutter/material.dart';

import '../theme/app_sizes.dart';
import '../utils/responsive.dart';

/// Wrapper adaptive untuk halaman utama (Home, Cart, dll).
///
/// Behavior (Pilihan B - Full Width Responsive):
/// - Mobile: full-width, tanpa constraint
/// - Tablet: full-width juga, tanpa margin samping
/// - Desktop: max 1200px centered, sisanya jadi margin sage
///
/// Pakai widget ini untuk halaman dengan layout konten utama.
/// Untuk halaman khusus seperti Login, pakai [LoginResponsiveWrapper].
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Mobile & Tablet: tanpa constraint, child full-width
    if (!context.isDesktop) {
      return child;
    }

    // Desktop: bungkus dengan max-width
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppSizes.maxContentDesktop,
        ),
        child: child,
      ),
    );
  }
}

/// Wrapper khusus halaman Login.
///
/// Behavior:
/// - Mobile: full-width
/// - Tablet & Desktop: max 480 centered (form login tidak perlu lebar)
class LoginResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const LoginResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Mobile: full-width
    if (context.isMobile) {
      return child;
    }

    // Tablet & Desktop: max 480 centered
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppSizes.maxLoginCentered,
        ),
        child: child,
      ),
    );
  }
}
