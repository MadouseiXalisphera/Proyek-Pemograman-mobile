import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';

class MenuStockService {
  Future<void> addStock(String id, int qty) async {
    await http.post(
      Uri.parse('${ApiConfig.baseUrl}/menu/add_stock.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': int.parse(id), 'qty': qty}),
    );
  }

  Future<void> emptyStock(String id) async {
    await http.post(
      Uri.parse('${ApiConfig.baseUrl}/menu/empty_stock.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': int.parse(id)}),
    );
  }

  // Fallback fungsi lokal agar tidak error saat di-build
  bool isAvailable(String menuId) {
    return true;
  }

  void consume(String menuId, int qty) {
    // Fungsi ini dikosongkan karena pengurangan stok
    // akan diurus langsung di server (PHP/MySQL) nantinya.
  }

  void init(List<dynamic> menus) {
    // Kosong (Data sudah ditarik via API get_all.php)
  }
}
