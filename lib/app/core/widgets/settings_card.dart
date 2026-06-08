import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive.dart';
import 'responsive_wrapper.dart';

/// Field read-only bergaya pill (abu-abu) dengan ikon di kanan.
/// Dipakai di kartu Settings untuk menampilkan username / nama meja / role.
class ReadOnlyField extends StatelessWidget {
  final String value;
  final IconData icon;

  const ReadOnlyField({super.key, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.r(56),
      padding: EdgeInsets.symmetric(horizontal: context.r(AppSizes.lg)),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(context.r(AppSizes.radiusFull)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontMd),
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Icon(icon, color: AppColors.textSecondary, size: context.r(22)),
        ],
      ),
    );
  }
}

/// Kartu Settings reusable (user & kitchen).
///
/// Layout body-only: judul halaman besar di kiri-atas, lalu kartu netral
/// berisi judul (nama meja / role), field-field read-only, dan tombol Logout
/// merah. Tombol Logout memanggil [onLogout] (biasanya push konfirmasi
/// password), bukan langsung logout — supaya logikanya konsisten.
class SettingsCard extends StatelessWidget {
  final String cardTitle;
  final List<Widget> fields;
  final VoidCallback onLogout;

  const SettingsCard({
    super.key,
    required this.cardTitle,
    required this.fields,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.r(AppSizes.lg)),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.r(AppSizes.lg)),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontDisplay),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.r(AppSizes.xl)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: context.r(AppSizes.xl),
                vertical: context.r(AppSizes.xxl),
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius:
                    BorderRadius.circular(context.r(AppSizes.radiusXl)),
              ),
              child: Column(
                children: [
                  Text(
                    cardTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontDisplay),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: context.r(AppSizes.xl)),
                  for (int i = 0; i < fields.length; i++) ...[
                    fields[i],
                    SizedBox(height: context.r(AppSizes.lg)),
                  ],
                  SizedBox(height: context.r(AppSizes.sm)),
                  SizedBox(
                    width: double.infinity,
                    height: context.r(AppSizes.tapTargetLg),
                    child: ElevatedButton(
                      onPressed: onLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              context.r(AppSizes.radiusFull)),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: context.rf(AppSizes.fontLg),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
