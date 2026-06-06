import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/format.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/order_status_badge.dart';
import '../../core/widgets/responsive_wrapper.dart';
import '../../data/models/order_model.dart';
import 'admin_controller.dart';

/// Tab Orders ADMIN: rekap seluruh pesanan (read-only) dengan status terkini.
class AdminOrdersPage extends GetView<AdminController> {
  const AdminOrdersPage({super.key});

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
                final _ = controller.reactiveSource.length;
                final list = controller.all;
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada pesanan',
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontMd),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(context.r(AppSizes.lg), 0,
                      context.r(AppSizes.lg), context.r(AppSizes.lg)),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _Row(order: list[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final OrderModel order;
  const _Row({required this.order});

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
              Expanded(
                child: Text(
                  '${order.namaMeja} · ${paymentMethodLabel(order.paymentMethod)}',
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontMd),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              StatusBadge(statusKey: order.statusKey),
            ],
          ),
          SizedBox(height: context.r(AppSizes.xs)),
          Text(
            '${order.items.length} item · ${formatRupiah(order.totalHarga)}',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontSm),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
