import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

/// Controller halaman konfirmasi logout.
///
/// Reusable untuk semua role: user memasukkan ulang password, baru logout.
/// Logika verifikasi ada di AuthService.verifyPassword (bukan dibandingkan
/// di sini), supaya saat migrasi Supabase cukup ganti satu method service.
class LogoutConfirmController extends GetxController {
  final TextEditingController passwordC = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool obscure = true.obs;
  final RxBool isLoading = false.obs;

  final AuthService _auth = Get.find<AuthService>();

  void toggleObscure() => obscure.value = !obscure.value;

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
    return null;
  }

  Future<void> submit() async {
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;
    if (isLoading.value) return;

    isLoading.value = true;
    // Simulasi delay verifikasi (mengikuti pola AuthService.login).
    await Future.delayed(const Duration(milliseconds: 400));

    final ok = _auth.verifyPassword(passwordC.text);
    if (!ok) {
      isLoading.value = false;
      passwordC.clear();
      Get.snackbar(
        'Verifikasi Gagal',
        'Password salah, coba lagi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEBEE),
        colorText: AppColors.danger,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    await _auth.logout();
    isLoading.value = false;
    // Hapus seluruh stack (termasuk shell) → kembali ke login.
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    passwordC.dispose();
    super.onClose();
  }
}
