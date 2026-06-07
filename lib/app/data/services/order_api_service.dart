import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';

class OrderApiService {
  Future<void> createOrder(
    Map<String, dynamic> order,
  ) async {
    final response = await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/orders/create.php',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(order),
    );

    print(response.body);

    if (response.statusCode != 200) {
      throw Exception('Create order gagal');
    }
  }

  Future<List<dynamic>> getKitchenOrders() async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/orders/get_kitchen_orders.php',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data kitchen');
    }

    final data = jsonDecode(response.body);

    return data['data'];
  }

  Future<void> updateItemStatus(
    String itemId,
    String status,
  ) async {
    final response = await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/orders/update_item_status.php',
      ),
      body: {
        'id': itemId,
        'status': status,
      },
    );

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      throw Exception('Gagal update status');
    }
  }

  Future<List<dynamic>> getUserOrders(
    String tableNumber,
  ) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/orders/get_user_orders.php?table_name=$tableNumber',
      ),
    );

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      return [];
    }

    return data['data'];
  }
}
