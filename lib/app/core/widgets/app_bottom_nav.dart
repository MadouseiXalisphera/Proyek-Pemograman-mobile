import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive.dart';

/// Satu item pada [AppBottomNav].
class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItem({
    required this.icon,
    required this.label,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}

/// Bottom navigation bar reusable untuk semua shell (user/kitchen/admin).
///
/// Dipasang sebagai `Scaffold.bottomNavigationBar` supaya otomatis full-width
/// (tidak terpotong max-width content). Gaya mengikuti desain: surface putih,
/// border atas tipis, tab aktif memakai warna primary + garis indikator.
class AppBottomNav extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: context.r(72),
          child: Row(
            children: [
              for (int i = 0; i < items.length; i++)
                _Tab(
                  item: items[i],
                  isActive: i == currentIndex,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _Tab({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.primaryLight;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              color: color,
              size: context.r(AppSizes.iconLg),
            ),
            SizedBox(height: context.r(2)),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: context.rf(11), color: color),
            ),
            SizedBox(height: context.r(4)),
            // Indikator garis bawah — tetap render (transparan saat tidak aktif)
            // supaya tinggi semua tab konsisten dan teks tidak bergeser.
            Container(
              height: 2,
              width: context.r(AppSizes.iconLg),
              color: isActive ? AppColors.primary : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
