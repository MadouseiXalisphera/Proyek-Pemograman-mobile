import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_wrapper.dart';
import 'menu_stock_controller.dart';
import 'widgets/menu_stock_card.dart';

/// Tab Menu Stock (kitchen): daftar menu + tombol Add (+100) / Empty (→0).
class MenuStockPage extends GetView<MenuStockController> {
  const MenuStockPage({super.key});

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
                'Menu Stock',
                style: TextStyle(
                  fontSize: context.rf(AppSizes.fontDisplay),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final stockMap = controller.stockMap;
                final menu = controller.menu;
                // Bangun children secara eager (bukan ListView.builder lazy)
                // supaya pembacaan stockMap[id] terjadi di dalam scope Obx →
                // dependency reaktif terdaftar (hindari error "improper GetX").
                return ListView(
                  padding: EdgeInsets.fromLTRB(context.r(AppSizes.lg), 0,
                      context.r(AppSizes.lg), context.r(AppSizes.lg)),
                  children: [
                    for (final item in menu)
                      MenuStockCard(
                        item: item,
                        stock: stockMap[item.id] ?? 0,
                        onAdd: () => controller.add(item.id),
                        onEmpty: () => controller.empty(item.id),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
