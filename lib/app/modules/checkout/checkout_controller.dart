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

class CheckoutController extends GetxController {
  // Aturan bukti pembayaran (VALIDASI INPUT ada di FRONT END selama belum ada
  // backend; saat Supabase, batas ukuran/format WAJIB juga dipaksa di server
  // lewat Storage policy. Lihat docs/BACKEND.md).
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

  // Bukti bayar disimpan sebagai BYTES (bekerja juga di web).
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

  bool get hasProof =>
      proofBytes.value != null && proofBytes.value!.isNotEmpty;

  String get proofHint =>
      'Format ${acceptedFormats.join('/').toUpperCase()}, maks $maxProofMb MB.';

  // 5. Pilih metode (terkunci setelah confirm)
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

  // 7. STEP 1 — Confirm & Pay (tanpa pindah halaman)
  void confirmAndPay() {
    // Guard anti double-klik saat sedang submit.
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

  // 8. Salin nomor rekening (tanpa paket)
  Future<void> copyAccountNumber() async {
    await Clipboard.setData(ClipboardData(text: accountNumber));
    _snack('Tersalin', 'Nomor rekening disalin', AppColors.primary);
  }

  // 9. Upload bukti pembayaran (VALIDASI format + ukuran di FRONT END)
  Future<void> pickProof() async {
    try {
      final picked = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return;

      // Validasi format dari ekstensi nama file.
      final name = picked.name.toLowerCase();
      final dot = name.lastIndexOf('.');
      final ext = dot == -1 ? '' : name.substring(dot + 1);
      if (!acceptedFormats.contains(ext)) {
        _snack('Format tidak didukung',
            'Pakai ${acceptedFormats.join('/').toUpperCase()}', AppColors.danger);
        return;
      }

      // Validasi ukuran (≤ maxProofMb).
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

  // 11. STEP 2 — Kirim ke kasir: commit order + clear cart + ke tab Order.
  Future<void> finalize() async {
    if (isSubmitting.value || _draft == null) return;
  // 10. STEP 2 — Kirim ke kasir (SINKRON).
  //
  // PENTING: selama LOKAL (satu instance app), bukti pembayaran dibawa sebagai
  // BYTES di dalam order agar bisa langsung ditampilkan kasir. JANGAN
  // mengosongkan bytes / meng-`await` upload ke storage di sini (memicu error
  // "disposed EngineFlutterView" di web + bukti tak tampil). Upload ke Supabase
  // Storage baru dilakukan pada tahap Supabase.
  //
  // CATATAN STOK: pengurangan stok TIDAK dilakukan di sini, melainkan saat
  // KASIR memvalidasi pembayaran (OrderService.confirmPayment).
  void finalize() {
    if (isSubmitting.value || _draft == null) return; // guard anti double-klik
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
      paymentProofBytes: proofBytes.value, // bytes TETAP dibawa (tampil di kasir)
      paymentProofPath: proofName.value,
      // paymentConfirmed default false → menunggu validasi kasir.
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

    _orderService.addOrder(committed);
    _cart.clearCart();
    isSubmitting.value = false;

    if (Get.isRegistered<UserShellController>()) {
      Get.find<UserShellController>().goToOrder();
    }
    Get.back();
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
