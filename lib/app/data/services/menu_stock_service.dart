import 'package:get/get.dart';

import '../models/menu_item_model.dart';

/// Stok per menu (reaktif, in-memory).
///
/// Aturan:
///   - addStock  : +100 unit
///   - emptyStock : set 0 (habis)
///   - status diturunkan dari jumlah: >0 "Stock Ready", 0 "Habis"
///   - isAvailable dipakai sisi pelanggan untuk menonaktifkan menu habis.
///
/// LOKAL sekarang. Supabase nanti: tabel `menu_stock(menu_id, qty)`; addStock/
/// emptyStock jadi UPDATE, dan stok tersinkron ke semua perangkat via Realtime.
class MenuStockService {
  static const int restockAmount = 100;

  final RxMap<String, int> _stock = <String, int>{}.obs;

  RxMap<String, int> get stock => _stock;

  /// Inisialisasi stok awal untuk semua menu (default siap = restockAmount).
  void init(List<MenuItem> menu) {
    for (int i = 0; i < menu.length; i++) {
      _stock.putIfAbsent(menu[i].id, () => restockAmount);
    }
  }

  int stockOf(String menuId) => _stock[menuId] ?? 0;

  bool isAvailable(String menuId) => stockOf(menuId) > 0;

  void addStock(String menuId) {
    _stock[menuId] = stockOf(menuId) + restockAmount;
  }

  void emptyStock(String menuId) {
    _stock[menuId] = 0;
  }
}
