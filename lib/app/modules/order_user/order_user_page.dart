import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'user_order_controller.dart';

class OrderUserPage extends StatelessWidget {
  const OrderUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserOrderController());

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
                final list = controller.orders;
                if (list.isEmpty) return _empty(context);

                return RefreshIndicator(
                  onRefresh: () => controller.loadOrders(),
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      context.r(AppSizes.lg),
                      0,
                      context.r(AppSizes.lg),
                      context.r(AppSizes.lg),
                    ),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final item = list[i];

                      Color statusColor = Colors.black;
                      if (item['cancelled'].toString() == '1') {
                        statusColor = Colors.red;
                      } else if (item['payment_confirmed'].toString() == '1') {
                        statusColor = Colors.green;
                      }

                      final isCancelled = item['cancelled'].toString() == '1';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(item['menu_name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Qty : ${item['quantity']}'),
                                  Text('Harga : Rp ${item['price']}'),
                                  Text(
                                    'Status : ${statusLabel(item)}',
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text('Waktu : ${item['created_at']}'),
                                ],
                              ),
                            ),
                            if (isCancelled)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: ElevatedButton(
                                  onPressed: () =>
                                      controller.hideCancelledOrder(
                                          item['order_id'].toString()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                      'Konfirmasi & Hapus dari Daftar'),
                                ),
                              ),
                          ],
                        ),
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

String statusLabel(Map<String, dynamic> item) {
  if (item['cancelled'].toString() == '1') {
    return 'Pesanan Dibatalkan';
  }
  if (item['payment_confirmed'].toString() == '0') {
    return 'Menunggu Pembayaran';
  }
  switch (item['status']) {
    case 'confirm':
      return 'Menunggu Diproses Dapur';
    case 'ready':
      return 'Sedang Diproses';
    case 'done':
      return 'Pesanan Selesai';
    default:
      return item['status'].toString();
  }
}
