import 'package:get/get.dart';

import '../kitchen_order/kitchen_order_controller.dart';
import '../menu_stock/menu_stock_controller.dart';
import 'kitchen_shell_controller.dart';

class KitchenShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KitchenShellController>(() => KitchenShellController());
    Get.lazyPut<KitchenOrderController>(() => KitchenOrderController());
    Get.lazyPut<MenuStockController>(() => MenuStockController());
  }
}
