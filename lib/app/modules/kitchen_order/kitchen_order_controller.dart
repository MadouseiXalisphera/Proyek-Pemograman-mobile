import 'package:get/get.dart';

import '../../data/models/cart_item_model.dart';
import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';

/// Controller layar Order kitchen. Logika transisi & agregasi ada di
/// OrderService; controller hanya menyalurkan aksi dan menyiapkan data
/// terkelompok per meja.
class KitchenOrderController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();

  RxList<OrderModel> get orders => _orderService.orders;

  Map<String, List<OrderModel>> get grouped =>
      _orderService.ordersByTableForKitchen();

  bool get hasDoneOrders => _orderService.hasDoneOrders;

  void advance(OrderModel order, CartItem item) =>
      _orderService.advanceItemStatus(order.id, item);

  void clearDone() => _orderService.removeDoneOrders();
}
