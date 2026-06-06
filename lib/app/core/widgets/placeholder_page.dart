import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive.dart';

/// Halaman placeholder body-only untuk tab yang belum dibangun.
///
/// Dipakai sementara di dalam IndexedStack shell. Fase berikutnya tinggal
/// mengganti child IndexedStack dengan halaman asli — shell & nav tidak
/// perlu diubah. Sengaja TANPA Scaffold/AppBar karena shell yang menyediakan
/// Scaffold; konvensi tiap halaman tab = konten + judул besar sendiri.
class PlaceholderPage extends StatelessWidget {
  final String title;
  final String phase;
  final IconData icon;

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.phase,
    this.icon = Icons.construction_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.r(AppSizes.xl)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.r(AppSizes.lg)),
            Text(
              title,
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontDisplay),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: context.r(64), color: AppColors.primaryLight),
                    SizedBox(height: context.r(AppSizes.md)),
                    Text(
                      'Akan dibuat di $phase',
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontMd),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
