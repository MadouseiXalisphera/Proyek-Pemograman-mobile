import 'package:get/get.dart';

import 'shell_tabs.dart';

/// Controller navigasi shell PELANGGAN.
///
/// Menyimpan index tab aktif sebagai state reaktif. Halaman anak (mis. Home
/// floating bar, atau empty-state Cart) memanggil method di sini untuk pindah
/// tab — bukan push route — sehingga state tiap tab tetap hidup.
class UserShellController extends GetxController {
  final RxInt index = UserTab.home.obs;

  void changeTab(int i) {
    if (i == index.value) return;
    index.value = i;
  }

  void goToHome() => changeTab(UserTab.home);
  void goToCart() => changeTab(UserTab.cart);
  void goToOrder() => changeTab(UserTab.order);
}
