import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/cart_item_model.dart';
import '../../data/models/order_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/order_service.dart';
import '../../routes/app_routes.dart';
import '../cart/cart_controller.dart';

class CheckoutController extends GetxController {
  // 1. Form key & TextEditingController
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController hpC = TextEditingController();
  final TextEditingController emailC = TextEditingController();

  // 2. State observable
  final Rx<PaymentMethod> paymentMethod = PaymentMethod.cash.obs;

  // 3. Dependencies
  final AuthService _auth = Get.find<AuthService>();
  final CartController _cart = Get.find<CartController>();
  final OrderService _orderService = Get.find<OrderService>();

  // 4. Getters dari dependency
  String get namaMeja => _auth.currentUser?.namaMeja ?? '-';
  List<CartItem> get items => _cart.items;
  int get totalHarga => _cart.totalHarga;
  String get totalHargaFormatted => _cart.totalHargaFormatted;

  // 5. Method action
  void selectPayment(PaymentMethod method) {
    paymentMethod.value = method;
  }

  // 6. Validators
  String? validateNama(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nama wajib diisi';
    if (v.trim().length < 2) return 'Nama minimal 2 karakter';
    if (v.trim().length > 50) return 'Nama maksimal 50 karakter';
    return null;
  }

  String? validateHp(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final trimmed = v.trim();
    for (int i = 0; i < trimmed.length; i++) {
      final char = trimmed.codeUnitAt(i);
      if (char < 48 || char > 57) return 'Hanya angka';
    }
    if (trimmed.length < 8) return 'Minimal 8 digit';
    return null;
  }

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
    final trimmed = v.trim();
    if (trimmed.length < 5) return 'Email tidak valid';
    final atIdx = trimmed.indexOf('@');
    if (atIdx <= 0) return 'Email tidak valid';
    final domain = trimmed.substring(atIdx + 1);
    if (!domain.contains('.')) return 'Email tidak valid';
    if (domain.indexOf('.') == 0 || domain.endsWith('.')) {
      return 'Email tidak valid';
    }
    return null;
  }

  // 7. Method utama
  void submit() {
    final form = formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    final id = 'ORD${DateTime.now().millisecondsSinceEpoch}';

    final order = OrderModel(
      id: id,
      namaPemesan: namaC.text.trim(),
      namaMeja: namaMeja,
      nomorHp: hpC.text.trim().isEmpty ? null : hpC.text.trim(),
      email: emailC.text.trim(),
      paymentMethod: paymentMethod.value,
      items: List.from(_cart.items),
      totalHarga: totalHarga,
      createdAt: DateTime.now(),
    );

    _orderService.addOrder(order);

    Get.toNamed(AppRoutes.payment, arguments: order);
  }

  // 8. Lifecycle
  @override
  void onClose() {
    namaC.dispose();
    hpC.dispose();
    emailC.dispose();
    super.onClose();
  }
}
