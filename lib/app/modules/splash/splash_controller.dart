import 'package:get/get.dart';

import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

// ════════════════════════════════════════════════════════════════════════
// SPLASH CONTROLLER
// CATATAN: init service global TETAP di main.dart (tidak dipindah). Controller
// ini hanya mengambil alih dua peran dari splash.js (web):
//   1) tentukan halaman tujuan dari sesi login (service sudah siap dr main)
//   2) jaga durasi minimal splash (MIN_SHOW_MS = 1300ms) lalu fade-out & pindah
// ════════════════════════════════════════════════════════════════════════

class SplashController extends GetxController {
  // Durasi minimal splash tampil — branding sempat terbaca (= MIN_SHOW_MS web).
  static const Duration minShow = Duration(milliseconds: 1300);

  // Durasi fade-out konten sebelum pindah halaman (= transition opacity web).
  static const Duration fadeOut = Duration(milliseconds: 350);

  // Dikonsumsi SplashView (Obx) untuk fade-out konten sebelum navigasi.
  final RxBool contentVisible = true.obs;

  @override
  void onReady() {
    super.onReady();
    // onReady dipanggil SETELAH frame pertama splash benar-benar tampil.
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final stopwatch = Stopwatch()..start();

    // Service global sudah di-init di main.dart. Di sini hanya menentukan
    // halaman tujuan dari sesi login (cepat — SharedPreferences sudah dimuat).
    final String destination = await _resolveInitialRoute();

    // Jaga durasi minimal splash.
    final int elapsed = stopwatch.elapsedMilliseconds;
    final int remaining = minShow.inMilliseconds - elapsed;
    if (remaining > 0) {
      await Future.delayed(Duration(milliseconds: remaining));
    }

    // Fade-out konten splash, lalu pindah & buang splash dari stack.
    contentVisible.value = false;
    await Future.delayed(fadeOut);
    Get.offAllNamed(destination);
  }

  // Logika ini DIPINDAH dari main.dart (blok "Keputusan halaman awal").
  Future<String> _resolveInitialRoute() async {
    final auth = Get.find<AuthService>();
    bool loggedIn = false;
    try {
      loggedIn = await auth.checkSession();
    } catch (_) {
      loggedIn = false;
    }

    if (loggedIn) {
      return AppRoutes.shellForRole(auth.currentUser?.role ?? 'user');
    }
    return AppRoutes.login;
  }
}
