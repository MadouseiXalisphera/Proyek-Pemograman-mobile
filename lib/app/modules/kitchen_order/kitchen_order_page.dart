import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'kitchen_order_controller.dart';
import 'widgets/kitchen_order_card.dart';

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
              child: Text(
                'Orders Kitchen',
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontDisplay),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.kitchenOrders.isEmpty) {
                  return _empty(context);
                }

                return RefreshIndicator(
                  onRefresh: () => controller.loadOrders(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(context.r(AppSizes.lg)),
                    itemCount: controller.kitchenOrders.length,
                    itemBuilder: (_, i) {
                      final item = controller.kitchenOrders[i];

                      // Memanggil kartu buatan rekanmu dengan data JSON dari MySQL
                      return KitchenOrderCard(
                        item: item,
                        onAdvance: () => controller.advanceStatus(item),
                      );
                    },
                  ),
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
