import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/admin_dashboard_controller.dart';

// Ubah StatelessWidget menjadi GetView agar terhubung dengan Controller
class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Memanggil controller agar datanya siap digunakan
    Get.put(AdminDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF3A5A40),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ringkasan Penjualan",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Waktu Terbaik: Hari Ini",
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.grey[600])),
                  const SizedBox(height: 20),

                  // Ganti blok SizedBox yang berisi Obx(() => BarChart) menjadi ini:
                  SizedBox(
                    height: 200,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          // Gunakan batas atas yang dihitung dari controller
                          maxY: controller.maxSales.value,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                // Tampilkan harga dengan tooltip saat bar ditekan
                                return BarTooltipItem(
                                  'Rp ${rod.toY.toInt()}',
                                  const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = [
                                    'Sen',
                                    'Sel',
                                    'Rab',
                                    'Kam',
                                    'Jum',
                                    'Sab',
                                    'Min'
                                  ];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      days[value.toInt()],
                                      style: GoogleFonts.poppins(fontSize: 12),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(
                            controller.salesData.length,
                            (index) => BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: controller.salesData[index],
                                  color: const Color(0xFF3A5A40),
                                  width: 20,
                                  borderRadius: BorderRadius.circular(4),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
