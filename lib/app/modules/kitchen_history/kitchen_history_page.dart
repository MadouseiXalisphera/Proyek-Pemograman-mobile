import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'kitchen_history_controller.dart';

class KitchenHistoryPage extends GetView<KitchenHistoryController> {
  const KitchenHistoryPage({super.key});

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
                'Riwayat Dapur',
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
                  return const Center(child: CircularProgressIndicator());
                }

                // Memanggil data API dari controller (historyOrders)
                final data = controller.historyOrders;
                if (data.isEmpty) return _empty(context);

                return RefreshIndicator(
                  onRefresh: () => controller.loadHistory(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      context.r(AppSizes.lg),
                      0,
                      context.r(AppSizes.lg),
                      context.r(AppSizes.lg),
                    ),
                    itemCount: data.length,
                    itemBuilder: (_, i) => _HistoryCard(item: data[i]),
                    separatorBuilder: (_, __) =>
                        SizedBox(height: context.r(AppSizes.md)),
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
          Icon(Icons.history,
              size: context.r(72), color: AppColors.primaryLight),
          SizedBox(height: context.r(AppSizes.md)),
          Text(
            'Belum ada riwayat pesanan',
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

class _HistoryCard extends StatelessWidget {
  final dynamic item; // Menggunakan dynamic/Map dari JSON

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.r(AppSizes.radiusLg)),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      padding: EdgeInsets.all(context.r(AppSizes.lg)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meja ${item['table_name']}',
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontLg),
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.r(AppSizes.sm), vertical: context.r(4)),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(context.r(AppSizes.radiusFull)),
                ),
                child: Text(
                  'Selesai',
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontSm),
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.r(AppSizes.sm)),
          Text(
            '${item['menu_name']}  x${item['quantity']}',
            style: TextStyle(
              fontSize: context.rf(AppSizes.fontMd),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.r(4)),
          Text(
            'Pemesan: ${item['customer_name']} | Order #${item['order_id']}',
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
