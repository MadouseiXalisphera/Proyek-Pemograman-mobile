import 'menu_item_model.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;
  String catatan;

  CartItem({
    required this.menuItem,
    required this.quantity,
    this.catatan = '',
  });

  int get subtotal => menuItem.harga * quantity;
}
