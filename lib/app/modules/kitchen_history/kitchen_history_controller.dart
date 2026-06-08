import 'package:get/get.dart';
import '../../data/services/order_api_service.dart';

class KitchenHistoryController extends GetxController {
  final OrderApiService _api = Get.find<OrderApiService>();
  final RxList<dynamic> historyOrders = <dynamic>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    try {
      final data = await _api.getKitchenHistory();
      historyOrders.assignAll(data);
    } catch (e) {
      print("Error Kitchen History: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
