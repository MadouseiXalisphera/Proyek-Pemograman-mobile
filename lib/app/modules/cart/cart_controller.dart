import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/menu_item_model.dart';
import '../../data/services/menu_stock_service.dart';

class CartController extends GetxController {
  final RxList<CartItem> items = <CartItem>[].obs;

  int getQuantity(String menuId) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].menuItem.id == menuId) return items[i].quantity;
    }
    return 0;
  }

  void increment(String menuId, MenuItem item) {
    // Tolak menu yang stoknya habis (di-set Empty oleh kitchen).
    if (Get.isRegistered<MenuStockService>() &&
        !Get.find<MenuStockService>().isAvailable(menuId)) {
      Get.snackbar(
        'Stok habis',
        '${item.nama} sedang tidak tersedia',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger.withValues(alpha: 0.12),
        colorText: AppColors.danger,
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 1600),
      );
      return;
    }
    for (int i = 0; i < items.length; i++) {
      if (items[i].menuItem.id == menuId) {
        items[i].quantity++;
        items.refresh();
        return;
      }
    }
    items.add(CartItem(menuItem: item, quantity: 1, catatan: ''));
    items.refresh();
  }

  void decrement(String menuId) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].menuItem.id == menuId) {
        if (items[i].quantity > 1) {
          items[i].quantity--;
          items.refresh();
        } else {
          items.removeAt(i);
          items.refresh();
        }
        return;
      }
    }
  }

  void setCatatan(String menuId, String catatan) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].menuItem.id == menuId) {
        items[i].catatan = catatan;
        break;
      }
    }
    items.refresh();
  }

  void removeItem(String menuId) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].menuItem.id == menuId) {
        items.removeAt(i);
        items.refresh();
        return;
      }
    }
  }

  void addItem(MenuItem item) {
    increment(item.id, item);
  }

  void clearCart() {
    items.clear();
    items.refresh();
  }

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
