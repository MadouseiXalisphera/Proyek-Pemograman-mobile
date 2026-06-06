import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../admin/admin_orders_page.dart';
import '../admin/admin_payments_page.dart';
import '../settings/settings_admin_page.dart';
import 'admin_shell_controller.dart';
import 'shell_tabs.dart';
import '../admin/views/admin_dashboard_view.dart';

/// Shell utama ADMIN/KASIR.
///
/// Saat ini semua tab placeholder. Struktur sengaja dibuat lapang untuk
/// pengembangan lanjutan (5–10 halaman: kelola pesanan, konfirmasi
/// pembayaran, kelola menu, laporan, sesi meja, dll). Tinggal menambah
/// NavItem di [AdminTab] dan child IndexedStack — shell tidak berubah.
class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminShellController controller = Get.find<AdminShellController>();

    final pages = <Widget>[
      AdminDashboardView(),
      const AdminOrdersPage(),
      const AdminPaymentsPage(),
      const SettingsAdminPage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(
        () => IndexedStack(index: controller.index.value, children: pages),
      ),
      bottomNavigationBar: Obx(
        () => AppBottomNav(
          items: AdminTab.items,
          currentIndex: controller.index.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
