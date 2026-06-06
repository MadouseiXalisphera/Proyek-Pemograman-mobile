import 'package:get/get.dart';

import 'shell_tabs.dart';

/// Controller navigasi shell KITCHEN.
class KitchenShellController extends GetxController {
  final RxInt index = KitchenTab.order.obs;

  void changeTab(int i) {
    if (i == index.value) return;
    index.value = i;
  }
}
