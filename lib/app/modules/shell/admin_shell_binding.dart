import 'package:get/get.dart';

import '../admin/admin_controller.dart';
import 'admin_shell_controller.dart';

class AdminShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminShellController>(() => AdminShellController());
    Get.lazyPut<AdminController>(() => AdminController());
  }
}
