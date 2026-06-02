import 'cart_item_model.dart';

enum PaymentMethod { cash, transfer, qris }

class OrderModel {
  final String id;
  final String namaPemesan;
  final String namaMeja;
  final String? nomorHp;
  final String email;
  final PaymentMethod paymentMethod;
  final List<CartItem> items;
  final int totalHarga;
  String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.namaPemesan,
    required this.namaMeja,
    this.nomorHp,
    required this.email,
    required this.paymentMethod,
    required this.items,
    required this.totalHarga,
    this.status = 'pending',
    required this.createdAt,
  });
}
