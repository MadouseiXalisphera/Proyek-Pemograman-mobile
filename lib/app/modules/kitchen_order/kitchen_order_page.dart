import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
// import '../../core/widgets/confirm_clear_dialog.dart';
import '../../core/widgets/order_status_badge.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'kitchen_order_controller.dart';
import 'widgets/kitchen_order_card.dart';

/// Tab Order KITCHEN: pesanan dikelompokkan per meja, lalu per nomor pesanan,
/// tiap item punya tombol 3-kondisi (Confirm Order → Done → Selesai).
///
/// Catatan: tombol "Hapus semua" DIHILANGKAN dari UI agar tidak salah tekan.
/// Pesanan yang seluruh itemnya selesai otomatis lenyap dari daftar aktif
/// (isVisibleToKitchen=false) tetapi tetap tersimpan untuk Riwayat & riwayat
/// user (tidak dihapus dari store bersama).
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
                  const SizedBox.shrink(),
                ],
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
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.kitchenOrders.isEmpty) {
                  return _empty(context);
                }

                return ListView.builder(
                  itemCount: controller.kitchenOrders.length,
                  itemBuilder: (_, i) {
                    final item = controller.kitchenOrders[i];

                    return ListTile(
                      title: Text(
                        item['menu_name'],
                      ),
                      subtitle: Text(
                        'Meja ${item['table_name']}'
                        '\nQty : ${item['quantity']}'
                        '\nStatus : ${item['status']}'
                        '\nCustomer : ${item['customer_name']}',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => controller.advanceStatus(item),
                        child: Text(
                          item['status'] == 'confirm'
                              ? 'Confirm'
                              : item['status'] == 'ready'
                                  ? 'Done'
                                  : 'Selesai',
                        ),
                      ),
                    );
                  },
                      for (final order in grouped[table]!) ...[
                        // Sub-judul: NOMOR PESANAN + status, agar tiap pesanan
                        // bisa dilacak & tidak tertukar dalam satu meja.
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: context.r(AppSizes.sm),
                            top: context.r(AppSizes.xs),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Pesanan ${order.displayNo}',
                                style: TextStyle(
                                  fontSize: context.rf(AppSizes.fontMd),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(width: context.r(AppSizes.sm)),
                              StatusBadge(statusKey: order.statusKey),
                            ],
                          ),
                        ),
                        for (final item in order.items)
                          KitchenOrderCard(
                            item: item,
                            onAdvance: () => controller.advance(order, item),
                          ),
                      ],
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
