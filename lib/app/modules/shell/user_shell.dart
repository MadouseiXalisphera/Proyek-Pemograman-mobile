import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/fade_indexed_stack.dart';
import '../cart/cart_view.dart';
import '../home/home_view.dart';
import '../how_to_use/how_to_use_page.dart';
import '../order_user/order_user_page.dart';
import '../settings/settings_user_page.dart';
import 'shell_tabs.dart';
import 'user_shell_controller.dart';

/// Shell utama PELANGGAN: 5 tab + bottom nav, dgn fade halus antar-tab
/// (state tiap tab tetap dipertahankan oleh IndexedStack di dalam FadeIndexedStack).
class UserShell extends StatelessWidget {
  const UserShell({super.key});

  @override
  Widget build(BuildContext context) {
    final UserShellController controller = Get.find<UserShellController>();

    final pages = <Widget>[
      const HomeView(),
      const CartView(),
      const OrderUserPage(),
      const HowToUsePage(),
      const SettingsUserPage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(
        () => FadeIndexedStack(
          index: controller.index.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => AppBottomNav(
          items: UserTab.items,
          currentIndex: controller.index.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
