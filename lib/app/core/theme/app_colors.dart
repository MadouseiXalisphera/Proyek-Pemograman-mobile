import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════
// PALET WARNA CAFE AMBA
// Disamakan dengan Color_Palette.png (acuan resmi). Semua warna brand
// di-centralize di sini — jangan hardcode Color(0x...) di view manapun.
//
//   #000000  textPrimary        teks utama
//   #545454  textSecondary      teks sekunder / subtitle
//   #D9D9D9  fieldFill          isian field read-only (settings)
//   #EEEEEE  surfaceMuted/border kartu netral & garis tepi
//   #FFFFFF  surface            kartu, input, foreground
//   #425440  primary            forest green (brand)
//   #E4ECE7  background         sage mint (latar app)
//   #DC3545  danger             aksi destruktif (Logout/Empty/Clear all)
// ════════════════════════════════════════════════════════════════════════

class AppColors {
  AppColors._();

  // ── Background & surface ────────────────────────────────────────────
  static const Color background = Color(0xFFE4ECE7); // sage mint
  static const Color surface = Color(0xFFFFFFFF); // putih (kartu, input)
  static const Color surfaceMuted = Color(0xFFEEEEEE); // kartu netral (settings)
  static const Color fieldFill = Color(0xFFD9D9D9); // field read-only

  // ── Brand ───────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF425440); // forest green
  static const Color primaryLight = Color(0x80425440); // 50% (nav inactive)

  // ── Teks ────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF545454);

  // ── Status / aksi ───────────────────────────────────────────────────
  // danger: tombol destruktif sesuai desain (Logout, Empty, Clear all).
  static const Color danger = Color(0xFFDC3545);
  // error: dipakai khusus untuk validasi form (border merah TextFormField).
  static const Color error = Color(0xFFB00020);

  // ── Misc ────────────────────────────────────────────────────────────
  static const Color imagePlaceholder = Color(0xFF494949);
  static const Color border = Color(0xFFEEEEEE);
  static const Color statusBarText = Color(0xFF1D1B20);
}
