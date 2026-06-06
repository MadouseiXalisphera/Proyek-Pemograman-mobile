import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardView extends StatelessWidget {
  // Perbaikan Konstruktor
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF3A5A40),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ringkasan Penjualan", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  Text("Waktu Terbaik: Hari Ini", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar("Sen", 40),
                      _buildBar("Sel", 70),
                      _buildBar("Rab", 100),
                      _buildBar("Kam", 60),
                      _buildBar("Jum", 90),
                      _buildBar("Sab", 120),
                      _buildBar("Min", 110),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String day, double height) {
    return Column(
      children: [
        Container(
          height: height,
          width: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF3A5A40),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }
}