import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'admin_controller.dart';

/// Tab Orders ADMIN: rekap seluruh pesanan (read-only) dengan status terkini.
/// Tiap baris menampilkan NOMOR PESANAN agar mudah dicocokkan lintas peran.
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
                'History Orders',
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

                final list = controller.historyOrders;
                if (list.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => controller.loadAllData(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        alignment: Alignment.center,
                        child: const Text('Belum ada pesanan'),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.loadAllData(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(context.r(AppSizes.lg)),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final order = list[i];
                      final isPaid =
                          order['payment_confirmed'].toString() == '1';

                      return Card(
                        margin: EdgeInsets.only(bottom: context.r(AppSizes.md)),
                        child: ListTile(
                          title: Text(
                              'Meja ${order['table_name']} - ${order['customer_name']}'),
                          subtitle: Text('Tgl: ${order['created_at']}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp ${order['total_price']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                isPaid ? 'LUNAS' : 'BELUM BAYAR',
                                style: TextStyle(
                                  color: isPaid ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
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
                  'Pesanan ${order.displayNo} · ${order.namaMeja}',
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
            '${paymentMethodLabel(order.paymentMethod)} · ${order.items.length} item · ${formatRupiah(order.totalHarga)}',
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
