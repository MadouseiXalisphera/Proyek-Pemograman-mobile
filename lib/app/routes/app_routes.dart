// Konstanta path route — semua nama path didefinisikan di sini supaya konsisten
// dan typo-safe saat dipakai di Get.toNamed / Get.offNamed.

abstract class AppRoutes {
  AppRoutes._();

  // Pintu masuk app: splash beranimasi (init + keputusan route ada di sini).
  static const String splash = '/splash';

  static const String login = '/login';

  // Shell utama per role (berisi bottom nav + tab-nya masing-masing).
  static const String userShell = '/user';
  static const String kitchenShell = '/kitchen';
  static const String adminShell = '/admin';

  // Route yang di-push DI ATAS shell (bukan tab).
  static const String checkout = '/checkout';
  static const String logoutConfirm = '/logout-confirm';

  /// Tentukan shell tujуan berdasarkan role user.
  /// Dipakai saat login sukses & saat resume session di app start.
  static String shellForRole(String role) {
    switch (role) {
      case 'kitchen':
        return kitchenShell;
      case 'admin':
        return adminShell;
      case 'user':
      default:
        return userShell;
    }
  }
}
