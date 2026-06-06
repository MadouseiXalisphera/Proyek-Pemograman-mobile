import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../kitchen_order/kitchen_order_page.dart';
import '../menu_stock/menu_stock_page.dart';
import '../settings/settings_kitchen_page.dart';
import 'kitchen_shell_controller.dart';
import 'shell_tabs.dart';

/// Shell utama KITCHEN: Order · Menu Stock · Settings.
/// Isi tab dibangun di Fase E (Order), Fase F (Menu Stock), Fase G (Settings).
class KitchenShell extends StatelessWidget {
  const KitchenShell({super.key});

  @override
  Widget build(BuildContext context) {
    final KitchenShellController controller = Get.find<KitchenShellController>();

    final pages = <Widget>[
      const KitchenOrderPage(),
      const MenuStockPage(),
      const SettingsKitchenPage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(
        () => IndexedStack(index: controller.index.value, children: pages),
      ),
      bottomNavigationBar: Obx(
        () => AppBottomNav(
          items: KitchenTab.items,
          currentIndex: controller.index.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
