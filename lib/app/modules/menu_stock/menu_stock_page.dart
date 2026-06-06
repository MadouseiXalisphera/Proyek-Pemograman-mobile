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
                final stockMap = controller.stockMap; // dependency reaktif
                final menu = controller.menu;
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(context.r(AppSizes.lg), 0,
                      context.r(AppSizes.lg), context.r(AppSizes.lg)),
                  itemCount: menu.length,
                  itemBuilder: (_, i) {
                    final item = menu[i];
                    return MenuStockCard(
                      item: item,
                      stock: stockMap[item.id] ?? 0,
                      onAdd: () => controller.add(item.id),
                      onEmpty: () => controller.empty(item.id),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
