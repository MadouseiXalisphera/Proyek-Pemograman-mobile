import 'package:get/get.dart';
import '../../../data/services/order_api_service.dart';

class AdminDashboardController extends GetxController {
  final OrderApiService _api = Get.find<OrderApiService>();

  // Data dinamis: Senin - Minggu
  final salesData = <double>[0, 0, 0, 0, 0, 0, 0].obs;

  // Batas tertinggi grafik (agar tidak terpotong)
  final maxSales = 1000.0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    isLoading.value = true;
    try {
      final stats = await _api.getDashboardStats();
      salesData.assignAll(stats['sales']);

      // Tambahkan margin 20% di atas grafik tertinggi agar terlihat rapi
      double rawMax = stats['max_sales'];
      maxSales.value = rawMax == 0 ? 100000 : rawMax + (rawMax * 0.2);
    } catch (e) {
      print("Error Dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
