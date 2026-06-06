import 'package:get/get.dart';

import '../models/cart_item_model.dart';
import '../models/menu_item_model.dart';
import '../models/order_model.dart';

/// Store pesanan (reaktif, in-memory).
///
/// LOKAL: pesanan hanya terlihat dalam instance app yang sama. Validasi
/// pembayaran dilakukan manual oleh kasir/admin (confirmPayment). Saat migrasi
/// Supabase: ganti backing list dengan query+Realtime ke tabel `orders`;
/// confirmPayment menjadi UPDATE kolom `payment_confirmed`. Signature di sini
/// dijaga agar controller/view tidak berubah.
class OrderService {
  final RxList<OrderModel> _orders = <OrderModel>[].obs;

  RxList<OrderModel> get orders => _orders;

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
  /// Daftar pesanan yang menunggu validasi pembayaran (untuk admin).
  List<OrderModel> ordersAwaitingPayment() {
    final result = <OrderModel>[];
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].awaitingPayment) result.add(_orders[i]);
    }
    result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return result;
  }

  void confirmPayment(String orderId) {
    final o = getById(orderId);
    if (o == null) return;
    o.paymentConfirmed = true;
    _orders.refresh();
  }

  void cancelOrder(String orderId) {
    final o = getById(orderId);
    if (o == null) return;
    o.cancelled = true;
    _orders.refresh();
  }

  // ── Kitchen ─────────────────────────────────────────────────────────────
  /// HANYA pesanan yang sudah dibayar (paymentConfirmed) & belum selesai,
  /// dikelompokkan per meja. Inilah gating: kitchen tak melihat pesanan yang
  /// belum divalidasi kasir.
  Map<String, List<OrderModel>> ordersByTableForKitchen() {
    final map = <String, List<OrderModel>>{};
    for (int i = 0; i < _orders.length; i++) {
      final o = _orders[i];
      if (!o.isVisibleToKitchen) continue;
      map.putIfAbsent(o.namaMeja, () => <OrderModel>[]).add(o);
    }
    return map;
  }

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

  /// Hapus pesanan yang seluruh itemnya selesai (tombol "Clear all" kitchen).
  void removeDoneOrders() => _orders.removeWhere(orderIsDone);

  // ── Seed demo (lokal) ───────────────────────────────────────────────────
  void seedDemo(List<MenuItem> menu) {
    if (_orders.isNotEmpty || menu.isEmpty) return;
    MenuItem pick(String id) =>
        menu.firstWhere((m) => m.id == id, orElse: () => menu.first);

    _orders.addAll([
      // Sudah dibayar → tampil di kitchen.
      OrderModel(
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
      ),
      // Belum divalidasi → muncul di admin Payments, BUKAN di kitchen.
      OrderModel(
        id: 'SEED2',
        namaPemesan: 'Demo 2',
        namaMeja: 'Meja B2',
        email: 'demo2@cafe.test',
        paymentMethod: PaymentMethod.transfer,
        items: [
          CartItem(menuItem: pick('mie_goreng'), quantity: 2),
          CartItem(menuItem: pick('es_teh_manis'), quantity: 2),
        ],
        totalHarga:
            pick('mie_goreng').harga * 2 + pick('es_teh_manis').harga * 2,
        paymentConfirmed: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
    ]);
  }
}
