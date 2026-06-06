import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/settings_card.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

/// Tab Settings KITCHEN (Image 1): username + role, tombol Logout (konfirmasi
/// password). Memakai kartu & flow yang sama dengan settings pelanggan.
class SettingsKitchenPage extends StatelessWidget {
  const SettingsKitchenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthService>().currentUser;
    return SettingsCard(
      cardTitle: 'Kitchen',
      fields: [
        ReadOnlyField(
            value: user?.username ?? '-', icon: Icons.person_outline),
        const ReadOnlyField(value: 'Kitchen', icon: Icons.contact_page_outlined),
      ],
      onLogout: () => Get.toNamed(AppRoutes.logoutConfirm),
    );
  }
}
