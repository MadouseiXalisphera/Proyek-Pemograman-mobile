import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_notify.dart';
import '../../core/widgets/order_status_badge.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/services/order_service.dart';

/// Notifikasi POPUP untuk KITCHEN (pojok kanan-atas).
///
/// Dirancang agar TIDAK saling-trigger antar pesanan/menu dalam satu meja:
///   • Per-ITEM: saat kitchen menandai sebuah menu "siap" (confirm → ready),
///     popup menyebut PESANAN + NAMA MENU → "Pesanan A1-3 • Matcha Latte siap".
///   • Per-ORDER: saat pesanan baru masuk dapur (confirmed) & saat seluruh
///     pesanan selesai (done).
/// Pelacakan dikunci per `orderId` dan `orderId::menuId`.
class KitchenNotifier extends GetxController {
  final OrderService _orders = Get.find<OrderService>();

  final Map<String, String> _lastOrderStatus = {}; // orderId -> statusKey
  final Map<String, ItemStatus> _lastItem = {}; // "orderId::menuId" -> status
  Worker? _worker;

  String _itemKey(String orderId, String menuId) => '$orderId::$menuId';

  @override
  void onInit() {
    super.onInit();
    for (final o in _orders.orders) {
      _lastOrderStatus[o.id] = o.statusKey;
      for (final it in o.items) {
        _lastItem[_itemKey(o.id, it.menuItem.id)] = it.status;
      }
    }
    _worker = ever(_orders.orders, (_) => _check());
  }

  void _check() {
    for (final o in _orders.orders) {
      // 1) Per-ORDER: masuk dapur / selesai.
      final sk = o.statusKey;
      final prevSk = _lastOrderStatus[o.id];
      _lastOrderStatus[o.id] = sk;
      if (prevSk != sk) {
        if (sk == 'confirmed' &&
            (prevSk == null ||
                prevSk == 'waiting_payment' ||
                prevSk == 'waiting_confirmation')) {
          AppNotify.show(
            title: 'Pesanan ${o.displayNo} masuk',
            message: '${o.namaMeja} • ${o.items.length} item',
            color: AppColors.primary,
            icon: Icons.notifications_active_outlined,
          );
        } else if (sk == 'done') {
          AppNotify.show(
            title: 'Pesanan ${o.displayNo} selesai',
            message: o.namaMeja,
            color: OrderStatusView.of('done').color,
            icon: Icons.check_circle_outline,
          );
        }
      }

      // 2) Per-ITEM: menu tertentu jadi "siap" (menyebut menu mana).
      if (!o.paymentConfirmed || o.cancelled) continue;
      for (final it in o.items) {
        final key = _itemKey(o.id, it.menuItem.id);
        final prev = _lastItem[key];
        _lastItem[key] = it.status;
        if (prev != null && prev != it.status && it.status == ItemStatus.ready) {
          AppNotify.show(
            title: 'Pesanan ${o.displayNo} • ${o.namaMeja}',
            message: '${it.menuItem.nama} siap',
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
