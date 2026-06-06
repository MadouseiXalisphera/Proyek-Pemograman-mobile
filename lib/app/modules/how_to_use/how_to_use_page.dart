import 'package:flutter/material.dart';

import '../../core/constants/how_to_use_content.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';

/// Tab How to Use (Image 8): kartu putih berisi judul + daftar langkah.
/// Body-only — shell yang menyediakan Scaffold + bottom nav.
class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveWrapper(
        child: Padding(
          padding: EdgeInsets.all(context.r(AppSizes.lg)),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: context.r(AppSizes.xl),
              vertical: context.r(AppSizes.xxl),
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(context.r(AppSizes.radiusLg)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    HowToUseContent.title,
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontXl),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: context.r(AppSizes.xl)),
                for (final item in HowToUseContent.items)
                  Padding(
                    padding: EdgeInsets.only(bottom: context.r(AppSizes.md)),
                    child: _Bullet(text: item),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: context.r(8),
            right: context.r(AppSizes.md),
          ),
          child: Container(
            width: context.r(6),
            height: context.r(6),
            decoration: const BoxDecoration(
              color: AppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontMd),
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
