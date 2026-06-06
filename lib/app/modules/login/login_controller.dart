import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  // Form
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State observable
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  final AuthService _auth = Get.find<AuthService>();

  void toggleObscure() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Validator manual — sederhana, tanpa regex package
  String? validateUsername(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Username tidak boleh kosong';
    }
    if (v.trim().length < 3) {
      return 'Username minimal 3 karakter';
    }
    return null;
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (v.length < 4) {
      return 'Password minimal 4 karakter';
    }
    return null;
  }

  Future<void> submit() async {
    // Validasi form
    final form = formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    // Hindari double-tap
    if (isLoading.value) return;
    isLoading.value = true;

    final username = usernameC.text.trim();
    final password = passwordC.text;

    final error = await _auth.login(username, password);

    isLoading.value = false;

    if (error != null) {
      Get.snackbar(
        'Login Gagal',
        error,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEBEE),
        colorText: const Color(0xFFB00020),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Berhasil — arahkan ke shell sesuai role, hapus stack.
    final role = _auth.currentUser?.role ?? 'user';
    Get.offAllNamed(AppRoutes.shellForRole(role));
  }

  @override
  void onClose() {
    usernameC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
