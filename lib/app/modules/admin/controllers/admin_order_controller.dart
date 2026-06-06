import 'package:get/get.dart';

class AdminOrder {
  final String id;
  final String tableName;
  final List<String> items;
  final double totalAmount;
  var isPaid = false.obs;

  AdminOrder({required this.id, required this.tableName, required this.items, required this.totalAmount});
}

class AdminOrderController extends GetxController {
  // Simulasi data antrean dari QRIS / Cash masuk
  var activeOrders = <AdminOrder>[
    AdminOrder(id: "ORD001", tableName: "Meja A1", items: ["Burger x2", "Lemon Ice Tea x1"], totalAmount: 171000),
    AdminOrder(id: "ORD002", tableName: "Meja B2", items: ["Burger x1", "Lemon Ice Tea x2"], totalAmount: 95000),
  ].obs;

  void confirmPayment(String orderId) {
    int index = activeOrders.indexWhere((element) => element.id == orderId);
    if (index != -1) {
      // Logic integrasi ke Kitchen melalui OrderService real-time nantinya
      activeOrders.removeAt(index);
      Get.back(); // Tutup halaman konfirmasi
      Get.snackbar("Sukses", "Pembayaran divalidasi, pesanan diteruskan ke Kitchen!",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}