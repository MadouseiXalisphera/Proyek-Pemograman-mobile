import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/payment_model.dart';
import '../../core/config/api_config.dart';

class PaymentService {
  Future<List<PaymentModel>> getPending() async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/admin/payment/get_pending.php',
      ),
    );

    final data = jsonDecode(response.body);

    List<PaymentModel> result = [];

    for (final item in data["data"]) {
      result.add(
        PaymentModel.fromJson(item),
      );
    }

    return result;
  }

  Future approve(int paymentId) async {
    await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/admin/payment/approve.php',
      ),
      body: {
        "payment_id": paymentId.toString(),
      },
    );
  }

  Future reject(int paymentId) async {
    await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/admin/payment/reject.php',
      ),
      body: {
        "payment_id": paymentId.toString(),
      },
    );
  }
}
