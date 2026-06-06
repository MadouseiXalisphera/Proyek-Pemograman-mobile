import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/format.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_menu_image.dart';
import '../../core/widgets/quantity_big.dart';
import '../../core/widgets/responsive_wrapper.dart';
import '../../data/models/menu_item_model.dart';
import 'detail_controller.dart';

class DetailSheet extends StatelessWidget {
  final MenuItem item;
  const DetailSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      DetailController(item: item),
      tag: 'detail_${item.id}',
    );

    return FractionallySizedBox(
      heightFactor: 0.92,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ResponsiveWrapper(
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.r(AppSizes.md)),
                child: Container(
                  width: context.r(40),
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Konten scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Foto
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.r(AppSizes.lg),
                        ),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: AppMenuImage(
                            path: item.fotoPath,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(
                                context.r(AppSizes.radiusXl)),
                          ),
                        ),
                      ),
                      SizedBox(height: context.r(AppSizes.xl)),
                      // Detail teks
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.r(AppSizes.xl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nama,
                              style: TextStyle(
                                fontSize: context.rf(28),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: context.r(AppSizes.xs)),
                            Row(
                              children: [
                                // Kategori chip
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.r(AppSizes.sm),
                                    vertical: context.r(AppSizes.xs),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(
                                        context.r(AppSizes.md)),
                                  ),
                                  child: Text(
                                    item.kategori == 'food'
                                        ? 'Makanan'
                                        : 'Minuman',
                                    style: TextStyle(
                                      fontSize: context.rf(11),
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: context.r(AppSizes.sm)),
                                Text(
                                  formatRupiah(item.harga),
                                  style: TextStyle(
                                    fontSize: context.rf(AppSizes.fontXxl),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: context.r(AppSizes.xl)),
                            Text(
                              'Deskripsi',
                              style: TextStyle(
                                fontSize: context.rf(AppSizes.fontLg),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: context.r(6)),
                            Text(
                              item.deskripsi,
                              style: TextStyle(
                                fontSize: context.rf(AppSizes.fontMd),
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: context.r(AppSizes.xl)),
                            Text(
                              'Jumlah',
                              style: TextStyle(
                                fontSize: context.rf(AppSizes.fontLg),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: context.r(AppSizes.sm)),
                            Obx(
                              () => QuantityBig(
                                quantity: controller.quantity.value,
                                onIncrement: controller.increment,
                                onDecrement: controller.decrement,
                              ),
                            ),
                            SizedBox(height: context.r(AppSizes.xl)),
                            Text(
                              'Catatan (opsional)',
                              style: TextStyle(
                                fontSize: context.rf(AppSizes.fontLg),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: context.r(AppSizes.sm)),
                            TextField(
                              controller: controller.catatanC,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Contoh: tidak pedas, tanpa es...',
                                filled: true,
                                fillColor: AppColors.surface,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(context.r(14)),
                                  borderSide:
                                      const BorderSide(color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(context.r(14)),
                                  borderSide:
                                      const BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(context.r(14)),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: context.r(AppSizes.xl)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Sticky bottom — total + tombol tambah
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.r(AppSizes.xl),
                    context.r(AppSizes.md),
                    context.r(AppSizes.xl),
                    context.r(AppSizes.lg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          Obx(
                            () => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (c, a) =>
                                  FadeTransition(opacity: a, child: c),
                              child: Text(
                                controller.totalHargaFormatted,
                                key: ValueKey(controller.quantity.value),
                                style: TextStyle(
                                  fontSize: context.rf(AppSizes.fontXl),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.r(10)),
                      SizedBox(
                        width: double.infinity,
                        height: context.r(AppSizes.tapTargetLg),
                        child: ElevatedButton(
                          onPressed: controller.tambahKeKeranjang,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  context.r(AppSizes.radiusLg)),
                            ),
                          ),
                          child: Text(
                            'Tambah ke Keranjang',
                            style: TextStyle(
                              fontSize: context.rf(AppSizes.fontLg),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// LAUNCHER
// Selalu buka DetailSheet lewat fungsi ini, JANGAN panggil Get.bottomSheet
// langsung. Karena bottom sheet bukan route GetX, controller yang dibuat
// via Get.put(tag:) tidak auto-dispose. Fungsi ini menunggu sheet ditutup
// lalu membuang controller (memicu onClose → catatanC.dispose()).
// ════════════════════════════════════════════════════════════════════════
Future<void> openDetailSheet(MenuItem item) async {
  final String tag = 'detail_${item.id}';
  await Get.bottomSheet(
    DetailSheet(item: item),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
  );
  if (Get.isRegistered<DetailController>(tag: tag)) {
    Get.delete<DetailController>(tag: tag);
  }
}
