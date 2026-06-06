import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../cart/cart_view.dart';
import '../home/home_view.dart';
import '../how_to_use/how_to_use_page.dart';
import '../order_user/order_user_page.dart';
import '../settings/settings_user_page.dart';
import 'shell_tabs.dart';
import 'user_shell_controller.dart';

/// Shell utama PELANGGAN: Scaffold + IndexedStack 5 tab + bottom nav.
///
/// IndexedStack menjaga state tiap tab tetap hidup saat berpindah (scroll
/// position Home, isi pencarian, dll. tidak ter-reset).
class UserShell extends StatelessWidget {
  const UserShell({super.key});

  @override
  Widget build(BuildContext context) {
    final UserShellController controller = Get.find<UserShellController>();

    // Dibuat sekali, dipertahankan oleh IndexedStack.
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
        () => IndexedStack(index: controller.index.value, children: pages),
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
