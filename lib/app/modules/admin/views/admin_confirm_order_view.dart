import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/admin_order_controller.dart';

class AdminConfirmOrderView extends StatelessWidget {
  final AdminOrder order;
  final AdminOrderController controller = Get.find<AdminOrderController>();

  // PERBAIKAN: Menghapus kata 'const' di depan konstruktor ini
  AdminConfirmOrderView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konfirmasi Pesanan', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF3A5A40),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Detail Pelanggan", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            Text("Lokasi: ${order.tableName}", style: GoogleFonts.poppins(fontSize: 14)),
            const SizedBox(height: 8),
            Text("Metode Pembayaran: Transfer / QRIS", style: GoogleFonts.poppins(fontSize: 14)),
            const SizedBox(height: 20),
            Text("Item Pesanan:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text("- $item", style: GoogleFonts.poppins()),
                )),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total:", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Rp ${order.totalAmount.toStringAsFixed(0)}",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF3A5A40))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A5A40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => controller.confirmPayment(order.id),
                child: Text("Confirm & Pay", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}