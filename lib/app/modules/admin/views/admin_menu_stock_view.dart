import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/admin_stock_controller.dart';
import 'admin_add_edit_menu_view.dart';

class AdminMenuStockView extends StatelessWidget {
  final AdminStockController stockController = Get.put(AdminStockController());

  // PERBAIKAN: Menghapus kata 'const' di depan konstruktor ini
  AdminMenuStockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Stock', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF3A5A40),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            // Gunakan const di instansiasi widget yang tidak punya variabel dinamis
            onPressed: () => Get.to(() => const AdminAddEditMenuView()), 
          )
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: stockController.menuStocks.length,
          itemBuilder: (context, index) {
            final item = stockController.menuStocks[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                    Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: item.isAvailable.value ? Colors.green : Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () => stockController.toggleStock(index),
                          child: Text(
                            item.isAvailable.value ? "Available" : "Empty",
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                          ),
                        )),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}