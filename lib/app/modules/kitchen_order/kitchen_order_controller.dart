import 'package:get/get.dart';

import '../../data/services/order_api_service.dart';

class KitchenOrderController extends GetxController {
  final OrderApiService _api = Get.find<OrderApiService>();

  final RxList<Map<String, dynamic>> kitchenOrders =
      <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;

      final data = await _api.getKitchenOrders();

      kitchenOrders.assignAll(
        data.cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> advanceStatus(
    Map<String, dynamic> item,
  ) async {
    final current = item['status'].toString();

    String next;

    if (current == 'confirm') {
      next = 'ready';
    } else if (current == 'ready') {
      next = 'done';
    } else {
      return;
    }

    await _api.updateItemStatus(
      item['item_id'].toString(),
      next,
    );

    await loadOrders();
  }
}
