import 'package:get/get.dart';

import 'shell_tabs.dart';

/// Controller navigasi shell ADMIN/KASIR.
class AdminShellController extends GetxController {
  final RxInt index = AdminTab.dashboard.obs;

  void changeTab(int i) {
    if (i == index.value) return;
    index.value = i;
  }
}
