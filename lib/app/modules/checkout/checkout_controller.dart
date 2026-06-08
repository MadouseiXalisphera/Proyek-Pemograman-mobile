import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/payment_info.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/order_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/order_service.dart';
import '../../data/services/payment_settings_service.dart';
import '../cart/cart_controller.dart';
import '../shell/user_shell_controller.dart';
import '../../data/services/order_api_service.dart';
import '../order_user/user_order_controller.dart';

class CheckoutController extends GetxController {
  static const int maxProofMb = 5;
  static const int _maxProofBytes = maxProofMb * 1024 * 1024;
  static const List<String> acceptedFormats = ['jpg', 'jpeg', 'png', 'webp'];

  // 1. Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController hpC = TextEditingController();
  final TextEditingController emailC = TextEditingController();

  // 2. State pembayaran
  final Rx<PaymentMethod> paymentMethod = PaymentMethod.cash.obs;
  final RxBool isConfirmed = false.obs;
  final RxBool isSubmitting = false.obs;

  final Rxn<Uint8List> proofBytes = Rxn<Uint8List>();
  final RxnString proofName = RxnString();

  // 3. Dependencies
  final AuthService _auth = Get.find<AuthService>();
  final CartController _cart = Get.find<CartController>();
  final OrderApiService _orderApi = Get.find<OrderApiService>();
  final OrderService _orderService = Get.find<OrderService>();
  final PaymentSettingsService _paymentSettings =
      Get.find<PaymentSettingsService>();

  OrderModel? _draft;

  // 4. Getters
  String get namaMeja => _auth.currentUser?.namaMeja ?? '-';
  List<CartItem> get items => _cart.items;
  int get totalHarga => _cart.totalHarga;
  String get totalHargaFormatted => _cart.totalHargaFormatted;
  String get qrisPath => _paymentSettings.qrisPath;
  String get bankName => PaymentInfo.bankName;
  String get accountNumber => PaymentInfo.accountNumber;
  String get accountHolder => PaymentInfo.accountHolder;

  bool get requiresProof =>
      paymentMethod.value == PaymentMethod.transfer ||
      paymentMethod.value == PaymentMethod.qris;

  bool get hasProof => proofBytes.value != null && proofBytes.value!.isNotEmpty;
  String get proofHint =>
      'Format ${acceptedFormats.join('/').toUpperCase()}, maks $maxProofMb MB.';

  // 5. Pilih metode (Kunci dilepas agar bisa diganti kapan saja)
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
      final c = trimmed.codeUnitAt(i);
      if (c < 48 || c > 57) return 'Hanya angka';
    }
    if (trimmed.length < 8) return 'Minimal 8 digit';
    if (trimmed.length > 15) return 'Maksimal 15 digit';
    return null;
  }

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
    final t = v.trim();
    if (t.length < 5) return 'Email tidak valid';
    final at = t.indexOf('@');
    if (at <= 0) return 'Email tidak valid';
    final domain = t.substring(at + 1);
    if (!domain.contains('.')) return 'Email tidak valid';
    if (domain.startsWith('.') || domain.endsWith('.')) {
      return 'Email tidak valid';
    }
    return null;
  }

  // 7. STEP 1 — Confirm & Pay
  void confirmAndPay() {
    if (isSubmitting.value) return;
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;
    if (items.isEmpty) {
      _snack('Keranjang kosong', 'Tambahkan menu dulu', AppColors.danger);
      return;
    }
    _draft = OrderModel(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      namaPemesan: namaC.text.trim(),
      namaMeja: namaMeja,
      nomorHp: hpC.text.trim().isEmpty ? null : hpC.text.trim(),
      email: emailC.text.trim(),
      paymentMethod: paymentMethod.value,
      items: _cart.items.map((e) => e.copy()).toList(),
      totalHarga: totalHarga,
      createdAt: DateTime.now(),
    );
    isConfirmed.value = true;
  }

  // 8. Salin nomor rekening
  Future<void> copyAccountNumber() async {
    await Clipboard.setData(ClipboardData(text: accountNumber));
    _snack('Tersalin', 'Nomor rekening disalin', AppColors.primary);
  }

  // 9. Upload bukti
  Future<void> pickProof() async {
    try {
      final picked = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return;

      final name = picked.name.toLowerCase();
      final dot = name.lastIndexOf('.');
      final ext = dot == -1 ? '' : name.substring(dot + 1);
      if (!acceptedFormats.contains(ext)) {
        _snack(
            'Format tidak didukung',
            'Pakai ${acceptedFormats.join('/').toUpperCase()}',
            AppColors.danger);
        return;
      }

      final bytes = await picked.readAsBytes();
      if (bytes.lengthInBytes > _maxProofBytes) {
        _snack('Ukuran terlalu besar', 'Maksimal $maxProofMb MB',
            AppColors.danger);
        return;
      }

      proofBytes.value = bytes;
      proofName.value = picked.name;
    } catch (_) {
      _snack('Gagal', 'Tidak bisa membuka galeri', AppColors.danger);
    }
  }

  void removeProof() {
    proofBytes.value = null;
    proofName.value = null;
  }

  // 10. STEP 2 — Kirim ke kasir via API
  Future<void> finalize() async {
    if (isSubmitting.value || _draft == null) return;
    if (requiresProof && !hasProof) {
      _snack(
          'Bukti diperlukan', 'Unggah bukti pembayaran dulu', AppColors.danger);
      return;
    }
    isSubmitting.value = true;

    try {
      await _orderApi.createOrder({
        "customer_name": _draft!.namaPemesan,
        "table_name": _draft!.namaMeja,
        "phone": _draft!.nomorHp ?? "",
        "email": _draft!.email,
        "payment_method":
            paymentMethod.value.name, // Mengambil metode terupdate
        "total_price": _draft!.totalHarga,
        "payment_proof_name": proofName.value ?? "",
        "payment_proof_base64":
            proofBytes.value != null ? base64Encode(proofBytes.value!) : "",
        "items": _draft!.items.map((item) {
          return {
            "menu_name": item.menuItem.nama,
            "quantity": item.quantity,
            "price": item.menuItem.harga,
            "status": item.status.name,
          };
        }).toList(),
      });

      _cart.clearCart();

      if (Get.isRegistered<UserShellController>()) {
        Get.find<UserShellController>().goToOrder();
      }

      if (Get.isRegistered<UserOrderController>()) {
        Get.find<UserOrderController>().loadOrders();
      }

      Get.back();

      _snack('Pesanan dikirim', 'Pesanan berhasil masuk database',
          AppColors.primary);
    } catch (e) {
      _snack('Error', e.toString(), AppColors.danger);
    } finally {
      isSubmitting.value = false;
    }
  }

  void _snack(String title, String msg, Color color) {
    Get.snackbar(
      title,
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color.withValues(alpha: 0.12),
      colorText: color,
      margin: const EdgeInsets.all(16),
      duration: const Duration(milliseconds: 1800),
    );
  }

  @override
  void onClose() {
    namaC.dispose();
    hpC.dispose();
    emailC.dispose();
    super.onClose();
  }
}
