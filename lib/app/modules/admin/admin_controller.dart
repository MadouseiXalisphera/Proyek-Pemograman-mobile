import 'package:flutter/material.dart'; // Tambahkan import untuk GetX
import 'package:get/get.dart';
import '../../data/services/order_api_service.dart';

class AdminController extends GetxController {
  final OrderApiService _api = Get.find<OrderApiService>();

  final RxList<dynamic> pendingOrders = <dynamic>[].obs;
  final RxList<dynamic> historyOrders = <dynamic>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    try {
      final pending = await _api.getPendingPayments();
      final history = await _api.getAllOrders();
      pendingOrders.assignAll(pending);
      historyOrders.assignAll(history);
    } catch (e) {
      print("Error loading data: $e");
      // MUNCULKAN ERROR DI LAYAR KASIR!
      Get.snackbar(
        'Gagal Mengambil Data',
        e.toString(),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirm(String orderId) async {
    try {
      await _api.confirmPayment(orderId);
      Get.snackbar('Sukses', 'Pembayaran berhasil dikonfirmasi!');
      loadAllData(); // Refresh data otomatis
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> cancel(String orderId) async {
    try {
      await _api.cancelOrder(orderId);
      Get.snackbar(
        'Ditolak',
        'Pesanan berhasil dibatalkan',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      loadAllData(); // Refresh data agar pesanan yang ditolak hilang dari daftar
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
