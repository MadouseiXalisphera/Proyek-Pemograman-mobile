import 'package:get/get.dart';

import '../home/home_controller.dart';
import '../order_user/order_notifier.dart';
import 'user_shell_controller.dart';

class UserShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserShellController>(() => UserShellController());
    // HomeController dipakai oleh tab Home (dulu di HomeBinding).
    Get.lazyPut<HomeController>(() => HomeController());
    // Eager: mulai memantau status pesanan begitu masuk shell user.
    Get.put<OrderNotifier>(OrderNotifier());
  }
}
