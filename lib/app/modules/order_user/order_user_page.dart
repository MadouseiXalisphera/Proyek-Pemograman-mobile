import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'user_order_controller.dart';

/// Tab Order PELANGGAN: riwayat pesanan meja yang login + status terkini
/// (read-only — status diubah oleh kitchen). Tiap kartu menampilkan NOMOR
/// PESANAN agar mudah dilacak.
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
                final list = orderService.ordersForMeja(namaMeja);
                if (list.isEmpty) return _empty(context);

                // Tambahkan RefreshIndicator agar user bisa tarik-refresh pesanan
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

                      // Cek warna berdasarkan status
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

                            // TAMPILKAN TOMBOL KONFIRMASI HANYA JIKA DIBATALKAN
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

// Fungsi statusLabel diubah untuk menerima Map data dan mengecek kondisi secara berurutan
String statusLabel(Map<String, dynamic> item) {
  // 1. Cek apakah dibatalkan
  if (item['cancelled'].toString() == '1') {
    return 'Pesanan Dibatalkan';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pesanan ${order.displayNo}',
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontMd),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: context.r(2)),
                  Text(
                    _formatTime(order.createdAt),
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontSm),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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

  // 2. Cek apakah belum dibayar
  if (item['payment_confirmed'].toString() == '0') {
    return 'Menunggu Pembayaran';
  }

  // 3. Jika sudah dibayar, cek status dari dapur
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
