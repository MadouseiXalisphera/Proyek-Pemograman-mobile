import 'package:get/get.dart';

import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';

/// Controller tab RIWAYAT kitchen.
///
/// Riwayat = semua pesanan yang sudah DIBAYAR (paymentConfirmed) & tidak
/// dibatalkan, termasuk yang sudah selesai. Beda dengan tab "Order" yang
/// hanya menampilkan yang BELUM selesai. Logika baca dari OrderService yang
/// sama (reaktif), tanpa menyentuh state lain.
class KitchenHistoryController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();

  RxList<OrderModel> get _orders => _orderService.orders;

  /// Semua pesanan yang relevan untuk kitchen, terbaru di atas.
  List<OrderModel> get history {
    final result = <OrderModel>[];
    for (int i = 0; i < _orders.length; i++) {
      final o = _orders[i];
      if (o.paymentConfirmed && !o.cancelled) result.add(o);
    }
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }
}
