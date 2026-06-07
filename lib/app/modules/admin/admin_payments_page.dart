import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/format.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'admin_controller.dart';

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
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final list = controller.pendingOrders;

                // Jika data kosong, bungkus dengan SingleChildScrollView agar tetap bisa ditarik/refresh
                if (list.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => controller.loadAllData(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        alignment: Alignment.center,
                        child: Text(
                          'Tidak ada pembayaran menunggu',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  );
                }

                // Jika ada data, pasang RefreshIndicator di ListView
                return RefreshIndicator(
                  onRefresh: () => controller.loadAllData(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(context.r(AppSizes.lg)),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final order = list[i];
                      return _PaymentCardAPI(
                        orderData: order,
                        onConfirm: () =>
                            controller.confirm(order['id'].toString()),
                        onReject: () =>
                            controller.cancel(order['id'].toString()),
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

// 1. Tambahkan parameter onReject
class _PaymentCardAPI extends StatelessWidget {
  final dynamic orderData;
  final VoidCallback onConfirm;
  final VoidCallback onReject; // <--- Tambahkan ini

  const _PaymentCardAPI({
    required this.orderData,
    required this.onConfirm,
    required this.onReject, // <--- Tambahkan ini
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meja ${orderData['table_name']} - ${orderData['customer_name']}',
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontLg),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                orderData['payment_method'].toString().toUpperCase(),
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: context.r(AppSizes.sm)),
          Text(
            'Total: Rp ${orderData['total_price']}',
            style: TextStyle(fontSize: context.rf(AppSizes.fontMd)),
          ),
          SizedBox(height: context.r(AppSizes.lg)),

          // 2. Ubah bagian tombol menjadi Row berisi 2 tombol (Tolak & Konfirmasi)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
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
                    padding:
                        EdgeInsets.symmetric(vertical: context.r(AppSizes.md)),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(context.r(AppSizes.radiusFull)),
                    ),
                  ),
                  child: const Text('Konfirmasi Pembayaran',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
