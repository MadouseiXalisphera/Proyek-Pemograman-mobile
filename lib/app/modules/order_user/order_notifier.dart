import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/order_status_badge.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/order_service.dart';

/// Notifikasi perubahan status pesanan untuk PELANGGAN (in-app).
///
/// LOKAL: karena semua berjalan di satu instance app, perubahan status yang
/// dilakukan kasir/kitchen langsung memicu listener ini → snackbar di sisi
/// user. SUPABASE nanti: ganti sumber dengan stream Realtime tabel `orders`
/// (listener tetap sama). Untuk notifikasi saat app di background, tambahkan
/// push (FCM) yang di-trigger dari perubahan baris — pola pemicunya identik.
class OrderNotifier extends GetxController {
  final OrderService _orders = Get.find<OrderService>();
  final AuthService _auth = Get.find<AuthService>();

  final Map<String, String> _lastSeen = {}; // orderId -> statusKey
  Worker? _worker;

  String get _meja => _auth.currentUser?.namaMeja ?? '';

  @override
  void onInit() {
    super.onInit();
    // Snapshot awal tanpa memberi notifikasi (status yang sudah ada).
    for (final o in _orders.ordersForMeja(_meja)) {
      _lastSeen[o.id] = o.statusKey;
    }
    _worker = ever(_orders.orders, (_) => _check());
  }

  void _check() {
    final meja = _meja;
    if (meja.isEmpty) return;
    for (final o in _orders.ordersForMeja(meja)) {
      final key = o.statusKey;
      final prev = _lastSeen[o.id];
      _lastSeen[o.id] = key;
      // Order baru (prev null) tidak dinotifikasi — user baru saja membuatnya.
      if (prev != null && prev != key) _notify(key);
    }
  }

  void _notify(String statusKey) {
    String message;
    switch (statusKey) {
      case 'confirmed':
        message = 'Pembayaran dikonfirmasi, pesanan masuk dapur.';
        break;
      case 'ready':
        message = 'Pesanan siap diambil!';
        break;
      case 'done':
        message = 'Pesanan selesai. Terima kasih!';
        break;
      case 'cancelled':
        message = 'Pesanan dibatalkan. Hubungi kasir.';
        break;
      default:
        message = OrderStatusView.of(statusKey).label;
    }
    final color = OrderStatusView.of(statusKey).color;
    Get.snackbar(
      'Update Pesanan',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color.withValues(alpha: 0.12),
      colorText: color,
      icon: Icon(Icons.notifications_active_outlined, color: color),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }
}
