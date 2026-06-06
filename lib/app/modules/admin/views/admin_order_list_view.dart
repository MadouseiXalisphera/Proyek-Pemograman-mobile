import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/admin_order_controller.dart';
import 'admin_confirm_order_view.dart';

class AdminOrderListView extends StatelessWidget {
  final AdminOrderController orderController = Get.put(AdminOrderController());

  // PERBAIKAN: Menghapus kata 'const' di depan konstruktor ini
  AdminOrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pesanan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF3A5A40),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (orderController.activeOrders.isEmpty) {
          return Center(child: Text("Tidak ada antrean pesanan.", style: GoogleFonts.poppins()));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orderController.activeOrders.length,
          itemBuilder: (context, index) {
            final order = orderController.activeOrders[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(order.tableName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                subtitle: Text(order.items.join(", "), style: GoogleFonts.poppins()),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF3A5A40)),
                onTap: () {
                  // Di sini tidak menggunakan const karena AdminConfirmOrderView butuh data objek 'order' dinamis
                  Get.to(() => AdminConfirmOrderView(order: order)); 
                },
              ),
            );
          },
        );
      }),
    );
  }
}