import 'package:get/get.dart';
import 'package:flutter/material.dart';
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

  // Tambahkan fungsi ini di dalam class UserOrderController
  Future<void> hideCancelledOrder(String orderId) async {
    try {
      await _api.hideOrder(orderId);
      loadOrders(); // Refresh daftar pesanan setelah disembunyikan
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
