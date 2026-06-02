import '../models/order_model.dart';

class OrderService {
  final List<OrderModel> _orders = [];

  String addOrder(OrderModel order) {
    _orders.add(order);
    return order.id;
  }

  OrderModel? getById(String id) {
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].id == id) return _orders[i];
    }
    return null;
  }

  void updateStatus(String id, String status) {
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].id == id) {
        _orders[i].status = status;
        break;
      }
    }
  }
}
