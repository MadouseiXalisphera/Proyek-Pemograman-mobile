import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/format.dart';
import '../../data/models/menu_item_model.dart';
import '../cart/cart_controller.dart';

class DetailController extends GetxController {
  final MenuItem item;
  DetailController({required this.item});

  // 1. TextEditingController
  final TextEditingController catatanC = TextEditingController();

  // 2. State observable
  final RxInt quantity = 1.obs;

  // 3. Dependencies
  final CartController _cart = Get.find<CartController>();

  // 4. Getters
  int get totalHarga => item.harga * quantity.value;
  String get totalHargaFormatted => formatRupiah(totalHarga);

  // 5. Methods
  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void tambahKeKeranjang() {
    // Satu panggilan, tanpa loop (#3). Catatan ikut per-baris (#2).
    _cart.addItem(item, quantity.value, catatanC.text.trim());
    Get.back();
    Get.snackbar(
      'Berhasil',
      'Ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(milliseconds: 1500),
    );
  }

  // 6. Lifecycle
  @override
  void onClose() {
    catatanC.dispose();
    super.onClose();
  }
}
