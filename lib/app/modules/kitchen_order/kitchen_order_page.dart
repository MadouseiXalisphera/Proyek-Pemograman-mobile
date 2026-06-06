import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/confirm_clear_dialog.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'kitchen_order_controller.dart';
import 'widgets/kitchen_order_card.dart';

/// Tab Order KITCHEN (Image 3 & 4): pesanan dikelompokkan per meja, tiap item
/// punya tombol 3-kondisi (Confirm Order → ✓ → Selesai).
class KitchenOrderPage extends GetView<KitchenOrderController> {
  const KitchenOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontDisplay),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Obx(() {
                    if (!controller.hasDoneOrders) {
                      return const SizedBox.shrink();
                    }
                    return TextButton.icon(
                      onPressed: () => showClearAllDialog(
                        confirmLabel: 'Clear all',
                        onConfirm: controller.clearDone,
                      ),
                      icon: Icon(Icons.delete_sweep_outlined,
                          size: context.r(20), color: AppColors.danger),
                      label: Text(
                        'Hapus semua',
                        style: TextStyle(
                          fontSize: context.rf(AppSizes.fontSm),
                          color: AppColors.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final grouped = controller.grouped;
                if (grouped.isEmpty) return _empty(context);

                final tables = grouped.keys.toList()..sort();
                return ListView(
                  padding: EdgeInsets.fromLTRB(
                    context.r(AppSizes.lg),
                    0,
                    context.r(AppSizes.lg),
                    context.r(AppSizes.lg),
                  ),
                  children: [
                    for (final table in tables) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: context.r(AppSizes.md)),
                        child: Text(
                          table,
                          style: TextStyle(
                            fontSize: context.rf(AppSizes.fontXl),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      for (final order in grouped[table]!)
                        for (final item in order.items)
                          KitchenOrderCard(
                            item: item,
                            onAdvance: () => controller.advance(order, item),
                          ),
                    ],
                  ],
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
          Icon(Icons.receipt_long_outlined,
              size: context.r(72), color: AppColors.primaryLight),
          SizedBox(height: context.r(AppSizes.md)),
          Text(
            'Belum ada pesanan masuk',
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
