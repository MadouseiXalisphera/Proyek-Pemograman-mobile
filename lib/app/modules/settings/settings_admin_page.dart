import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/settings_card.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

/// Tab Settings ADMIN/KASIR: username + role, Logout (konfirmasi password).
class SettingsAdminPage extends StatelessWidget {
  const SettingsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthService>().currentUser;
    return SettingsCard(
      cardTitle: 'Kasir',
      fields: [
        ReadOnlyField(
            value: user?.username ?? '-', icon: Icons.person_outline),
        const ReadOnlyField(value: 'Kasir', icon: Icons.contact_page_outlined),
      ],
      onLogout: () => Get.toNamed(AppRoutes.logoutConfirm),
    );
  }
}
