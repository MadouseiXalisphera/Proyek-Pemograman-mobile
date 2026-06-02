import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/utils/responsive.dart';
import '../../../routes/app_routes.dart';
import '../../cart/cart_controller.dart';

class CartFloatingBar extends StatelessWidget {
  const CartFloatingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.cart),
        borderRadius: BorderRadius.circular(context.r(AppSizes.radiusLg)),
        child: Obx(() {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.r(14),
              vertical: context.r(AppSizes.md),
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(context.r(AppSizes.radiusLg)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: context.r(28),
                  height: context.r(28),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${cart.totalItem}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: context.rf(AppSizes.fontMd),
                    ),
                  ),
                ),
                SizedBox(width: context.r(AppSizes.md)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lihat Keranjang',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: context.rf(AppSizes.fontMd),
                        ),
                      ),
                      Text(
                        cart.totalHargaFormatted,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: context.rf(AppSizes.fontSm),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: context.r(AppSizes.iconSm),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
