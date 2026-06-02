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

class MenuListCard extends StatelessWidget {
  final MenuItem item;

  const MenuListCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final CartController cart = Get.find<CartController>();

    return Container(
      height: context.r(127),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.r(10)),
      ),
      child: Row(
        children: [
          // Foto kiri — InkWell hanya di area gambar
          ClipRRect(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(context.r(10)),
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
                        width: context.r(127),
                        height: context.r(127),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: context.r(127),
                        height: context.r(127),
                        color: AppColors.imagePlaceholder,
                      ),
              ),
            ),
          ),
          // Konten kanan
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(context.r(AppSizes.md)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nama,
                    style: TextStyle(
                      fontSize: context.rf(AppSizes.fontLg),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.r(AppSizes.xs)),
                  Expanded(
                    child: Text(
                      item.deskripsi,
                      style: TextStyle(
                        fontSize: context.rf(AppSizes.fontXs),
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          formatRupiah(item.harga),
                          style: TextStyle(
                            fontSize: context.rf(AppSizes.fontLg),
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
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
          ),
        ],
      ),
    );
  }
}
