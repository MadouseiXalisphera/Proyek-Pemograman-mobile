import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/menu_item_model.dart';
import '../../modules/cart/cart_controller.dart';
import '../../modules/detail/detail_sheet.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/format.dart';
import '../utils/responsive.dart';
import 'quantity_pill.dart';

/// Card menu untuk layout grid (tablet & desktop).
///
/// Berbeda dengan [MenuListCard] yang horizontal (foto kiri, konten kanan),
/// card ini vertikal (foto atas, konten bawah) — cocok untuk GridView
/// dengan beberapa kolom.
///
/// Width otomatis mengikuti slot grid. Height adaptive berdasarkan content.
class MenuGridCard extends StatelessWidget {
  final MenuItem item;

  const MenuGridCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final CartController cart = Get.find<CartController>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.r(AppSizes.radiusLg)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto — aspect ratio 4:3, full width slot grid
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.r(AppSizes.radiusLg)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.bottomSheet(
                  DetailSheet(item: item),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  enableDrag: true,
                ),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: item.fotoPath != null
                      ? Image.asset(
                          item.fotoPath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: AppColors.imagePlaceholder);
                          },
                        )
                      : Container(color: AppColors.imagePlaceholder),
                ),
              ),
            ),
          ),
          // Konten bawah
          Padding(
            padding: EdgeInsets.all(context.r(AppSizes.md)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontLg),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.r(AppSizes.xs)),
                Text(
                  item.deskripsi,
                  style: TextStyle(
                    fontSize: context.rf(AppSizes.fontSm),
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.r(AppSizes.md)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        formatRupiah(item.harga),
                        style: TextStyle(
                          fontSize: context.rf(AppSizes.fontLg),
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Obx(() {
                      final qty = cart.getQuantity(item.id);
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (c, a) =>
                            FadeTransition(opacity: a, child: c),
                        child: qty == 0
                            ? GestureDetector(
                                key: const ValueKey('add'),
                                onTap: () => cart.increment(item.id, item),
                                child: Icon(
                                  Icons.add_circle_outline,
                                  size: context.r(30),
                                  color: AppColors.primary,
                                ),
                              )
                            : QuantityPill(
                                key: const ValueKey('pill'),
                                quantity: qty,
                                onIncrement: () =>
                                    cart.increment(item.id, item),
                                onDecrement: () => cart.decrement(item.id),
                              ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
