import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/menu_item_model.dart';
import '../../data/services/menu_stock_service.dart';

/// Keranjang dengan model PER-BARIS.
///
/// Satu baris = (menu + catatan). Dua porsi menu sama dengan catatan berbeda =
/// dua baris terpisah, jadi catatan bisa beda untuk porsi item yang sama (#2).
/// Penambahan dari detail memakai [addItem] sekali jalan (tanpa loop, #3).
///
/// Quick add/kurang dari kartu Home (`increment`/`decrement`/`getQuantity`)
/// beroperasi pada baris TANPA catatan (catatan == '').
class CartController extends GetxController {
  final RxList<CartItem> items = <CartItem>[].obs;

  // ── Helper ──────────────────────────────────────────────────────────────
  int _indexOf(String menuId, String catatan) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].menuItem.id == menuId && items[i].catatan == catatan) {
        return i;
      }
    }
    return -1;
  }

  bool _available(String menuId, String nama) {
    if (Get.isRegistered<MenuStockService>() &&
        !Get.find<MenuStockService>().isAvailable(menuId)) {
      Get.snackbar(
        'Stok habis',
        '$nama sedang tidak tersedia',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger.withValues(alpha: 0.12),
        colorText: AppColors.danger,
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 1600),
      );
      return false;
    }
    return true;
  }

  // ── Quick add dari Home (baris tanpa catatan) ────────────────────────────
  int getQuantity(String menuId) {
    final idx = _indexOf(menuId, '');
    return idx == -1 ? 0 : items[idx].quantity;
  }

  void increment(String menuId, MenuItem item) {
    if (!_available(menuId, item.nama)) return;
    final idx = _indexOf(menuId, '');
    if (idx != -1) {
      items[idx].quantity++;
    } else {
      items.add(CartItem(menuItem: item, quantity: 1, catatan: ''));
    }
    items.refresh();
  }

  void decrement(String menuId) {
    final idx = _indexOf(menuId, '');
    if (idx == -1) return;
    if (items[idx].quantity > 1) {
      items[idx].quantity--;
    } else {
      items.removeAt(idx);
    }
    items.refresh();
  }

  // ── Tambah dari Detail (dengan catatan, sekali jalan) ────────────────────
  void addItem(MenuItem item, int quantity, String catatan) {
    if (quantity <= 0) return;
    if (!_available(item.id, item.nama)) return;
    final note = catatan.trim();
    final idx = _indexOf(item.id, note);
    if (idx != -1) {
      items[idx].quantity += quantity;
    } else {
      items.add(CartItem(menuItem: item, quantity: quantity, catatan: note));
    }
    items.refresh();
  }

  // ── Operasi per-baris (dipakai di tab Cart) ──────────────────────────────
  void incrementAt(int index) {
    if (index < 0 || index >= items.length) return;
    if (!_available(items[index].menuItem.id, items[index].menuItem.nama)) {
      return;
    }
    items[index].quantity++;
    items.refresh();
  }

  void decrementAt(int index) {
    if (index < 0 || index >= items.length) return;
    if (items[index].quantity > 1) {
      items[index].quantity--;
    } else {
      items.removeAt(index);
    }
    items.refresh();
  }

  void removeAt(int index) {
    if (index < 0 || index >= items.length) return;
    items.removeAt(index);
    items.refresh();
  }

  void clearCart() {
    items.clear();
    items.refresh();
  }

  // ── Total ────────────────────────────────────────────────────────────────
  int get totalItem {
    int s = 0;
    for (int i = 0; i < items.length; i++) {
      s += items[i].quantity;
    }
    return s;
  }

  int get totalHarga {
    int s = 0;
    for (int i = 0; i < items.length; i++) {
      s += items[i].subtotal;
    }
    return s;
  }

  String get totalHargaFormatted => formatRupiah(totalHarga);
}
