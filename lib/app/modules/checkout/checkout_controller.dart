import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
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

class CheckoutController extends GetxController {
  // 1. Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController hpC = TextEditingController();
  final TextEditingController emailC = TextEditingController();

  // 2. State pembayaran
  final Rx<PaymentMethod> paymentMethod = PaymentMethod.cash.obs;
  final RxBool isConfirmed = false.obs; // section pembayaran sudah di-expand?
  final RxBool isSubmitting = false.obs;
  final RxnString proofPath = RxnString(); // path bukti yang diunggah

  // 3. Dependencies
  final AuthService _auth = Get.find<AuthService>();
  final CartController _cart = Get.find<CartController>();
  final OrderApiService _orderApi = Get.find<OrderApiService>();
  final OrderService _orderService = Get.find<OrderService>();
  final PaymentSettingsService _paymentSettings =
      Get.find<PaymentSettingsService>();

  // Draft dibangun saat confirm, baru di-commit ke OrderService saat finalize
  // (supaya tidak ada order yatim bila user mundur sebelum membayar).
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

  /// Transfer & QRIS wajib bukti; cash dibayar langsung ke kasir.
  bool get requiresProof =>
      paymentMethod.value == PaymentMethod.transfer ||
      paymentMethod.value == PaymentMethod.qris;

  bool get hasProof =>
      proofPath.value != null && proofPath.value!.trim().isNotEmpty;

  // 5. Aksi pemilihan metode (terkunci setelah confirm)
  void selectPayment(PaymentMethod method) {
    if (isConfirmed.value) return;
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

  // 7. STEP 1 — Confirm & Pay: validasi → bangun draft → expand pembayaran.
  //    TIDAK pindah halaman.
  void confirmAndPay() {
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

  // 8. Salin nomor rekening (Clipboard bawaan, tanpa paket).
  Future<void> copyAccountNumber() async {
    await Clipboard.setData(ClipboardData(text: accountNumber));
    _snack('Tersalin', 'Nomor rekening disalin', AppColors.primary);
  }

  // 9. Unduh QRIS ke galeri.
  Future<void> downloadQris() async {
    try {
      final path = qrisPath;
      late final Uint8List bytes;
      if (path.startsWith('http://') || path.startsWith('https://')) {
        _snack('QRIS dari server', 'Tahan gambar untuk menyimpan',
            AppColors.primary);
        return;
      } else if (path.startsWith('/') || path.startsWith('file:')) {
        final clean =
            path.startsWith('file:') ? Uri.parse(path).toFilePath() : path;
        bytes = await File(clean).readAsBytes();
      } else {
        final data = await rootBundle.load(path);
        bytes = data.buffer.asUint8List();
      }
      await Gal.putImageBytes(bytes, name: 'qris_cafe_amba');
      _snack('Tersimpan', 'QRIS disimpan ke galeri', AppColors.primary);
    } catch (_) {
      _snack('Gagal menyimpan', 'Tidak bisa menyimpan QRIS', AppColors.danger);
    }
  }

  // 10. Upload bukti pembayaran dari galeri.
  Future<void> pickProof() async {
    try {
      final picked = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked != null) proofPath.value = picked.path;
    } catch (_) {
      _snack('Gagal', 'Tidak bisa membuka galeri', AppColors.danger);
    }
  }

  void removeProof() => proofPath.value = null;

  // 11. STEP 2 — Kirim ke kasir: commit order + clear cart + ke tab Order.
  Future<void> finalize() async {
    if (isSubmitting.value || _draft == null) return;
    if (requiresProof && !hasProof) {
      _snack(
          'Bukti diperlukan', 'Unggah bukti pembayaran dulu', AppColors.danger);
      return;
    }
    isSubmitting.value = true;

    final committed = OrderModel(
      id: _draft!.id,
      namaPemesan: _draft!.namaPemesan,
      namaMeja: _draft!.namaMeja,
      nomorHp: _draft!.nomorHp,
      email: _draft!.email,
      paymentMethod: _draft!.paymentMethod,
      items: _draft!.items,
      totalHarga: _draft!.totalHarga,
      createdAt: _draft!.createdAt,
      paymentProofPath: proofPath.value,
      // paymentConfirmed default false → menunggu validasi kasir/admin
      // sebelum tampil di kitchen.
    );
    try {
      await _orderApi.createOrder({
        "customer_name": committed.namaPemesan,
        "table_name": committed.namaMeja,
        "phone": committed.nomorHp ?? "",
        "email": committed.email,
        "payment_method": committed.paymentMethod.name,
        "total_price": committed.totalHarga,
        "payment_proof": committed.paymentProofPath ?? "",
        "items": committed.items.map((item) {
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

      Get.back();

      _snack(
        'Pesanan dikirim',
        'Pesanan berhasil masuk database',
        AppColors.primary,
      );
    } catch (e) {
      _snack(
        'Error',
        e.toString(),
        AppColors.danger,
      );
    }
    _cart.clearCart();
    isSubmitting.value = false;

    if (Get.isRegistered<UserShellController>()) {
      Get.find<UserShellController>().goToOrder();
    }
    Get.back(); // tutup checkout, kembali ke shell
    _snack('Pesanan dikirim', 'Pesanan diteruskan ke kasir', AppColors.primary);
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
