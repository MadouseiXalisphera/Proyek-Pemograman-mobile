import 'package:get/get.dart';

import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';

/// Controller sisi admin/kasir.
///
/// - `awaiting`  : pesanan menunggu validasi pembayaran (manual).
/// - `all`       : rekap seluruh pesanan (tercatat di admin).
/// Validasi manual: confirm() menandai sudah dibayar → pesanan masuk kitchen;
/// cancel() menolak. Saat Supabase, kedua aksi jadi UPDATE kolom di tabel
/// `orders` dan otomatis tersinkron ke perangkat lain via Realtime.
class AdminController extends GetxController {
  final OrderService _orders = Get.find<OrderService>();

  RxList<OrderModel> get reactiveSource => _orders.orders;

  List<OrderModel> get awaiting => _orders.ordersAwaitingPayment();

  List<OrderModel> get all {
    final list = List<OrderModel>.from(_orders.orders);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  void confirm(String orderId) => _orders.confirmPayment(orderId);
  void cancel(String orderId) => _orders.cancelOrder(orderId);
}
