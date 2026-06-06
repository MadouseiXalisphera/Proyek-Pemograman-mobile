import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/settings_card.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

/// Tab Settings PELANGGAN (Image 7): nama meja, username, tombol Logout.
/// Logout membuka konfirmasi password dulu (tidak langsung keluar).
class SettingsUserPage extends StatelessWidget {
  const SettingsUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthService>().currentUser;
    final namaMeja = user?.namaMeja ?? '-';
    final username = user?.username ?? '-';

    return SettingsCard(
      cardTitle: namaMeja,
      fields: [
        ReadOnlyField(value: username, icon: Icons.person_outline),
        ReadOnlyField(value: namaMeja, icon: Icons.contact_page_outlined),
      ],
      onLogout: () => Get.toNamed(AppRoutes.logoutConfirm),
    );
  }
}
