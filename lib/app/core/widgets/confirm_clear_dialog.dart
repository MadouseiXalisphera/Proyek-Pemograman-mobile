import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive.dart';

/// Modal konfirmasi "Are you sure? / Clear all / Cancel" (Image 6).
///
/// Reusable: tombol "Hapus semua" di Cart pelanggan dan "Hapus pesanan
/// selesai" di Kitchen memakai modal yang sama. [onConfirm] dipanggil setelah
/// modal ditutup bila user menekan tombol konfirmasi.
Future<void> showClearAllDialog({
  required VoidCallback onConfirm,
  String title = 'Are you sure?',
  String confirmLabel = 'Clear all',
  String? message,
}) async {
  await Get.dialog(
    _ClearAllDialog(
      title: title,
      confirmLabel: confirmLabel,
      message: message,
      onConfirm: onConfirm,
    ),
    barrierColor: Colors.black.withValues(alpha: 0.35),
  );
}

class _ClearAllDialog extends StatelessWidget {
  final String title;
  final String confirmLabel;
  final String? message;
  final VoidCallback onConfirm;

  const _ClearAllDialog({
    required this.title,
    required this.confirmLabel,
    required this.onConfirm,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: context.r(AppSizes.xxl)),
      child: ConstrainedBox(
        // Batasi lebar supaya tidak melebar penuh di tablet/desktop.
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          padding: EdgeInsets.all(context.r(AppSizes.xl)),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(context.r(AppSizes.radiusLg)),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontXl),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (message != null) ...[
                SizedBox(height: context.r(AppSizes.sm)),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontMd),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              SizedBox(height: context.r(AppSizes.xl)),
              SizedBox(
                width: double.infinity,
                height: context.r(AppSizes.tapTargetLg),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(context.r(AppSizes.radiusFull)),
                    ),
                  ),
                  child: Text(
                    confirmLabel,
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontLg),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.r(AppSizes.md)),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontMd),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
