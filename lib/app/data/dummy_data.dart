// Data dummy untuk fase lokal (sebelum Supabase).
// Saat migrasi Supabase, file ini bisa dihapus — data diambil dari tabel
// `auth_users`, `menu`, dan kolom Storage untuk foto.
//
// Catatan penting:
// - Username & namaMeja TIDAK di-parse satu sama lain (formatnya bebas).
// - Mapping dilakukan eksplisit di sini (dan nanti di kolom Supabase).
// - fotoPath menunjuk ke aset bundel `assets/menu/<id>.jpg`. Selama file
//   belum ada, AppMenuImage otomatis menampilkan placeholder (tidak error).
//   Saat migrasi Supabase, ganti nilai ini dengan URL Storage (https://...)
//   tanpa mengubah widget apa pun.

import 'models/menu_item_model.dart';

class DummyData {
  DummyData._();

  static const List<Map<String, dynamic>> users = [
    {
      'username': 'tablet_A1',
      'password': '12345',
      'role': 'user',
      'namaMeja': 'Meja A1',
    },
    {
      'username': 'tablet_B2',
      'password': '12345',
      'role': 'user',
      'namaMeja': 'Meja B2',
    },
    {
      'username': 'tablet_VIP',
      'password': '12345',
      'role': 'user',
      'namaMeja': 'VIP Room',
    },
    {
      'username': 'kasir01',
      'password': 'kasir',
      'role': 'admin',
      'namaMeja': null,
    },
    {
      'username': 'dapur01',
      'password': 'dapur',
      'role': 'kitchen',
      'namaMeja': null,
    },
  ];

  static final List<MenuItem> menu = [
    MenuItem(
      id: 'kopi_hitam',
      nama: 'Kopi Hitam',
      deskripsi: 'Kopi arabica pilihan, diseduh dengan metode pour over',
      harga: 18000,
      kategori: 'drink',
      fotoPath: 'assets/menu/kopi_hitam.jpg',
      isTopPick: true,
      stock: 10,
    ),
    MenuItem(
      id: 'matcha_latte',
      nama: 'Matcha Latte',
      deskripsi: 'Matcha premium Jepang dicampur susu segar hangat atau dingin',
      harga: 28000,
      kategori: 'drink',
      fotoPath: 'assets/menu/matcha_latte.jpg',
      isTopPick: true,
      stock: 10,
    ),
    MenuItem(
      id: 'lemon_tea',
      nama: 'Lemon Tea',
      deskripsi: 'Teh dengan perasan lemon segar, manis dan asam yang seimbang',
      harga: 15000,
      kategori: 'drink',
      fotoPath: 'assets/menu/lemon_tea.jpg',
      isTopPick: true,
      stock: 10,
    ),
    MenuItem(
      id: 'es_teh_manis',
      nama: 'Es Teh Manis',
      deskripsi: 'Teh manis segar dengan es batu, cocok untuk cuaca panas',
      harga: 8000,
      kategori: 'drink',
      fotoPath: 'assets/menu/es_teh_manis.jpg',
      stock: 10,
    ),
    MenuItem(
      id: 'nasi_goreng',
      nama: 'Nasi Goreng',
      deskripsi: 'Nasi goreng bumbu spesial cafe, dilengkapi telur dan kerupuk',
      harga: 35000,
      kategori: 'food',
      fotoPath: 'assets/menu/nasi_goreng.jpg',
      isTopPick: true,
      stock: 10,
    ),
    MenuItem(
      id: 'roti_bakar',
      nama: 'Roti Bakar',
      deskripsi:
          'Roti tawar panggang dengan pilihan topping selai atau mentega',
      harga: 22000,
      kategori: 'food',
      fotoPath: 'assets/menu/roti_bakar.jpg',
      stock: 10,
    ),
    MenuItem(
      id: 'pisang_goreng',
      nama: 'Pisang Goreng',
      deskripsi:
          'Pisang kepok goreng crispy, disajikan dengan keju atau coklat',
      harga: 18000,
      kategori: 'food',
      fotoPath: 'assets/menu/pisang_goreng.jpg',
      stock: 10,
    ),
    MenuItem(
      id: 'mie_goreng',
      nama: 'Mie Goreng',
      deskripsi:
          'Mie goreng dengan bumbu khas, sayuran segar, dan telur ceplok',
      harga: 32000,
      kategori: 'food',
      fotoPath: 'assets/menu/mie_goreng.jpg',
      stock: 10,
    ),
  ];
}
