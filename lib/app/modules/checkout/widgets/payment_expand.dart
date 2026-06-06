import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_menu_image.dart';
import '../../../data/models/order_model.dart';
import '../checkout_controller.dart';

/// Section pembayaran yang muncul (expand) setelah "Confirm & Pay".
/// Isi menyesuaikan metode: Cash / Transfer (no rek + salin) / QRIS (gambar +
/// unduh), lalu tombol upload bukti yang akan diteruskan ke kasir.
class PaymentExpand extends GetView<CheckoutController> {
  const PaymentExpand({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final method = controller.paymentMethod.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppColors.border, height: 32),
          Text(
            'Pembayaran',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontLg),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.r(AppSizes.md)),

          if (method == PaymentMethod.cash) _cashInfo(context),
          if (method == PaymentMethod.transfer) _transferInfo(context),
          if (method == PaymentMethod.qris) _qrisInfo(context),

          // Upload bukti hanya untuk metode yang butuh verifikasi.
          if (controller.requiresProof) ...[
            SizedBox(height: context.r(AppSizes.lg)),
            _uploadProof(context),
          ],
        ],
      );
    });
  }

  // ── Cash ──────────────────────────────────────────────────────────────
  Widget _cashInfo(BuildContext context) {
    return _infoBox(
      context,
      child: Row(
        children: [
          Icon(Icons.store_outlined,
              color: AppColors.primary, size: context.r(22)),
          SizedBox(width: context.r(AppSizes.md)),
          Expanded(
            child: Text(
              'Tunjukkan pesanan ini ke kasir untuk membayar tunai.',
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontMd),
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Transfer ──────────────────────────────────────────────────────────
  Widget _transferInfo(BuildContext context) {
    return _infoBox(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelValue(context, 'Bank', controller.bankName),
          SizedBox(height: context.r(AppSizes.sm)),
          Text(
            'Nomor Rekening',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontSm),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: context.r(AppSizes.xs)),
          Row(
            children: [
              Expanded(
                child: Text(
                  controller.accountNumber,
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontXl),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: 1,
                  ),
                ),
              ),
              _ghostButton(
                context,
                icon: Icons.copy_rounded,
                label: 'Salin',
                onTap: controller.copyAccountNumber,
              ),
            ],
          ),
          SizedBox(height: context.r(AppSizes.sm)),
          _labelValue(context, 'Atas Nama', controller.accountHolder),
        ],
      ),
    );
  }

  // ── QRIS ──────────────────────────────────────────────────────────────
  Widget _qrisInfo(BuildContext context) {
    final qrisSize = context.rv<double>(mobile: 220, tablet: 260, desktop: 280);
    return _infoBox(
      context,
      child: Column(
        children: [
          Text(
            'Scan QRIS dengan e-wallet / m-banking apa saja',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontSm),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: context.r(AppSizes.md)),
          Container(
            padding: EdgeInsets.all(context.r(AppSizes.md)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(context.r(AppSizes.md)),
              border: Border.all(color: AppColors.border),
            ),
            child: AppMenuImage(
              path: controller.qrisPath,
              width: qrisSize,
              height: qrisSize,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.circular(context.r(AppSizes.sm)),
            ),
          ),
          SizedBox(height: context.r(AppSizes.md)),
          SizedBox(
            width: double.infinity,
            child: _ghostButton(
              context,
              icon: Icons.download_rounded,
              label: 'Unduh QRIS',
              onTap: controller.downloadQris,
              expanded: true,
            ),
          ),
        ],
      ),
    );
  }

  // ── Upload bukti ────────────────────────────────────────────────────────
  Widget _uploadProof(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bukti Pembayaran',
          style: TextStyle(
            fontSize: context.rf(AppSizes.fontMd),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: context.r(AppSizes.xs)),
        Text(
          'Diteruskan ke kasir untuk diverifikasi.',
          style: TextStyle(
            fontSize: context.rf(AppSizes.fontSm),
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: context.r(AppSizes.md)),
        Obx(() {
          final path = controller.proofPath.value;
          if (path == null || path.isEmpty) {
            return InkWell(
              onTap: controller.pickProof,
              borderRadius: BorderRadius.circular(context.r(AppSizes.md)),
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(vertical: context.r(AppSizes.xl)),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(context.r(AppSizes.md)),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined,
                        color: AppColors.primary, size: context.r(32)),
                    SizedBox(height: context.r(AppSizes.xs)),
                    Text(
                      'Unggah bukti pembayaran',
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontMd),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          // Preview bukti terunggah
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(context.r(AppSizes.md)),
                child: AppMenuImage(
                  path: path,
                  width: double.infinity,
                  height: context.r(180),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: context.r(AppSizes.sm),
                right: context.r(AppSizes.sm),
                child: Material(
                  color: AppColors.danger,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: controller.removeProof,
                    child: Padding(
                      padding: EdgeInsets.all(context.r(6)),
                      child: Icon(Icons.close,
                          color: Colors.white, size: context.r(18)),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────
  Widget _infoBox(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.r(AppSizes.lg)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(context.r(AppSizes.md)),
      ),
      child: child,
    );
  }

  Widget _labelValue(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.rf(AppSizes.fontSm),
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: context.r(AppSizes.xs)),
        Text(
          value,
          style: TextStyle(
            fontSize: context.rf(AppSizes.fontMd),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _ghostButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool expanded = false,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: context.r(18)),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: EdgeInsets.symmetric(
          horizontal: context.r(AppSizes.lg),
          vertical: context.r(expanded ? AppSizes.md : AppSizes.sm),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.r(AppSizes.radiusFull)),
        ),
      ),
    );
  }
}
