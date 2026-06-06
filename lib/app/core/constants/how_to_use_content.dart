/// Konten halaman "How to Use".
///
/// Sengaja dipisah dari UI supaya teks bisa diganti tanpa menyentuh widget.
/// Saat ini masih placeholder — ganti `items` dengan langkah pemesanan asli.
/// Saat migrasi Supabase, ini bisa diambil dari tabel `app_content` bila perlu
/// konten dinamis.
class HowToUseContent {
  HowToUseContent._();

  static const String title = 'How to Order';

  static const List<String> items = [
    'Pilih menu yang diinginkan dari halaman Home.',
    'Tekan tombol tambah (+) atau buka detail untuk mengatur jumlah dan catatan.',
    'Periksa pesanan di tab Cart, sesuaikan jumlah bila perlu.',
    'Tekan Confirm Order untuk lanjut ke halaman checkout.',
    'Isi nama dan email, lalu pilih metode pembayaran.',
    'Selesaikan pembayaran sesuai instruksi yang muncul.',
    'Tunggu pesanan diproses dapur — status bisa dilihat di tab Order.',
    'Ambil pesanan saat statusnya sudah siap diambil.',
  ];
}
