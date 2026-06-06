import 'menu_item_model.dart';

/// Status pengerjaan item di sisi kitchen (alur 3 kondisi).
///  - confirm : baru masuk, menunggu kitchen → tombol "Confirm Order"
///  - ready   : sudah dikonfirmasi & siap diambil → tombol centang (✓)
///  - done    : selesai diambil → "Selesai" (terminal)
enum ItemStatus { confirm, ready, done }

class CartItem {
  final MenuItem menuItem;
  int quantity;
  String catatan;

  /// Status kitchen per item. Default `confirm` saat pesanan dibuat; hanya
  /// dipakai/diubah di sisi kitchen (diabaikan di keranjang pelanggan).
  ItemStatus status;

  CartItem({
    required this.menuItem,
    required this.quantity,
    this.catatan = '',
    this.status = ItemStatus.confirm,
  });

  int get subtotal => menuItem.harga * quantity;

  /// Salinan independen — dipakai saat membekukan item ke dalam OrderModel,
  /// supaya perubahan status di kitchen tidak menyentuh objek keranjang.
  CartItem copy() => CartItem(
        menuItem: menuItem,
        quantity: quantity,
        catatan: catatan,
        status: status,
      );
}
