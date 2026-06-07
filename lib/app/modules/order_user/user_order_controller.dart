import 'package:get/get.dart';

import '../../data/services/auth_service.dart';
import '../../data/services/order_api_service.dart';

class UserOrderController extends GetxController {
  final _api = Get.find<OrderApiService>();
  final _auth = Get.find<AuthService>();

  RxList<dynamic> orders = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final tableNumber = _auth.currentUser?.namaMeja ?? '';
    final result = await _api.getUserOrders(tableNumber);

    orders.value = result.where((e) => e['status'] != 'done').toList();
  }
}
