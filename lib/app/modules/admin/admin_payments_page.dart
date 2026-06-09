import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/format.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_menu_image.dart';
import '../../core/widgets/responsive_wrapper.dart';
import '../../data/models/order_model.dart';
import 'admin_controller.dart';

/// Tab Payments ADMIN/KASIR: validasi pembayaran manual.
/// Konfirmasi → pesanan masuk antrian kitchen. Tolak → dibatalkan.
/// Tiap kartu menampilkan NOMOR PESANAN agar mudah dicocokkan dgn user/kitchen.
class AdminPaymentsPage extends GetView<AdminController> {
  const AdminPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(context.r(AppSizes.lg)),
              child: Text(
                'Payments',
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontDisplay),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final _ = controller.reactiveSource.length;
                final list = controller.awaiting;
                if (list.isEmpty) {
                  return _empty(context, 'Tidak ada pembayaran menunggu');
                }
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(context.r(AppSizes.lg), 0,
                      context.r(AppSizes.lg), context.r(AppSizes.lg)),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _PaymentCard(
                    order: list[i],
                    onConfirm: () => controller.confirm(list[i].id),
                    onReject: () => controller.cancel(list[i].id),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty(BuildContext context, String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined,
              size: context.r(72), color: AppColors.primaryLight),
          SizedBox(height: context.r(AppSizes.md)),
          Text(text,
              style: TextStyle(
                  fontSize: context.rf(AppSizes.fontMd),
                  color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  const _PaymentCard({
    required this.order,
    required this.onConfirm,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.r(AppSizes.md)),
      padding: EdgeInsets.all(context.r(AppSizes.lg)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.r(AppSizes.radiusLg)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nomor pesanan (pelacakan lintas peran)
          Text(
            'Pesanan ${order.displayNo}',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontMd),
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: context.r(AppSizes.xs)),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${order.namaMeja} · ${order.namaPemesan}',
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontLg),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                paymentMethodLabel(order.paymentMethod),
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontSm),
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: context.r(AppSizes.sm)),
          for (final it in order.items)
            Text(
              '${it.menuItem.nama} x${it.quantity}',
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontMd),
                color: AppColors.textSecondary,
              ),
            ),
          SizedBox(height: context.r(AppSizes.sm)),
          Text(
            'Total: ${formatRupiah(order.totalHarga)}',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontMd),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (order.paymentProofBytes != null) ...[
            SizedBox(height: context.r(AppSizes.md)),
            Text(
              'Bukti pembayaran:',
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontSm),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: context.r(AppSizes.xs)),
            GestureDetector(
              onTap: () => _viewProof(context, order.paymentProofBytes!),
              child: AppMenuImage(
                bytes: order.paymentProofBytes,
                width: double.infinity,
                height: context.r(160),
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(context.r(AppSizes.md)),
              ),
            ),
          ] else ...[
            SizedBox(height: context.r(AppSizes.sm)),
            Text(
              order.paymentMethod == PaymentMethod.cash
                  ? 'Bayar tunai di kasir.'
                  : 'Belum ada bukti.',
              style: TextStyle(
                fontSize: context.rf(AppSizes.fontSm),
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: context.r(AppSizes.lg)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                    padding:
                        EdgeInsets.symmetric(vertical: context.r(AppSizes.md)),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(context.r(AppSizes.radiusFull)),
                    ),
                  ),
                  child: const Text('Tolak'),
                ),
              ),
              SizedBox(width: context.r(AppSizes.md)),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                        EdgeInsets.symmetric(vertical: context.r(AppSizes.md)),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(context.r(AppSizes.radiusFull)),
                    ),
                  ),
                  child: const Text('Konfirmasi Pembayaran',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _viewProof(BuildContext context, Uint8List bytes) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(context.r(AppSizes.lg)),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.r(AppSizes.md)),
            child: AppMenuImage(bytes: bytes, fit: BoxFit.contain),
          ),
        ),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.8),
    );
  }
}
