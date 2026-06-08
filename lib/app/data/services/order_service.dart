import 'package:get/get.dart';

import '../models/cart_item_model.dart';
import '../models/menu_item_model.dart';
import '../models/order_model.dart';
import 'menu_stock_service.dart';

/// Store pesanan (reaktif, in-memory).
///
/// LOKAL: pesanan hanya terlihat dalam instance app yang sama. Validasi
/// pembayaran dilakukan manual oleh kasir/admin (confirmPayment). Saat migrasi
/// Supabase: ganti backing list dengan query+Realtime ke tabel `orders`;
/// confirmPayment → UPDATE `payment_confirmed`. Signature dijaga agar
/// controller/view tidak berubah.
class OrderService {
  final RxList<OrderModel> _orders = <OrderModel>[].obs;

  /// Penghitung nomor pesanan PER MEJA (nama meja → nomor terakhir).
  final Map<String, int> _mejaCounter = <String, int>{};

  RxList<OrderModel> get orders => _orders;

  /// Tetapkan nomor urut berikutnya untuk satu meja.
  int _assignOrderNo(String namaMeja) {
    final next = (_mejaCounter[namaMeja] ?? 0) + 1;
    _mejaCounter[namaMeja] = next;
    return next;
  }

  /// Tambah pesanan baru → diberi nomor per meja (mis. A1-1, A1-2, B2-1).
  String addOrder(OrderModel order) {
    order.orderNo = _assignOrderNo(order.namaMeja);
    _orders.add(order);
    return order.id;
  }

  OrderModel? getById(String id) {
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].id == id) return _orders[i];
    }
    return null;
  }

  /// Pesanan satu meja (semua status), terbaru di atas. Untuk tab Order user.
  List<OrderModel> ordersForMeja(String namaMeja) {
    final result = <OrderModel>[];
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].namaMeja == namaMeja) result.add(_orders[i]);
    }
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  // ── Validasi pembayaran (kasir/admin) ──────────────────────────────────
  List<OrderModel> ordersAwaitingPayment() {
    final result = <OrderModel>[];
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].awaitingPayment) result.add(_orders[i]);
    }
    result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return result;
  }

  /// Kasir memvalidasi pembayaran → pesanan masuk dapur.
  /// STOK dikurangi DI SINI (saat divalidasi), bukan saat pesanan dibuat.
  /// Guard `paymentConfirmed`: bila sudah dikonfirmasi, tidak melakukan apa-apa
  /// (mencegah stok dikurangi dua kali bila tombol diklik berkali-kali).
  void confirmPayment(String orderId) {
    final o = getById(orderId);
    if (o == null || o.paymentConfirmed) return;

    o.paymentConfirmed = true;

    // Kurangi stok sesuai jumlah pesanan (FRONT END, in-memory).
    // Supabase nanti: jadikan transaksi/RPC atomik agar aman dari race.
    final stock = Get.find<MenuStockService>();
    for (final it in o.items) {
      stock.consume(it.menuItem.id, it.quantity);
    }

    _orders.refresh();
  }

  void cancelOrder(String orderId) {
    final o = getById(orderId);
    if (o == null) return;
    o.cancelled = true;
    _orders.refresh();
  }

  // ── Kitchen ─────────────────────────────────────────────────────────────
  /// HANYA pesanan yang sudah dibayar & belum selesai, dikelompokkan per meja.
  Map<String, List<OrderModel>> ordersByTableForKitchen() {
    final map = <String, List<OrderModel>>{};
    for (int i = 0; i < _orders.length; i++) {
      final o = _orders[i];
      if (!o.isVisibleToKitchen) continue;
      map.putIfAbsent(o.namaMeja, () => <OrderModel>[]).add(o);
    }
    return map;
  }

  /// Maju status satu item (confirm → ready → done). Dipakai kitchen.
  void advanceItemStatus(String orderId, CartItem item) {
    final o = getById(orderId);
    if (o == null) return;
    for (int j = 0; j < o.items.length; j++) {
      if (identical(o.items[j], item)) {
        o.items[j].status = _next(o.items[j].status);
        _orders.refresh();
        return;
      }
    }
  }

  ItemStatus _next(ItemStatus s) {
    switch (s) {
      case ItemStatus.confirm:
        return ItemStatus.ready;
      case ItemStatus.ready:
        return ItemStatus.done;
      case ItemStatus.done:
        return ItemStatus.done;
    }
  }

  bool orderIsDone(OrderModel o) =>
      o.paymentConfirmed &&
      o.items.isNotEmpty &&
      o.items.every((i) => i.status == ItemStatus.done);

  bool get hasDoneOrders => _orders.any(orderIsDone);

  /// Hapus pesanan yang seluruh itemnya selesai.
  /// CATATAN: store ini DIPAKAI BERSAMA user & kitchen — memanggil ini akan
  /// ikut menghapus pesanan dari RIWAYAT USER. Tombol pemicunya SUDAH
  /// DIHILANGKAN dari UI kitchen. Fungsi tetap disediakan untuk maintenance.
  void removeDoneOrders() => _orders.removeWhere(orderIsDone);

  // ── Seed demo (lokal) ───────────────────────────────────────────────────
  void seedDemo(List<MenuItem> menu) {
    if (_orders.isNotEmpty || menu.isEmpty) return;
    MenuItem pick(String id) =>
        menu.firstWhere((m) => m.id == id, orElse: () => menu.first);

    void add(OrderModel o) {
      o.orderNo = _assignOrderNo(o.namaMeja);
      _orders.add(o);
    }

    add(OrderModel(
      id: 'SEED1',
      namaPemesan: 'Demo 1',
      namaMeja: 'Meja A1',
      email: 'demo1@cafe.test',
      paymentMethod: PaymentMethod.qris,
      items: [
        CartItem(menuItem: pick('nasi_goreng'), quantity: 3),
        CartItem(menuItem: pick('lemon_tea'), quantity: 3),
      ],
      totalHarga: pick('nasi_goreng').harga * 3 + pick('lemon_tea').harga * 3,
      paymentConfirmed: true,
      createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
    ));
    add(OrderModel(
      id: 'SEED2',
      namaPemesan: 'Demo 2',
      namaMeja: 'Meja B2',
      email: 'demo2@cafe.test',
      paymentMethod: PaymentMethod.transfer,
      items: [
        CartItem(menuItem: pick('mie_goreng'), quantity: 2),
        CartItem(menuItem: pick('es_teh_manis'), quantity: 2),
      ],
      totalHarga: pick('mie_goreng').harga * 2 + pick('es_teh_manis').harga * 2,
      paymentConfirmed: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
    ));
  }
}
