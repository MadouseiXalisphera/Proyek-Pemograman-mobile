import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/app_notify.dart';
import '../../core/widgets/order_status_badge.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/order_service.dart';

/// Notifikasi PELANGGAN (popup pojok kanan-atas).
///
/// Dua tingkat agar presisi & tidak saling-trigger antar pesanan/menu:
///   • Per-ITEM: saat sebuah menu menjadi "siap" → "Pesanan A1-3 • Matcha siap".
///   • Per-ORDER: saat pembayaran dikonfirmasi / pesanan selesai / dibatalkan.
/// Pelacakan dikunci per `orderId` dan per `orderId::menuId` sehingga aksi pada
/// satu item tidak memicu notifikasi item/pesanan lain.
class OrderNotifier extends GetxController {
  final OrderService _orders = Get.find<OrderService>();
  final AuthService _auth = Get.find<AuthService>();

  final Map<String, String> _lastOrderStatus = {}; // orderId -> statusKey
  final Map<String, ItemStatus> _lastItem = {}; // "orderId::menuId" -> status
  Worker? _worker;

  String get _meja => _auth.currentUser?.namaMeja ?? '';
  String _itemKey(String orderId, String menuId) => '$orderId::$menuId';

  @override
  void onInit() {
    super.onInit();
    // Snapshot awal (tanpa notifikasi) untuk status & item yang sudah ada.
    for (final o in _orders.ordersForMeja(_meja)) {
      _lastOrderStatus[o.id] = o.statusKey;
      for (final it in o.items) {
        _lastItem[_itemKey(o.id, it.menuItem.id)] = it.status;
      }
    }
    _worker = ever(_orders.orders, (_) => _check());
  }

  void _check() {
    final meja = _meja;
    if (meja.isEmpty) return;

    for (final o in _orders.ordersForMeja(meja)) {
      // 1) Milestone per-ORDER (pembayaran/selesai/batal).
      final sk = o.statusKey;
      final prevSk = _lastOrderStatus[o.id];
      _lastOrderStatus[o.id] = sk;
      if (prevSk != null && prevSk != sk) {
        switch (sk) {
          case 'confirmed':
            AppNotify.show(
              title: 'Pesanan ${o.displayNo}',
              message: 'Pembayaran dikonfirmasi, pesanan masuk dapur.',
              color: OrderStatusView.of('confirmed').color,
              icon: Icons.verified_outlined,
            );
            break;
          case 'done':
            AppNotify.show(
              title: 'Pesanan ${o.displayNo}',
              message: 'Semua pesanan selesai. Terima kasih!',
              color: OrderStatusView.of('done').color,
              icon: Icons.check_circle_outline,
            );
            break;
          case 'cancelled':
            AppNotify.show(
              title: 'Pesanan ${o.displayNo}',
              message: 'Pesanan dibatalkan. Hubungi kasir.',
              color: OrderStatusView.of('cancelled').color,
              icon: Icons.cancel_outlined,
            );
            break;
          default:
            break; // cooking/ready ditangani per-item agar lebih spesifik
        }
      }

      // 2) Per-ITEM: menu tertentu menjadi "siap".
      for (final it in o.items) {
        final key = _itemKey(o.id, it.menuItem.id);
        final prev = _lastItem[key];
        _lastItem[key] = it.status;
        if (prev != null && prev != it.status && it.status == ItemStatus.ready) {
          AppNotify.show(
            title: 'Pesanan ${o.displayNo}',
            message: '${it.menuItem.nama} siap diambil',
            color: OrderStatusView.of('ready').color,
            icon: Icons.room_service_outlined,
          );
        }
      }
    }
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }
}
