import 'package:flutter/material.dart';

import '../constants/app_branding.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

/// Logo aplikasi. Bila [AppBranding.logoAssetPath] diisi → render gambar;
/// kalau kosong → ikon cangkir di lingkaran forest (placeholder siap diganti).
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    final s = context.r(size);

    if (AppBranding.logoAssetPath.isNotEmpty) {
      return Image.asset(
        AppBranding.logoAssetPath,
        width: s,
        height: s,
        fit: BoxFit.contain,
      );
    }

    return Container(
      width: s,
      height: s,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.local_cafe_rounded,
        color: Colors.white,
        size: s * 0.5,
      ),
    );
  }
}
