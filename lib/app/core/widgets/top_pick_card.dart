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

class TopPickCard extends StatelessWidget {
  final MenuItem item;

  const TopPickCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final CartController cart = Get.find<CartController>();

    // Fix Issue 4: tinggi card dinaikkan 320/400/450 (sebelumnya 300/360/400)
    // supaya QuantityPill yang membesar di tablet/desktop tidak overflow.
    final cardWidth = context.responsiveValue<double>(
      mobile: 170,
      tablet: 220,
      desktop: 260,
    );
    final cardHeight = context.responsiveValue<double>(
      mobile: 320,
      tablet: 400,
      desktop: 450,
    );
    final imageHeight = context.responsiveValue<double>(
      mobile: 200,
      tablet: 240,
      desktop: 280,
    );

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.circular(context.r(AppSizes.radiusXl)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto — InkWell hanya di area gambar
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.r(AppSizes.radiusXl)),
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
                child: item.fotoPath != null
                    ? Image.asset(
                        item.fotoPath!,
                        width: cardWidth,
                        height: imageHeight,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: cardWidth,
                            height: imageHeight,
                            color: AppColors.imagePlaceholder,
                          );
                        },
                      )
                    : Container(
                        width: cardWidth,
                        height: imageHeight,
                        color: AppColors.imagePlaceholder,
                      ),
              ),
            ),
          ),
          // Konten bawah
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.r(10),
                context.r(AppSizes.sm),
                context.r(10),
                context.r(AppSizes.sm),
              ),
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
                  SizedBox(height: context.r(2)),
                  Text(
                    item.deskripsi,
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontXs),
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Fix Issue 3: harga rata kiri, tombol rata kanan
                  // (sama seperti pattern di MenuListCard).
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
                                  onTap: () =>
                                      cart.increment(item.id, item),
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
                                  onDecrement: () =>
                                      cart.decrement(item.id),
                                ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
