import 'package:flutter/material.dart';

import '../../core/widgets/app_bottom_nav.dart';

// ════════════════════════════════════════════════════════════════════════
// Indeks tab tiap role + daftar NavItem-nya.
// Dipisah dari view supaya view tetap ramping dan urutan tab terdokumentasi
// di satu tempat. Index controller mengacu ke konstanta di sini.
// ════════════════════════════════════════════════════════════════════════

/// Tab shell PELANGGAN (role `user`). Urutan sama dengan IndexedStack.
class UserTab {
  UserTab._();
  static const int home = 0;
  static const int cart = 1;
  static const int order = 2;
  static const int howToUse = 3;
  static const int settings = 4;

  static const List<NavItem> items = [
    NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    NavItem(
      icon: Icons.shopping_basket_outlined,
      activeIcon: Icons.shopping_basket,
      label: 'Cart',
    ),
    NavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      label: 'Order',
    ),
    NavItem(
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book,
      label: 'How to Use',
    ),
    NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];
}

/// Tab shell KITCHEN (role `kitchen`).
class KitchenTab {
  KitchenTab._();
  static const int order = 0;
  static const int menuStock = 1;
  static const int settings = 2;

  static const List<NavItem> items = [
    NavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      label: 'Order',
    ),
    NavItem(
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
      label: 'Menu Stock',
    ),
    NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];
}

/// Tab shell ADMIN/KASIR (role `admin`).
/// Struktur disiapkan untuk pengembangan 5–10 halaman lanjutan; sekarang
/// sebagian besar masih placeholder.
class AdminTab {
  AdminTab._();
  static const int dashboard = 0;
  static const int orders = 1;
  static const int payments = 2;
  static const int settings = 3;

  static const List<NavItem> items = [
    NavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    NavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      label: 'Orders',
    ),
    NavItem(
      icon: Icons.payments_outlined,
      activeIcon: Icons.payments,
      label: 'Payments',
    ),
    NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];
}
