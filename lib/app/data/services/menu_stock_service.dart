import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';

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
}
