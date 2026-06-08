import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';

/// Stok per menu (reaktif, in-memory).
///
/// Aturan:
///   - addStock   : +100 unit
///   - emptyStock : set 0 (habis)
///   - consume    : kurangi sesuai jumlah pesanan (tidak boleh < 0)
///   - status diturunkan dari jumlah: >0 "Stock Ready", 0 "Habis"
///   - isAvailable dipakai sisi pelanggan untuk menonaktifkan menu habis.
///
/// LOKAL sekarang. Supabase nanti: tabel `menu_stock(menu_id, qty)`; addStock/
/// emptyStock/consume jadi UPDATE. Khusus `consume`, gunakan transaksi/RPC
/// atomik di server (mis. `update ... set qty = greatest(qty - n, 0)`
/// berkondisi) agar aman dari race saat banyak meja memesan bersamaan, lalu
/// stok tersinkron ke semua perangkat via Realtime.
class MenuStockService {
  Future<void> addStock(String id, int qty) async {
    await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/menu/add_stock.php',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': int.parse(id),
        'qty': qty,
      }),
    );
  }

  Future<void> emptyStock(String id) async {
    await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/menu/empty_stock.php',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': int.parse(id),
      }),
    );
  }

  /// Kurangi stok saat pesanan dibuat. Tidak pernah negatif.
  void consume(String menuId, int qty) {
    if (qty <= 0) return;
    final next = stockOf(menuId) - qty;
    _stock[menuId] = next < 0 ? 0 : next;
  }
}
