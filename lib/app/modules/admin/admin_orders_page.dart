import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'admin_controller.dart';

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
