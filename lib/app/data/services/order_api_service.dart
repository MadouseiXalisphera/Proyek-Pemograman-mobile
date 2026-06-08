import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';

class OrderApiService {
  // --- Fungsi yang sudah ada ---
  Future<void> createOrder(Map<String, dynamic> order) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/orders/create.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order),
    );
    if (response.statusCode != 200) throw Exception('Create order gagal');
  }

  Future<List<dynamic>> getKitchenOrders() async {
    final response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}/orders/get_kitchen_orders.php'));
    final data = jsonDecode(response.body);
    if (data['success'] != true) return [];
    return data['data'];
  }

  Future<void> updateItemStatus(String itemId, String status) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/orders/update_item_status.php'),
      body: {'id': itemId, 'status': status},
    );
    final data = jsonDecode(response.body);
    if (data['success'] != true) throw Exception('Gagal update status');
  }

  Future<List<dynamic>> getUserOrders(String tableNumber) async {
    final response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}/orders/get_user_orders.php?table_name=$tableNumber'));
    final data = jsonDecode(response.body);
    if (data['success'] != true) return [];
    return data['data'];
  }

  // --- FUNGSI BARU UNTUK ADMIN ---
  Future<List<dynamic>> getPendingPayments() async {
    final response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}/orders/get_pending_payments.php'));
    print(
        "DEBUG PENDING PAYMENTS: ${response.body}"); // <-- Ini untuk ngecek isi aslinya apa

    final data = jsonDecode(response.body);
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Gagal load data pending payments');
    }
    return data['data'] ?? [];
  }

  Future<void> confirmPayment(String orderId) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/orders/confirm_payment.php'),
      body: {'id': orderId},
    );
    print("DEBUG CONFIRM PAYMENT: ${response.body}");

    final data = jsonDecode(response.body);
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Gagal konfirmasi pembayaran');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/orders/cancel_order.php'),
      body: {'id': orderId},
    );
    print("DEBUG CANCEL ORDER: ${response.body}");

    final data = jsonDecode(response.body);
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Gagal menolak pesanan');
    }
  }

  Future<List<dynamic>> getAllOrders() async {
    final response =
        await http.get(Uri.parse('${ApiConfig.baseUrl}/orders/get_all.php'));
    print("DEBUG GET ALL ORDERS: ${response.body}");

    final data = jsonDecode(response.body);
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Gagal load data semua order');
    }
    return data['data'] ?? [];
  }

  Future<void> hideOrder(String orderId) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/orders/hide_order.php'),
      body: {'order_id': orderId},
    );

    final data = jsonDecode(response.body);
    if (data['success'] != true) {
      throw Exception('Gagal menyembunyikan pesanan');
    }
  }

  // Tambahkan fungsi ini di dalam class OrderApiService
  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/orders/get_dashboard_stats.php'),
    );

    final data = jsonDecode(response.body);
    if (data['success'] != true) {
      throw Exception('Gagal memuat grafik dashboard');
    }

    return {
      'sales': List<double>.from(data['data'].map((e) => e.toDouble())),
      'max_sales': (data['max_sales'] as num).toDouble(),
    };
  }

  Future<List<dynamic>> getKitchenHistory() async {
    final response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}/orders/get_kitchen_history.php'));
    final data = jsonDecode(response.body);
    if (data['success'] != true) return [];
    return data['data'];
  }
}
