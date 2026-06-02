import 'package:flutter/material.dart';

// Color palette diambil dari Figma "Proyek PemWeb".
// Catatan: semua warna brand di-centralize di sini.

class AppColors {
  AppColors._();

  // Background
  static const Color background = Color(0xFFE4ECE7);   // sage mint
  static const Color surface = Color(0xFFFFFFFF);      // putih (kartu, input)

  // Brand
  static const Color primary = Color(0xFF425440);          // forest green
  static const Color primaryLight = Color(0x80425440);     // 50% opacity (nav inactive)

  // Text
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF404040);

  // Misc
  static const Color imagePlaceholder = Color(0xFF494949);
  static const Color border = Color(0xFFEEEEEE);
  static const Color error = Color(0xFFB00020);

  // M3 status bar text
  static const Color statusBarText = Color(0xFF1D1B20);
}
