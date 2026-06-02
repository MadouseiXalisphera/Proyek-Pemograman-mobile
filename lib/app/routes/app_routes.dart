// Konstanta path route — semua nama path didefinisikan di sini supaya konsisten
// dan typo-safe saat dipakai di Get.toNamed / Get.offNamed.

abstract class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';

  // Disiapkan untuk fase selanjutnya
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String howToUse = '/how-to-use';
}
