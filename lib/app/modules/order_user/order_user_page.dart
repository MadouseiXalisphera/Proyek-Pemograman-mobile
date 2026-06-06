import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/format.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/order_status_badge.dart';
import '../../core/widgets/responsive_wrapper.dart';
import '../../data/models/order_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/order_service.dart';

/// Tab Order PELANGGAN: riwayat pesanan untuk meja yang sedang login,
/// beserta status terkini (read-only — status diubah oleh kitchen).
class OrderUserPage extends StatelessWidget {
  const OrderUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderService = Get.find<OrderService>();
    final namaMeja = Get.find<AuthService>().currentUser?.namaMeja ?? '-';

    return SafeArea(
      child: ResponsiveWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.r(AppSizes.lg),
                context.r(AppSizes.lg),
                context.r(AppSizes.lg),
                context.r(AppSizes.sm),
              ),
              child: Text(
                'Orders',
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontDisplay),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                // Membaca orderService.orders di dalam Obx agar reaktif.
                final list = orderService.ordersForMeja(namaMeja);
                if (list.isEmpty) return _empty(context);
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    context.r(AppSizes.lg),
                    0,
                    context.r(AppSizes.lg),
                    context.r(AppSizes.lg),
                  ),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _OrderCard(order: list[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: context.r(72),
            color: AppColors.primaryLight,
          ),
          SizedBox(height: context.r(AppSizes.md)),
          Text(
            'Belum ada pesanan',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontMd),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTime(order.createdAt),
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontSm),
                  color: AppColors.textSecondary,
                ),
              ),
              StatusBadge(statusKey: order.statusKey),
            ],
          ),
          SizedBox(height: context.r(AppSizes.md)),
          for (final item in order.items)
            Padding(
              padding: EdgeInsets.only(bottom: context.r(AppSizes.xs)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.menuItem.nama}  x${item.quantity}',
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontMd),
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    formatRupiah(item.subtotal),
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontMd),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          Divider(height: context.r(AppSizes.lg), color: AppColors.border),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontMd),
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                formatRupiah(order.totalHarga),
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontLg),
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    String two(int n) => n < 10 ? '0$n' : '$n';
    return '${two(t.hour)}:${two(t.minute)}';
  }
}
